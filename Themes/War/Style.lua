local SUI, L = SUI, SUI.L
local print, error = SUI.print, SUI.Error
local Artwork_Core = SUI:GetModule('Component_Artwork')
local module = SUI:NewModule('Style_War')
local Artwork_Core = SUI:GetModule('Component_Artwork')
local UnitFrames = SUI:GetModule('Component_UnitFrames')
local artFrame = CreateFrame('Frame', 'SUI_Art_War', SpartanUI)
module.Settings = {}
module.Trays = {}
module.StatusBarSettings = {
	bars = {
		'StatusBar_Left',
		'StatusBar_Right'
	},
	StatusBar_Left = {
		bgImg = 'Interface\\AddOns\\SpartanUI\\Themes\\War\\Images\\StatusBar-' .. UnitFactionGroup('Player'),
		size = {370, 20},
		TooltipSize = {350, 100},
		TooltipTextSize = {330, 80},
		texCords = {0.0546875, 0.9140625, 0.5555555555555556, 0},
		GlowPoint = {x = -16},
		MaxWidth = 48
	},
	StatusBar_Right = {
		bgImg = 'Interface\\AddOns\\SpartanUI\\Themes\\War\\Images\\StatusBar-' .. UnitFactionGroup('Player'),
		Grow = 'RIGHT',
		size = {370, 20},
		TooltipSize = {350, 100},
		TooltipTextSize = {330, 80},
		texCords = {0.0546875, 0.9140625, 0.5555555555555556, 0},
		GlowPoint = {x = 16},
		MaxWidth = 48
	}
}
----------------------------------------------------------------------------------------------------
local InitRan = false
function module:OnInitialize()
	-- Bartender 4 Settings
	local BarHandler = SUI:GetModule('Component_BarHandler')
	BarHandler.BarPosition.BT4.War = {
		['BT4BarExtraActionBar'] = 'BOTTOM,SUI_ActionBarAnchor,TOP,0,70',
		--
		['BT4BarStanceBar'] = 'TOP,SpartanUI,TOP,-309,0',
		['BT4BarPetBar'] = 'TOP,SpartanUI,TOP,-558,0',
		--
		['BT4BarMicroMenu'] = 'TOP,SpartanUI,TOP,369,0',
		['BT4BarBagBar'] = 'TOP,SpartanUI,TOP,680,0'
	}

	-- Unitframes Settings
	local UnitFrames = SUI:GetModule('Component_UnitFrames')
	local Images = {
		Alliance = {
			bg = {
				Coords = {0, 0.458984375, 0.74609375, 1}
			},
			top = {
				Coords = {0.03125, 0.427734375, 0, 0.421875}
			},
			bottom = {
				Coords = {0.541015625, 1, 0, 0.421875}
			}
		},
		Horde = {
			bg = {
				Coords = {0.572265625, 0.96875, 0.74609375, 1}
			},
			top = {
				Coords = {0.541015625, 1, 0, 0.421875}
			},
			bottom = {
				Coords = {0.541015625, 1, 0, 0.421875}
			}
		}
	}
	local pathFunc = function(frame, position)
		local factionGroup = UnitFactionGroup(frame.unit) or 'Neutral'
		if factionGroup == 'Horde' or factionGroup == 'Alliance' then
			return 'Interface\\AddOns\\SpartanUI\\Themes\\War\\Images\\UnitFrames'
		end
		if position == 'bg' then
			return 'Interface\\AddOns\\SpartanUI\\images\\textures\\Smoothv2'
		end

		return false
	end
	local TexCoordFunc = function(frame, position)
		local factionGroup = UnitFactionGroup(frame.unit) or 'Neutral'

		if factionGroup == 'Horde' then
			-- Horde Graphics
			if position == 'top' then
				return {0.541015625, 1, 0, 0.1796875}
			elseif position == 'bg' then
				return {0.572265625, 0.96875, 0.74609375, 1}
			elseif position == 'bottom' then
				return {0.541015625, 1, 0.37109375, 0.421875}
			end
		elseif factionGroup == 'Alliance' then
			-- Alliance Graphics
			if position == 'top' then
				return {0.03125, 0.458984375, 0, 0.1796875}
			elseif position == 'bg' then
				return {0, 0.458984375, 0.74609375, 1}
			elseif position == 'bottom' then
				return {0.03125, 0.458984375, 0.37109375, 0.421875}
			end
		else
			return {1, 1, 1, 1}
		end
	end
	UnitFrames.Artwork.war = {
		name = 'War',
		top = {
			path = pathFunc,
			TexCoord = TexCoordFunc,
			heightScale = .225,
			yScale = -.0555,
			PVPAlpha = .6
		},
		bg = {
			path = pathFunc,
			TexCoord = TexCoordFunc,
			PVPAlpha = .7
		},
		bottom = {
			path = pathFunc,
			TexCoord = TexCoordFunc,
			heightScale = .0825,
			yScale = 0.0223,
			PVPAlpha = .7
			-- height = 40,
			-- y = 40,
			-- alpha = 1,
			-- VertexColor = {0, 0, 0, .6},
			-- position = {Pos table},
			-- scale = 1,
		}
	}
	-- Default frame posistions
	UnitFrames.FramePos['War'] = {
		['player'] = 'BOTTOMRIGHT,UIParent,BOTTOM,-45,250'
	}
	module:CreateArtwork()
