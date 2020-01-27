local SUI = SUI
local module = SUI:GetModule('Style_Classic')
---------------------------------------------------------------------------
local PetBattleActive = false
local petbattleWatcher = CreateFrame('Frame')

function module:MiniMap()
	if Minimap.ZoneText ~= nil then
		Minimap.ZoneText:ClearAllPoints()
		Minimap.ZoneText:SetPoint('TOPLEFT', Minimap, 'BOTTOMLEFT', 0, -5)
		Minimap.ZoneText:SetPoint('TOPRIGHT', Minimap, 'BOTTOMRIGHT', 0, -5)
		Minimap.ZoneText:Hide()
		MinimapZoneText:Show()
	end

	--Shape Change
	local shapechange = function(shape)
		if shape == 'square' then
			Minimap:SetMaskTexture('Interface\\BUTTONS\\WHITE8X8')

			Minimap.overlay = Minimap:CreateTexture(nil, 'OVERLAY')
			Minimap.overlay:SetTexture('Interface\\AddOns\\SpartanUI\\images\\minimap\\square-overlay')
			Minimap.overlay:SetAllPoints(Minimap)
			Minimap.overlay:SetBlendMode('ADD')

			if MiniMapTracking then
				MiniMapTracking:ClearAllPoints()
				MiniMapTracking:SetPoint('TOPLEFT', Minimap, 'TOPLEFT', 0, 0)
			end
		else
			Minimap:SetMaskTexture('Interface\\AddOns\\SpartanUI\\images\\minimap\\circle-overlay')
			if MiniMapTracking then
				MiniMapTracking:ClearAllPoints()
				MiniMapTracking:SetPoint('TOPLEFT', Minimap, 'TOPLEFT', -5, -5)
			end
			if Minimap.overlay then
				Minimap.overlay:Hide()
			end
		end
	end

	SpartanUI:HookScript(
		'OnHide',
		function(this, event)
			if PetBattleActive then
				return
			end
			Minimap:ClearAllPoints()
			Minimap:SetParent(UIParent)
			Minimap:SetPoint('TOPRIGHT', UIParent, 'TOPRIGHT', -20, -20)
			shapechange('square')
		end
	)

	SpartanUI:HookScript(
		'OnShow',
		function(this, event)
			Minimap:ClearAllPoints()
			Minimap:SetPoint('CENTER', SUI_Art_Classic, 'CENTER', 0, 54)
			Minimap:SetParent(SUI_Art_Classic)
			shapechange('circle')
		end
	)

	if SUI.IsRetail then
		petbattleWatcher:SetScript(
			'OnEvent',
			function(self, event)
				if event == 'PET_BATTLE_CLOSE' then
					PetBattleActive = false
				else
					PetBattleActive = true
				end
			end
		)
		petbattleWatcher:RegisterEvent('PET_BATTLE_OPENING_START')
		--petbattleWatcher:RegisterEvent("PET_BATTLE_TURN_STARTED")
		petbattleWatcher:RegisterEvent('PET_BATTLE_OPENING_DONE')
		petbattleWatcher:RegisterEvent('PET_BATTLE_CLOSE')
	end

	Minimap:SetFrameLevel(120)
end

function module:EnableMinimap()
	if SUI.DB.EnabledComponents.Minimap and ((SUI.DB.MiniMap.AutoDetectAllowUse) or (SUI.DB.MiniMap.ManualAllowUse)) then
		module:MiniMap()
	end
end
