local _G, SUI = _G, SUI
local Artwork_Core = SUI:GetModule('Component_Artwork')
local module = SUI:GetModule('Style_Fel')
----------------------------------------------------------------------------------------------------
module.Trays = {}
local CurScale
local petbattle = CreateFrame('Frame')
local StatusBarSettings = {
	bars = {
		'Fel_StatusBar_Left',
		'Fel_StatusBar_Right'
	},
	Fel_StatusBar_Left = {
		bgImg = 'Interface\\AddOns\\SpartanUI\\Themes\\Classic\\Images\\status-plate-exp',
		size = {370, 20},
		TooltipSize = {400, 100},
		TooltipTextSize = {380, 90},
		texCords = {0.150390625, 1, 0, 1},
		GlowPoint = {x = -10},
		MaxWidth = 32,
		bgTooltip = 'Interface\\AddOns\\SpartanUI\\Themes\\Fel\\Images\\Fel-Box',
		texCordsTooltip = {0.03125, 0.96875, 0.2578125, 0.7578125}
	},
	Fel_StatusBar_Right = {
		bgImg = 'Interface\\AddOns\\SpartanUI\\Themes\\Classic\\Images\\status-plate-exp',
		Grow = 'RIGHT',
		size = {370, 20},
		TooltipSize = {400, 100},
		TooltipTextSize = {380, 90},
		texCords = {0.150390625, 1, 0, 1},
		GlowPoint = {x = 10},
		MaxWidth = 35,
		bgTooltip = 'Interface\\AddOns\\SpartanUI\\Themes\\Fel\\Images\\Fel-Box',
		texCordsTooltip = {0.03125, 0.96875, 0.2578125, 0.7578125}
	}
}

-- Misc Framework stuff
function module:updateScale()
	if (not SUI.DB.scale) then -- make sure the variable exists, and auto-configured based on screen size
		local Resolution = ''
		if select(4, GetBuildInfo()) >= 70000 then
			Resolution = GetCVar('gxWindowedResolution')
		else
			Resolution = GetCVar('gxResolution')
		end

		local width, height = string.match(Resolution, '(%d+).-(%d+)')
		if (tonumber(width) / tonumber(height) > 4 / 3) then
			SUI.DB.scale = 0.92
		else
			SUI.DB.scale = 0.78
		end
	end
	if SUI.DB.scale ~= CurScale then
		if (SUI.DB.scale ~= SUI:round(SUI_Art_Fel:GetScale())) then
			SUI_Art_Fel:SetScale(SUI.DB.scale)
		end
		local StatusBars = SUI:GetModule('Artwork_StatusBars')
		for _, key in ipairs(StatusBarSettings.bars) do
			StatusBars.bars[key]:SetScale(SUI.DB.scale)
		end
		CurScale = SUI.DB.scale
	end
end

function module:updateAlpha()
	if SUI.DB.alpha then
		SUI_Art_Fel.Left:SetAlpha(SUI.DB.alpha)
		SUI_Art_Fel.Right:SetAlpha(SUI.DB.alpha)
	end
	-- Update Action bar backgrounds
	for i = 1, 4 do
		if SUI.DB.Styles.Fel.Artwork['bar' .. i].enable then
			_G['Fel_Bar' .. i]:Show()
			_G['Fel_Bar' .. i]:SetAlpha(SUI.DB.Styles.Fel.Artwork['bar' .. i].alpha)
		else
			_G['Fel_Bar' .. i]:Hide()
		end
		if SUI.DB.Styles.Fel.Artwork.Stance.enable then
			_G['Fel_StanceBar']:Show()
			_G['Fel_StanceBar']:SetAlpha(SUI.DB.Styles.Fel.Artwork.Stance.alpha)
		else
			_G['Fel_StanceBar']:Hide()
		end
		if SUI.DB.Styles.Fel.Artwork.MenuBar.enable then
			_G['Fel_MenuBar']:Show()
			_G['Fel_MenuBar']:SetAlpha(SUI.DB.Styles.Fel.Artwork.MenuBar.alpha)
		else
			_G['Fel_MenuBar']:Hide()
		end
	end
end

--	Module Calls
function module:TooltipLoc(_, parent)
	if (parent == 'UIParent') then
		tooltip:ClearAllPoints()
		tooltip:SetPoint('BOTTOMRIGHT', 'SUI_Art_Fel', 'TOPRIGHT', 0, 10)
	end
