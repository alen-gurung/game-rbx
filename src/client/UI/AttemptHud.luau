--!strict
-- Native attempt HUD: launch, wind meter, Leave, result panel with Retry, and a cancel notice. Created once per client
-- (ResetOnSpawn = false), so retries and respawns never stack interfaces. Buttons stay disabled after a press until the
-- next server state arrives.
local Theme = require(script.Parent.Theme)

export type AttemptHud = {
	setState: (self: AttemptHud, data: any, resultVisible: boolean?) -> (),
	setWind: (self: AttemptHud, fraction: number) -> (),
	destroy: (self: AttemptHud) -> (),
}

local function rgb(values: { number }): Color3
	return Color3.fromRGB(values[1], values[2], values[3])
end

local function decorate(object: GuiObject, stroke: boolean)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, Theme.cornerRadius)
	corner.Parent = object
	if stroke then
		local outline = Instance.new("UIStroke")
		outline.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		outline.Color = rgb(Theme.colors.stroke)
		outline.Thickness = Theme.strokeThickness
		outline.Parent = object
	end
end

local function label(parent: Instance, text: string, size: number, color: { number }): TextLabel
	local object = Instance.new("TextLabel")
	object.BackgroundTransparency = 1
	object.Font = (Enum.Font :: any)[Theme.font]
	object.Text = text
	object.TextSize = size
	object.TextColor3 = rgb(color)
	object.Parent = parent
	return object
end

local function button(parent: Instance, text: string, size: number, fill: { number }, ink: { number }): TextButton
	local object = Instance.new("TextButton")
	object.AutoButtonColor = true
	object.BackgroundColor3 = rgb(fill)
	object.Font = (Enum.Font :: any)[Theme.font]
	object.Text = text
	object.TextSize = size
	object.TextColor3 = rgb(ink)
	decorate(object, true)
	object.Parent = parent
	return object
end

local function windColor(fraction: number): Color3
	local colors = Theme.colors
	if fraction >= 0.5 then
		return rgb(colors.windMid):Lerp(rgb(colors.windFull), (fraction - 0.5) * 2)
	end
	return rgb(colors.windEmpty):Lerp(rgb(colors.windMid), fraction * 2)
end

local AttemptHud = {}