end

function module:OnEnable()
	if (SUI.DBMod.Artwork.Style ~= 'War') then
		module:Disable()
	else
		--Setup Sliding Trays
		module:SlidingTrays()
		if BT4BarBagBar and BT4BarPetBar.position then
			BT4BarPetBar:position('TOPLEFT', module.Trays.left, 'TOPLEFT', 50, -2)
			BT4BarStanceBar:position('TOPRIGHT', module.Trays.left, 'TOPRIGHT', -50, -2)
			BT4BarMicroMenu:position('TOPLEFT', module.Trays.right, 'TOPLEFT', 50, -2)
			BT4BarBagBar:position('TOPRIGHT', module.Trays.right, 'TOPRIGHT', -100, -2)
		end

		War_ActionBarPlate:ClearAllPoints()
		War_ActionBarPlate:SetPoint('BOTTOM', SpartanUI, 'BOTTOM', 0, offset)

		hooksecurefunc(
			'UIParent_ManageFramePositions',
			function()
				if TutorialFrameAlertButton then
					TutorialFrameAlertButton:SetParent(Minimap)
					TutorialFrameAlertButton:ClearAllPoints()
					TutorialFrameAlertButton:SetPoint('CENTER', Minimap, 'TOP', -2, 30)
				end
				CastingBarFrame:ClearAllPoints()
				CastingBarFrame:SetPoint('BOTTOM', SUI_Art_War, 'TOP', 0, 90)
			end
		)

		module:SetupVehicleUI()

		if SUI.DB.EnabledComponents.Minimap and ((SUI.DB.MiniMap.AutoDetectAllowUse) or (SUI.DB.MiniMap.ManualAllowUse)) then
			module:MiniMap()
		end

		module:StatusBars()
	end
end

function module:OnDisable()
	SUI_Art_War:Hide()
end

local CurScale, plate
local petbattle = CreateFrame('Frame')

--	Module Calls
function module:TooltipLoc(_, parent)
	if (parent == 'UIParent') then
		tooltip:ClearAllPoints()
		tooltip:SetPoint('BOTTOMRIGHT', 'SUI_Art_War', 'TOPRIGHT', 0, 10)
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
				SUI_Art_War:Hide()
				if SUI.DB.EnabledComponents.Minimap and ((SUI.DB.MiniMap.AutoDetectAllowUse) or (SUI.DB.MiniMap.ManualAllowUse)) then
					Minimap:Hide()
				end
			end
		)
		petbattle:HookScript(
			'OnShow',
			function()
				SUI_Art_War:Show()
				if SUI.DB.EnabledComponents.Minimap and ((SUI.DB.MiniMap.AutoDetectAllowUse) or (SUI.DB.MiniMap.ManualAllowUse)) then
					Minimap:Show()
				end
			end
		)
		SUI_Art_War:HookScript(
			'OnShow',
			function()
				Artwork_Core:trayWatcherEvents()
			end
		)
		RegisterStateDriver(SUI_Art_War, 'visibility', '[overridebar][vehicleui] hide; show')
		RegisterStateDriver(SpartanUI, 'visibility', '[petbattle][overridebar][vehicleui] hide; show')
	end
