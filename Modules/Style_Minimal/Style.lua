local SUI = SUI
local L = SUI.L
local Artwork_Core = SUI:GetModule('Artwork_Core')
local module = SUI:GetModule('Style_Minimal')
----------------------------------------------------------------------------------------------------
local InitRan = false
function module:OnInitialize()
	SUI.opt.args['General'].args['style'].args['OverallStyle'].args['Minimal'].disabled = false
	SUI.opt.args['General'].args['style'].args['Artwork'].args['Minimal'].disabled = false
	SUI.opt.args['General'].args['style'].args['PlayerFrames'].args['Minimal'].disabled = false
	SUI.opt.args['General'].args['style'].args['PartyFrames'].args['Minimal'].disabled = false
	SUI.opt.args['General'].args['style'].args['RaidFrames'].args['Minimal'].disabled = false
	--Init if needed
	if (SUI.DBMod.Artwork.Style == 'Minimal') then
		module:Init()
	end
end

function module:Init()
	if (SUI.DBMod.Artwork.FirstLoad) then
		module:FirstLoad()
	end
	module:SetupMenus()
	module:InitFramework()
	InitRan = true
end

function module:FirstLoad()
	--If our profile exists activate it.
	if
		((Bartender4.db:GetCurrentProfile() ~= SUI.DB.Styles.Minimal.BartenderProfile) and
			Artwork_Core:BartenderProfileCheck(SUI.DB.Styles.Minimal.BartenderProfile, true))
	 then
		Bartender4.db:SetProfile(SUI.DB.Styles.Minimal.BartenderProfile)
	end
end

function module:OnEnable()
	if (SUI.DBMod.Artwork.Style ~= 'Minimal') then
		module:Disable()
	else
		if (Bartender4.db:GetCurrentProfile() ~= SUI.DB.Styles.Minimal.BartenderProfile) and SUI.DBMod.Artwork.FirstLoad then
			Bartender4.db:SetProfile(SUI.DB.Styles.Minimal.BartenderProfile)
		end
		if (not InitRan) then
			module:Init()
		end
		if (not Artwork_Core:BartenderProfileCheck(SUI.DB.Styles.Minimal.BartenderProfile, true)) then
			module:CreateProfile()
		end

		module:SlidingTrays()
		module:EnableFramework()

		if (SUI.DBMod.Artwork.FirstLoad) then
			SUI.DBMod.Artwork.FirstLoad = false
		end -- We want to do this last
	end
end

function module:SetupMenus()
	SUI.opt.args['Artwork'].args['Art'] = {
		name = L['ArtworkOpt'],
		type = 'group',
		order = 10,
		args = {
			HideCenterGraphic = {
				name = L['Hide center graphic'],
				type = 'toggle',
				order = 1,
				get = function(info)
					return SUI.DB.Styles.Minimal.HideCenterGraphic
				end,
				set = function(info, val)
					SUI.DB.Styles.Minimal.HideCenterGraphic = val
					if SUI.DB.Styles.Minimal.HideCenterGraphic then
						Minimal_SpartanUI_Base1:Hide()
					else
						Minimal_SpartanUI_Base1:Show()
					end
				end
			},
			alpha = {
				name = L['ArtColor'],
				type = 'color',
				hasAlpha = true,
				order = 2,
				width = 'full',
				desc = L['TransparencyDesc'],
				get = function(info)
					return unpack(SUI.DB.Styles.Minimal.Color)
				end,
				set = function(info, r, b, g, a)
					SUI.DB.Styles.Minimal.Color = {r, b, g, a}
					module:SetColor()
				end
			}
		}
	}
end

function module:OnDisable()
	Minimal_SpartanUI:Hide()
	Minimal_AnchorFrame:Hide()
end

function module:Options_PartyFrames()
	SUI.opt.args['PartyFrames'].args['MinimalFrameStyle'] = {
		name = L['FrameStyle'],
		type = 'select',
		order = 5,
		values = {['large'] = L['Large'], ['small'] = L['Small']},
		get = function(info)
			return SUI.DB.Styles.Minimal.PartyFramesSize
		end,
		set = function(info, val)
			SUI.DB.Styles.Minimal.PartyFramesSize = val
		end
	}
end
