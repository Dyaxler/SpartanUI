local _G, SUI = _G, SUI
local L = SUI.L
local module = SUI:GetModule('Component_Artwork')
local MoveIt = SUI:GetModule('Component_MoveIt')

local function TalkingHead()
	local SetupTalkingHead = function()
		--Prevent WoW from moving the frame around
		TalkingHeadFrame.ignoreFramePositionManager = true
		_G.UIPARENT_MANAGED_FRAME_POSITIONS.TalkingHeadFrame = nil

		THUIHolder:SetSize(TalkingHeadFrame:GetSize())
		MoveIt:CreateMover(THUIHolder, 'THUIHolder', 'Talking Head Frame')
		TalkingHeadFrame:HookScript(
			'OnShow',
			function()
				TalkingHeadFrame:ClearAllPoints()
				TalkingHeadFrame:SetPoint('CENTER', THUIHolder, 'CENTER', 0, 0)
			end
		)
	end

	local point, anchor, secondaryPoint, x, y =
		strsplit(',', SUI.DB.Styles[SUI.DBMod.Artwork.Style].BlizzMovers.TalkingHead)
	local THUIHolder = CreateFrame('Frame', 'THUIHolder', SpartanUI)
	THUIHolder:SetPoint(point, anchor, secondaryPoint, x, y)
	THUIHolder:Hide()

	if IsAddOnLoaded('Blizzard_TalkingHeadUI') then
		SetupTalkingHead()
	else
		--We want the mover to be available immediately, so we load it ourselves
		local f = CreateFrame('Frame')
		f:RegisterEvent('PLAYER_ENTERING_WORLD')
		f:SetScript(
			'OnEvent',
			function(frame, event)
				frame:UnregisterEvent(event)
				_G.TalkingHead_LoadUI()
				SetupTalkingHead()
			end
		)
	end
end

local function AltPowerBar()
	if not IsAddOnLoaded('SimplePowerBar') then
		local point, anchor, secondaryPoint, x, y =
			strsplit(',', SUI.DB.Styles[SUI.DBMod.Artwork.Style].BlizzMovers.AltPowerBar)
		local holder = CreateFrame('Frame', 'AltPowerBarHolder', UIParent)
		holder:SetPoint(point, anchor, secondaryPoint, x, y)
		holder:SetSize(256, 64)
		holder:Hide()

		_G.PlayerPowerBarAlt:ClearAllPoints()
		_G.PlayerPowerBarAlt:SetPoint('CENTER', holder, 'CENTER')
		_G.PlayerPowerBarAlt.ignoreFramePositionManager = true

		hooksecurefunc(
			_G.PlayerPowerBarAlt,
			'ClearAllPoints',
			function(bar)
				bar:SetPoint('CENTER', AltPowerBarHolder, 'CENTER')
			end
		)

		MoveIt:CreateMover(holder, 'AltPowerBarMover', 'Alternative Power')
	end
end

local function AlertFrame()
	local point, anchor, secondaryPoint, x, y =
		strsplit(',', SUI.DB.Styles[SUI.DBMod.Artwork.Style].BlizzMovers.AlertFrame)
	local AlertHolder = CreateFrame('Frame', 'AlertHolder', SpartanUI)
	AlertHolder:SetSize(250, 40)
	AlertHolder:SetPoint(point, anchor, secondaryPoint, x, y)
	AlertHolder:Hide()
	MoveIt:CreateMover(AlertHolder, 'AlertHolder', 'Alert frame anchor')

	local AlertFrame = _G.AlertFrame
	local GroupLootContainer = _G.GroupLootContainer

	AlertFrame:ClearAllPoints()
	AlertFrame:SetPoint('BOTTOM', AlertHolder)
	GroupLootContainer:ClearAllPoints()
	GroupLootContainer:SetPoint('BOTTOM', AlertHolder)
end

local function VehicleLeaveButton()
	local function MoverCreate()
		-- if InCombatLockdown() then
		-- 	return
		-- end

		local point, anchor, secondaryPoint, x, y =
			strsplit(',', SUI.DB.Styles[SUI.DBMod.Artwork.Style].BlizzMovers.VehicleLeaveButton)
		MainMenuBarVehicleLeaveButton:ClearAllPoints()
		MainMenuBarVehicleLeaveButton:SetPoint(point, anchor, secondaryPoint, x, y)
		MoveIt:CreateMover(MainMenuBarVehicleLeaveButton, 'VehicleLeaveButton', 'Vehicle leave button')

		MainMenuBarVehicleLeaveButton:HookScript(
			'OnShow',
			function()
				if not InCombatLockdown() then
					MainMenuBarVehicleLeaveButton:position()
				end
			end
		)
	end

	-- Delay this so unit frames have been generated
	module:ScheduleTimer(MoverCreate, 2)
end

function module.BlizzMovers()
	AlertFrame()
	TalkingHead()
	AltPowerBar()
	VehicleLeaveButton()
end