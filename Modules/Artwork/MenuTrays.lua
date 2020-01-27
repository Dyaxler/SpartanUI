local _G, SUI = _G, SUI
local L = SUI.L
local module = SUI:GetModule('Component_Artwork')
module.Trays = false
local trayWatcher = CreateFrame('Frame')
local settings = {}
local trayIDs = {
	'left',
	'right'
}

local SetBarVisibility = function(side, state)
	local bt4Positions = {
		['BT4BarStanceBar'] = 'left',
		['BT4BarPetBar'] = 'left',
		['BT4BarBagBar'] = 'right',
		['BT4BarMicroMenu'] = 'right'
	}
	for k, v in pairs(bt4Positions) do
		if v == side and not _G[k].isMoved() then
			if state == 'hide' then
				_G[k]:Hide()
			elseif state == 'show' then
				_G[k]:Show()
			end
		end
	end
end

local trayWatcherEvents = function()
	if InCombatLockdown() then
		return
	end

	-- Make sure we are in the right spot
	module:updateOffset()

	for _, key in ipairs(trayIDs) do
		if SUI.DBMod.Artwork.SlidingTrays[key].collapsed then
			module.Trays[key].expanded:Hide()
			module.Trays[key].collapsed:Show()
			SetBarVisibility(key, 'hide')
		else
			module.Trays[key].expanded:Show()
			module.Trays[key].collapsed:Hide()
			SetBarVisibility(key, 'show')
		end
	end
end

function module:trayWatcherEvents()
	trayWatcherEvents()
end

local CollapseToggle = function(self)
	if InCombatLockdown() then
		SUI:Print(ERR_NOT_IN_COMBAT)
		return
	end

	local key = self.key
	if SUI.DBMod.Artwork.SlidingTrays[key].collapsed then
		SUI.DBMod.Artwork.SlidingTrays[key].collapsed = false
		module.Trays[key].expanded:Show()
		module.Trays[key].collapsed:Hide()
		SetBarVisibility(key, 'show')
	else
		SUI.DBMod.Artwork.SlidingTrays[key].collapsed = true
		module.Trays[key].expanded:Hide()
		module.Trays[key].collapsed:Show()
		SetBarVisibility(key, 'hide')
	end
end

-- Artwork Stuff
function module:SlidingTrays(StyleSettings)
	module.Trays = {}
	settings = StyleSettings

	for _, key in ipairs(trayIDs) do
		local tray = CreateFrame('Frame', 'SlidingTray_' .. key, _G['SUI_Art_' .. SUI.DBMod.Artwork.Style])
		tray:SetFrameStrata('BACKGROUND')
		tray:SetAlpha(.8)
		tray:SetSize(400, 45)

		local expanded = CreateFrame('Frame', nil, tray)
		expanded:SetAllPoints()
		local collapsed = CreateFrame('Frame', nil, tray)
		collapsed:SetAllPoints()

		local bg = expanded:CreateTexture(nil, 'BACKGROUND', expanded)
		bg:SetTexture(settings.bg.Texture)
		bg:SetTexCoord(unpack(settings.bg.TexCoord))
		bg:SetAllPoints()

		local bgCollapsed = collapsed:CreateTexture(nil, 'BACKGROUND', collapsed)
		bgCollapsed:SetTexture(settings.bgCollapsed.Texture)
		bgCollapsed:SetTexCoord(unpack(settings.bgCollapsed.TexCoord))
		bgCollapsed:SetPoint('TOPLEFT', tray)
		bgCollapsed:SetPoint('TOPRIGHT', tray)
		bgCollapsed:SetHeight(18)

		local btnUp = CreateFrame('BUTTON', nil, expanded)
		local UpTex = expanded:CreateTexture()
		UpTex:SetTexture(settings.UpTex.Texture)
		UpTex:SetTexCoord(unpack(settings.UpTex.TexCoord))
		UpTex:Hide()
		btnUp:SetSize(130, 9)
		UpTex:SetAllPoints(btnUp)
		btnUp:SetNormalTexture('')
		btnUp:SetHighlightTexture(UpTex)
		btnUp:SetPushedTexture('')
		btnUp:SetDisabledTexture('')
		btnUp:SetPoint('BOTTOM', tray, 'BOTTOM', 1, 2)

		local btnDown = CreateFrame('BUTTON', nil, collapsed)
		local DownTex = collapsed:CreateTexture()
		DownTex:SetTexture(settings.DownTex.Texture)
		DownTex:SetTexCoord(unpack(settings.DownTex.TexCoord))
		DownTex:Hide()
		btnDown:SetSize(130, 9)
		DownTex:SetAllPoints(btnDown)
		btnDown:SetNormalTexture('')
		btnDown:SetHighlightTexture(DownTex)
		btnDown:SetPushedTexture('')
		btnDown:SetDisabledTexture('')
		btnDown:SetPoint('TOP', tray, 'TOP', 2, -6)

		btnUp.key = key
		btnDown.key = key
		btnUp:SetScript('OnClick', CollapseToggle)
		btnDown:SetScript('OnClick', CollapseToggle)

		expanded.bg = bg
		expanded.btnUp = btnUp

		collapsed.bgCollapsed = bgCollapsed
		collapsed.btnDown = btnDown

		tray.expanded = expanded
		tray.collapsed = collapsed

		if SUI.DBMod.Artwork.SlidingTrays[key].collapsed then
			SetBarVisibility(key, 'hide')
		else
			SetBarVisibility(key, 'show')
		end
		module.Trays[key] = tray
	end

	module.Trays.left:SetPoint('TOP', SpartanUI, 'TOP', -300, -1)
	module.Trays.right:SetPoint('TOP', SpartanUI, 'TOP', 300, -1)

	trayWatcher:SetScript('OnEvent', trayWatcherEvents)
	trayWatcher:RegisterEvent('PLAYER_LOGIN')
	trayWatcher:RegisterEvent('PLAYER_ENTERING_WORLD')
	trayWatcher:RegisterEvent('ZONE_CHANGED')
	trayWatcher:RegisterEvent('ZONE_CHANGED_INDOORS')
	trayWatcher:RegisterEvent('ZONE_CHANGED_NEW_AREA')
	if SUI.IsRetail then
		trayWatcher:RegisterEvent('UNIT_EXITED_VEHICLE')
		trayWatcher:RegisterEvent('PET_BATTLE_CLOSE')
	end

	return module.Trays
end