end

function module:BuffLoc(_, parent)
	BuffFrame:ClearAllPoints()
	BuffFrame:SetPoint('TOPRIGHT', -13, -13 - (SUI.DB.BuffSettings.offset))
end

function module:SetupVehicleUI()
	if SUI.DBMod.Artwork.VehicleUI then
		petbattle:HookScript(
			'OnHide',
			function()
				if SUI.DB.EnabledComponents.Minimap and ((SUI.DB.MiniMap.AutoDetectAllowUse) or (SUI.DB.MiniMap.ManualAllowUse)) then
					Minimap:Hide()
				end
				SUI_Art_Fel:Hide()
			end
		)
		petbattle:HookScript(
			'OnShow',
			function()
				if SUI.DB.EnabledComponents.Minimap and ((SUI.DB.MiniMap.AutoDetectAllowUse) or (SUI.DB.MiniMap.ManualAllowUse)) then
					Minimap:Show()
				end
				SUI_Art_Fel:Show()
			end
		)
		RegisterStateDriver(petbattle, 'visibility', '[petbattle] hide; show')
		RegisterStateDriver(SUI_Art_Fel, 'visibility', '[overridebar][vehicleui] hide; show')
		RegisterStateDriver(SpartanUI, 'visibility', '[petbattle][overridebar][vehicleui] hide; show')
	end
end

function module:RemoveVehicleUI()
	if SUI.DBMod.Artwork.VehicleUI then
		UnregisterStateDriver(petbattle, 'visibility')
		UnregisterStateDriver(SUI_Art_Fel, 'visibility')
		UnregisterStateDriver(SpartanUI, 'visibility')
	end
end

function module:InitArtwork()
	plate = CreateFrame('Frame', 'Fel_ActionBarPlate', UIParent, 'Fel_ActionBarsTemplate')
	plate:SetFrameStrata('BACKGROUND')
	plate:SetFrameLevel(1)
	plate:SetPoint('BOTTOM')

	FramerateText:ClearAllPoints()
	FramerateText:SetPoint('TOPLEFT', UIParent, 'TOPLEFT', 10, -10)
end

function module:EnableArtwork()
	SUI_Art_Fel:SetFrameStrata('BACKGROUND')
	SUI_Art_Fel:SetFrameLevel(1)

	SUI_Art_Fel.Left = SUI_Art_Fel:CreateTexture('SUI_Art_Fel_Left', 'BORDER')
	SUI_Art_Fel.Left:SetPoint('BOTTOMRIGHT', UIParent, 'BOTTOM', 0, 0)

	SUI_Art_Fel.Right = SUI_Art_Fel:CreateTexture('SUI_Art_Fel_Right', 'BORDER')
	SUI_Art_Fel.Right:SetPoint('LEFT', SUI_Art_Fel.Left, 'RIGHT', 0, 0)
	local barBG

	if SUI.DB.Styles.Fel.SubTheme == 'Digital' then
		SUI_Art_Fel.Left:SetTexture('Interface\\AddOns\\SpartanUI\\Themes\\Fel\\Digital\\Base_Bar_Left')
		SUI_Art_Fel.Right:SetTexture('Interface\\AddOns\\SpartanUI\\Themes\\Fel\\Digital\\Base_Bar_Right')
		barBG = 'Interface\\AddOns\\SpartanUI\\Themes\\Fel\\Digital\\Fel-Box'
	else
		SUI_Art_Fel.Left:SetTexture('Interface\\AddOns\\SpartanUI\\Themes\\Fel\\Images\\Base_Bar_Left')
		SUI_Art_Fel.Right:SetTexture('Interface\\AddOns\\SpartanUI\\Themes\\Fel\\Images\\Base_Bar_Right')
	end

	if barBG then
		for i = 1, 4 do
			_G['Fel_Bar' .. i .. 'BG']:SetTexture(barBG)
		end

		Fel_MenuBarBG:SetTexture(barBG)
		Fel_StanceBarBG:SetTexture(barBG)
	end

	Fel_ActionBarPlate:ClearAllPoints()
	Fel_ActionBarPlate:SetPoint('BOTTOM', SpartanUI, 'BOTTOM', 0, offset)

	hooksecurefunc(
		'UIParent_ManageFramePositions',
		function()
			if TutorialFrameAlertButton then
				TutorialFrameAlertButton:SetParent(Minimap)
				TutorialFrameAlertButton:ClearAllPoints()
				TutorialFrameAlertButton:SetPoint('CENTER', Minimap, 'TOP', -2, 30)
			end
			CastingBarFrame:ClearAllPoints()
			CastingBarFrame:SetPoint('BOTTOM', SUI_Art_Fel, 'TOP', 0, 90)
		end
	)

	MainMenuBarVehicleLeaveButton:HookScript(
		'OnShow',
		function()
			MainMenuBarVehicleLeaveButton:ClearAllPoints()
			MainMenuBarVehicleLeaveButton:SetPoint('LEFT', SUI_playerFrame, 'RIGHT', 15, 0)
		end
	)

	module:SetupVehicleUI()

	if SUI.DB.EnabledComponents.Minimap and ((SUI.DB.MiniMap.AutoDetectAllowUse) or (SUI.DB.MiniMap.ManualAllowUse)) then
		module:MiniMap()
	end

	module:StatusBars()
	module:updateAlpha()
	module:updateScale()