end

function module:RemoveVehicleUI()
	if SUI.DBMod.Artwork.VehicleUI then
		UnregisterStateDriver(SUI_Art_War, 'visibility')
	end
end

function module:CreateArtwork()
	plate = CreateFrame('Frame', 'War_ActionBarPlate', SpartanUI, 'War_ActionBarsTemplate')
	plate:SetFrameStrata('BACKGROUND')
	plate:SetFrameLevel(1)
	plate:SetPoint('BOTTOM')

	FramerateText:ClearAllPoints()
	FramerateText:SetPoint('TOPLEFT', SpartanUI, 'TOPLEFT', 10, -10)

	--Setup the Bottom Artwork
	artFrame:SetFrameStrata('BACKGROUND')
	artFrame:SetFrameLevel(1)
	artFrame:SetPoint('BOTTOMLEFT')
	artFrame:SetPoint('TOPRIGHT', SpartanUI, 'BOTTOMRIGHT', 0, 153)

	artFrame.Left = artFrame:CreateTexture('SUI_Art_War_Left', 'BORDER')
	artFrame.Left:SetTexture('Interface\\AddOns\\SpartanUI\\Themes\\War\\Images\\Base_Bar_Left')
	artFrame.Left:SetPoint('BOTTOMRIGHT', artFrame, 'BOTTOM', 0, 0)
	artFrame.Left:SetScale(.75)

	artFrame.Right = artFrame:CreateTexture('SUI_Art_War_Right', 'BORDER')
	artFrame.Right:SetTexture('Interface\\AddOns\\SpartanUI\\Themes\\War\\Images\\Base_Bar_Right')
	artFrame.Right:SetPoint('BOTTOMLEFT', artFrame, 'BOTTOM')
	artFrame.Right:SetScale(.75)
end

function module:StatusBars()
	local StatusBars = SUI:GetModule('Artwork_StatusBars')
	StatusBars:Initalize(module.StatusBarSettings)

	StatusBars.bars.StatusBar_Left:SetAlpha(.9)
	StatusBars.bars.StatusBar_Right:SetAlpha(.9)

	-- Position the StatusBars
	StatusBars.bars.StatusBar_Left:SetPoint('BOTTOMRIGHT', War_ActionBarPlate, 'BOTTOM', -100, 0)
	StatusBars.bars.StatusBar_Right:SetPoint('BOTTOMLEFT', War_ActionBarPlate, 'BOTTOM', 100, 0)
end

-- Artwork Stuff
function module:SlidingTrays()
	local Settings = {
		bg = {
			Texture = 'Interface\\AddOns\\SpartanUI\\Themes\\War\\Images\\Trays-' .. UnitFactionGroup('Player'),
			TexCoord = {.076171875, 0.92578125, 0, 0.18359375}
		},
		bgCollapsed = {
			Texture = 'Interface\\AddOns\\SpartanUI\\Themes\\War\\Images\\Trays-' .. UnitFactionGroup('Player'),
			TexCoord = {0.076171875, 0.92578125, 1, 0.92578125}
		},
		UpTex = {
			Texture = 'Interface\\AddOns\\SpartanUI\\Themes\\War\\Images\\Trays-' .. UnitFactionGroup('Player'),
			TexCoord = {0.3671875, 0.640625, 0.20703125, 0.25390625}
		},
		DownTex = {
			Texture = 'Interface\\AddOns\\SpartanUI\\Themes\\War\\Images\\Trays-' .. UnitFactionGroup('Player'),
			TexCoord = {0.3671875, 0.640625, 0.25390625, 0.20703125}
		}
	}

	module.Trays = Artwork_Core:SlidingTrays(Settings)
end

-- Minimap
function module:MiniMap()
	if Minimap.ZoneText ~= nil then
		Minimap.ZoneText:ClearAllPoints()
		Minimap.ZoneText:SetPoint('TOPLEFT', Minimap, 'BOTTOMLEFT', 0, -5)
		Minimap.ZoneText:SetPoint('TOPRIGHT', Minimap, 'BOTTOMRIGHT', 0, -5)
		Minimap.ZoneText:Hide()
		MinimapZoneText:Show()
	end
end