function AttemptHud.new(playerGui: Instance, onAction: (action: string) -> ()): AttemptHud
	local colors = Theme.colors
	local gui = Instance.new("ScreenGui")
	gui.Name = "DuckAttemptHud"
	gui.ResetOnSpawn = false
	gui.IgnoreGuiInset = false
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	local launch = button(gui, Theme.launch.text, Theme.launch.textSize, colors.primary, colors.primaryText)
	launch.Name = "Launch"
	launch.AnchorPoint = Vector2.new(0.5, 1)
	launch.Position = UDim2.new(0.5, 0, 1, -Theme.launch.bottomMargin)
	launch.Size = UDim2.fromOffset(Theme.launch.width, Theme.launch.height)

	local leave = button(gui, Theme.leave.text, Theme.leave.textSize, colors.secondary, colors.secondaryText)
	leave.Name = "Leave"
	leave.AnchorPoint = Vector2.new(1, 1)
	leave.Position = UDim2.new(1, -Theme.leave.margin, 1, -Theme.leave.margin)
	leave.Size = UDim2.fromOffset(Theme.leave.width, Theme.leave.height)

	local meter = Instance.new("Frame")
	meter.Name = "WindMeter"
	meter.AnchorPoint = Vector2.new(0.5, 0)
	meter.Position = UDim2.new(0.5, 0, 0, Theme.meter.topMargin)
	meter.Size = UDim2.fromOffset(Theme.meter.width, Theme.meter.height)
	meter.BackgroundColor3 = rgb(colors.meterTrack)
	meter.BackgroundTransparency = 0.15
	decorate(meter, true)
	meter.Parent = gui
	local fill = Instance.new("Frame")
	fill.Name = "Fill"
	fill.BorderSizePixel = 0
	fill.Size = UDim2.fromScale(1, 1)
	fill.BackgroundColor3 = rgb(colors.windFull)
	decorate(fill, false)
	fill.Parent = meter
	local meterText = label(meter, Theme.meter.label, Theme.meter.textSize, colors.panelText)
	meterText.Size = UDim2.fromScale(1, 1)
	meterText.TextStrokeTransparency = 0.4
	meterText.ZIndex = 2

	local result = Instance.new("Frame")
	result.Name = "Result"
	result.AnchorPoint = Vector2.new(0.5, 1)
	result.Position = UDim2.new(0.5, 0, 1, -Theme.result.bottomMargin)
	result.Size = UDim2.new(Theme.result.widthScale, 0, 0, Theme.result.height)
	result.BackgroundColor3 = rgb(colors.panel)
	result.BackgroundTransparency = 0.08
	decorate(result, false)
	local limit = Instance.new("UISizeConstraint")
	limit.MaxSize = Vector2.new(Theme.result.maxWidth, math.huge)
	limit.Parent = result
	result.Parent = gui
	local title = label(result, "", Theme.result.titleSize, colors.panelText)
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Position = UDim2.fromOffset(Theme.result.padding, Theme.result.titleTop)
	title.Size = UDim2.new(1, -(Theme.result.retryWidth + 48), 0, 34)
	title.TextScaled = false
	title.TextWrapped = true
	local detail = label(result, "", Theme.result.detailSize, colors.mutedText)
	detail.TextXAlignment = Enum.TextXAlignment.Left
	detail.Position = UDim2.fromOffset(Theme.result.padding, Theme.result.detailTop)
	detail.Size = UDim2.new(1, -(Theme.result.retryWidth + 48), 0, 28)
	local retry = button(result, Theme.result.retryText, Theme.result.titleSize, colors.primary, colors.primaryText)
	retry.Name = "Retry"
	retry.AnchorPoint = Vector2.new(1, 0.5)
	retry.Position = UDim2.new(1, -16, 0.5, 0)
	retry.Size = UDim2.fromOffset(Theme.result.retryWidth, Theme.result.retryHeight)

	local notice = label(gui, Theme.notice.text, Theme.notice.textSize, colors.panelText)
	notice.Name = "Notice"
	notice.AnchorPoint = Vector2.new(0.5, 1)
	notice.Position = UDim2.new(0.5, 0, 1, -(Theme.launch.bottomMargin + Theme.launch.height + 12))
	notice.Size = UDim2.fromOffset(360, 30)
	notice.TextStrokeTransparency = 0.3
	notice.Visible = false

	local buttons = { launch, leave, retry }
	local noticeToken = 0
	local pressToken = 0
	local function setEnabled(enabled: boolean)
		for _, object in buttons do
			object.Active = enabled
			object.AutoButtonColor = enabled
			object.BackgroundTransparency = if enabled then 0 else 0.35
		end
	end
	local function press(action: string)
		return function()
			if not launch.Active and action == "RequestLaunch" then
				return
			end
			if not leave.Active and action == "RequestCancel" then
				return
			end
			if not retry.Active and action == "RequestRetry" then
				return
			end
			setEnabled(false)
			pressToken += 1
			local token = pressToken
			-- Fallback: the server drops rate-limited requests without replying.
			task.delay(1, function()
				if token == pressToken then
					setEnabled(true)
				end
			end)
			onAction(action)
		end
	end
	local connections = {
		launch.Activated:Connect(press("RequestLaunch")),
		leave.Activated:Connect(press("RequestCancel")),
		retry.Activated:Connect(press("RequestRetry")),
	}

	local self = {} :: any

	function self.setState(_: AttemptHud, data: any, resultVisible: boolean?)
		local state = data.state
		pressToken += 1
		setEnabled(true)
		launch.Visible = state == "Ready"
		leave.Visible = state == "Winding" or state == "Running"
		meter.Visible = state == "Winding" or state == "Running"
		result.Visible = state == "Ended" and resultVisible == true
		if result.Visible then
			title.Text = if data.outcome == "finished" then Theme.result.finishedTitle else Theme.result.exhaustedTitle
			detail.Text = string.format("Distance: %.1f studs", data.distance or 0)
		end
		if state == "Ready" and data.cancelled then
			noticeToken += 1
			local token = noticeToken
			notice.Visible = true
			task.delay(Theme.notice.seconds, function()
				if token == noticeToken then
					notice.Visible = false
				end
			end)
		elseif state ~= "Ready" then
			noticeToken += 1
			notice.Visible = false
		end
	end

	function self.setWind(_: AttemptHud, fraction: number)
		local value = math.clamp(fraction, 0, 1)
		fill.Size = UDim2.fromScale(value, 1)
		fill.Visible = value > 0.001
		fill.BackgroundColor3 = windColor(value)
	end

	function self.destroy(_: AttemptHud)
		for _, connection in connections do
			connection:Disconnect()
		end
		gui:Destroy()
	end

	self.setState(self, { state = "Ready" }, false)
	gui.Parent = playerGui
	return self :: AttemptHud
end

return AttemptHud