end

function module:StatusBars()
	local StatusBars = SUI:GetModule('Artwork_StatusBars')
	StatusBars:Initalize(StatusBarSettings)

	-- Position the StatusBars
	StatusBars.bars.Fel_StatusBar_Left:SetPoint('BOTTOMRIGHT', SUI_Art_Fel, 'BOTTOM', -100, 0)
	StatusBars.bars.Fel_StatusBar_Right:SetPoint('BOTTOMLEFT', SUI_Art_Fel, 'BOTTOM', 100, 0)
end

-- Minimap
function module:MiniMapUpdate()
	if Minimap.BG then
		Minimap.BG:ClearAllPoints()
	end

	if SUI.DB.Styles.Fel.SubTheme == 'Digital' then
		Minimap.BG:SetTexture('Interface\\AddOns\\SpartanUI\\Themes\\Fel\\Digital\\Minimap')
		Minimap.BG:SetPoint('CENTER', Minimap, 'CENTER', 5, -1)
		Minimap.BG:SetSize(256, 256)
		Minimap.BG:SetBlendMode('ADD')
	else
		if SUI.DB.Styles.Fel.Minimap.Engulfed then
			Minimap.BG:SetTexture('Interface\\AddOns\\SpartanUI\\Themes\\Fel\\Images\\Minimap-Engulfed')
			Minimap.BG:SetPoint('CENTER', Minimap, 'CENTER', 7, 37)
			Minimap.BG:SetSize(330, 330)
			Minimap.BG:SetBlendMode('ADD')
		else
			Minimap.BG:SetTexture('Interface\\AddOns\\SpartanUI\\Themes\\Fel\\Images\\Minimap-Calmed')
			Minimap.BG:SetPoint('CENTER', Minimap, 'CENTER', 5, -1)
			Minimap.BG:SetSize(256, 256)
			Minimap.BG:SetBlendMode('ADD')
		end
	end
end

function module:MiniMap()
	if Minimap.ZoneText ~= nil then
		Minimap.ZoneText:ClearAllPoints()
		Minimap.ZoneText:SetPoint('TOPLEFT', Minimap, 'BOTTOMLEFT', 0, -5)
		Minimap.ZoneText:SetPoint('TOPRIGHT', Minimap, 'BOTTOMRIGHT', 0, -5)
		Minimap.ZoneText:Hide()
		MinimapZoneText:Show()
	end

	Minimap.BG = Minimap:CreateTexture(nil, 'BACKGROUND')
	SUI:GetModule('Component_Minimap'):ShapeChange('circle')

	module:MiniMapUpdate()

	SUI_Art_Fel:HookScript(
		'OnHide',
		function(this, event)
			Minimap:ClearAllPoints()
			Minimap:SetPoint('TOPRIGHT', UIParent, 'TOPRIGHT', -20, -20)
			SUI:GetModule('Component_Minimap'):ShapeChange('square')
		end
	)

	SUI_Art_Fel:HookScript(
		'OnShow',
		function(this, event)
			Minimap:ClearAllPoints()
			Minimap:SetPoint('CENTER', SUI_Art_Fel, 'CENTER', 0, 54)
			SUI:GetModule('Component_Minimap'):ShapeChange('circle')
		end
	)
end
