local SUI = SUI
local PlayerFrames = SUI:NewModule('PlayerFrames')
SUI.PlayerFrames = PlayerFrames
----------------------------------------------------------------------------------------------------

function PlayerFrames:SetupStaticOptions()
	local FramesList = {
		[1] = 'pet',
		[2] = 'target',
		[3] = 'targettarget',
		[4] = 'focus',
		[5] = 'focustarget',
		[6] = 'player'
	}
	for _, unit in pairs(FramesList) do
		--Health Bar Color
		if SUI.DBMod.PlayerFrames.bars[unit].color == 'reaction' then
			PlayerFrames[unit].Health.colorReaction = true
		elseif SUI.DBMod.PlayerFrames.bars[unit].color == 'happiness' then
			PlayerFrames[unit].Health.colorHappiness = true
		elseif SUI.DBMod.PlayerFrames.bars[unit].color == 'class' then
			PlayerFrames[unit].Health.colorClass = true
		else
			PlayerFrames[unit].Health.colorSmooth = true
		end
	end
end

function PlayerFrames:TextFormat(text)
	local textstyle = SUI.DBMod.PlayerFrames.bars[text].textstyle
	local textmode = SUI.DBMod.PlayerFrames.bars[text].textmode
	local a, m, t, z
	if text == 'mana' then
		z = 'pp'
	else
		z = 'hp'
	end

	-- textstyle
	-- "Long: 			 Displays all numbers."
	-- "Long Formatted: Displays all numbers with commas."
	-- "Dynamic: 		 Abbriviates and formats as needed"
	if textstyle == 'long' then
		a = '[cur' .. z .. ']'
		m = '[missing' .. z .. ']'
		t = '[max' .. z .. ']'
	elseif textstyle == 'longfor' then
		a = '[cur' .. z .. 'formatted]'
		m = '[missing' .. z .. 'formatted]'
		t = '[max' .. z .. 'formatted]'
	elseif textstyle == 'dynamic' then
		a = '[cur' .. z .. 'dynamic]'
		m = '[missing' .. z .. 'dynamic]'
		t = '[max' .. z .. 'dynamic]'
	end
	-- textmode
	-- [1]="Avaliable / Total",
	-- [2]="(Missing) Avaliable / Total",
	-- [3]="(Missing) Avaliable"

	if textmode == 1 then
		return a .. ' / ' .. t
	elseif textmode == 2 then
		return '(' .. m .. ') ' .. a .. ' / ' .. t
	elseif textmode == 3 then
		return '(' .. m .. ') ' .. a
	elseif textmode == 4 then
		return a .. ' / ' .. t .. ' ([per' .. z .. ']%)'
	end
end

function PlayerFrames:Buffs(self, unit)
	--Make sure there is an anchor for buffs
	if not self.BuffAnchor then
		return self
	end
	local CurStyle = SUI.DBMod.PlayerFrames.Style
	-- Build buffs
	if SUI.DB.Styles[CurStyle].Frames[unit] then
		local Buffsize = SUI.DB.Styles[CurStyle].Frames[unit].Buffs.size
		local Debuffsize = SUI.DB.Styles[CurStyle].Frames[unit].Debuffs.size
		local BuffsMode = SUI.DB.Styles[CurStyle].Frames[unit].Buffs.Mode
		local DebuffsMode = SUI.DB.Styles[CurStyle].Frames[unit].Debuffs.Mode

		--Determine how many we can fit for Hybrid Display
		local split = 4
		local Spacer = 3
		local BuffWidth = 0
		local BuffWidth2 = 0
		local DeBuffWidth = 0
		local DeBuffWidth2 = 0
		for index = 1, 10 do
			if
				((index * (Buffsize + SUI.DB.Styles[CurStyle].Frames[unit].Buffs.spacing)) <= (self.BuffAnchor:GetWidth() / split))
			 then
				BuffWidth = index
			end
			if ((index * (Buffsize + SUI.DB.Styles[CurStyle].Frames[unit].Buffs.spacing)) <= (self.BuffAnchor:GetWidth() / 2)) then
				BuffWidth2 = index
			end
		end
		for index = 1, 10 do
			if
				((index * (Debuffsize + SUI.DB.Styles[CurStyle].Frames[unit].Debuffs.spacing)) <=
					(self.BuffAnchor:GetWidth() / split))
			 then
				DeBuffWidth = index
			end
			if
				((index * (Debuffsize + SUI.DB.Styles[CurStyle].Frames[unit].Debuffs.spacing)) <= (self.BuffAnchor:GetWidth() / 2))
			 then
				DeBuffWidth2 = index
			end
		end
		local BuffWidthActual = (Buffsize + SUI.DB.Styles[CurStyle].Frames[unit].Buffs.spacing) * BuffWidth
		local DeBuffWidthActual = (Debuffsize + SUI.DB.Styles[CurStyle].Frames[unit].Debuffs.spacing) * DeBuffWidth

		-- Position Bar
		local BarPosition = function(self, pos)
			-- Reminder on how position is defined
			-- * = Icons
			-- - = Bars
			--Pos1 -------**
			--Pos2 **-----**
			--Pos3 **-------
			if pos == 1 then
				self.AuraBars:SetPoint('BOTTOMLEFT', self.BuffAnchor, 'TOPLEFT', 0, 0)
				self.AuraBars:SetPoint('BOTTOMRIGHT', self.BuffAnchor, 'TOPRIGHT', ((DeBuffWidthActual + Spacer) * -1), 0)
			elseif pos == 2 then
				self.AuraBars:SetPoint('BOTTOMLEFT', self.BuffAnchor, 'TOPLEFT', (BuffWidthActual + Spacer), 0)
				self.AuraBars:SetPoint('BOTTOMRIGHT', self.BuffAnchor, 'TOPRIGHT', ((DeBuffWidthActual + Spacer) * -1), 0)
			else --pos 3
				self.AuraBars:SetPoint('BOTTOMLEFT', self.BuffAnchor, 'TOPLEFT', (BuffWidthActual + Spacer), 0)
				self.AuraBars:SetPoint('BOTTOMRIGHT', self.BuffAnchor, 'TOPRIGHT', 0, 0)
			end
			return self
		end

		--Buff Icons
		local Buffs = CreateFrame('Frame', nil, self)
		--Debuff Icons
		local Debuffs = CreateFrame('Frame', nil, self)
		-- Setup icons if needed
		local iconFilter = function(icons, unit, icon, name, rank, texture, count, dtype, duration, timeLeft, caster)
			if caster == 'player' and (duration == 0 or duration > 60) then --Do not show DOTS & HOTS
				return true
			elseif caster ~= 'player' then
				return true
			end
		end
		if BuffsMode ~= 'bars' and BuffsMode ~= 'disabled' then
			Buffs:SetPoint('BOTTOMLEFT', self.BuffAnchor, 'TOPLEFT', 0, 0)
			Buffs.size = Buffsize
			Buffs['growth-x'] = 'RIGHT'
			Buffs['growth-y'] = 'UP'
			Buffs.spacing = SUI.DB.Styles[CurStyle].Frames[unit].Buffs.spacing
			Buffs.showType = SUI.DB.Styles[CurStyle].Frames[unit].Buffs.showType
			Buffs.numBuffs = SUI.DB.Styles[CurStyle].Frames[unit].Buffs.Number
			Buffs.onlyShowPlayer = SUI.DB.Styles[CurStyle].Frames[unit].Buffs.onlyShowPlayer
			Buffs:SetSize(BuffWidthActual, (Buffsize * (Buffs.numBuffs / BuffWidth)))
			Buffs.PostUpdate = PostUpdateAura
			if BuffsMode ~= 'icons' then
				Buffs.CustomFilter = iconFilter
			end
			self.Buffs = Buffs
		end
		if DebuffsMode ~= 'bars' and DebuffsMode ~= 'disabled' then
			Debuffs:SetPoint('BOTTOMRIGHT', self.BuffAnchor, 'TOPRIGHT', 0, 0)
			Debuffs.size = Debuffsize
			Debuffs.initialAnchor = 'BOTTOMRIGHT'
			Debuffs['growth-x'] = 'LEFT'
			Debuffs['growth-y'] = 'UP'
			Debuffs.spacing = SUI.DB.Styles[CurStyle].Frames[unit].Debuffs.spacing
			Debuffs.showType = SUI.DB.Styles[CurStyle].Frames[unit].Debuffs.showType
			Debuffs.numDebuffs = SUI.DB.Styles[CurStyle].Frames[unit].Debuffs.Number
			Debuffs.onlyShowPlayer = SUI.DB.Styles[CurStyle].Frames[unit].Debuffs.onlyShowPlayer
			Debuffs:SetSize(DeBuffWidthActual, (Debuffsize * (Debuffs.numDebuffs / DeBuffWidth)))
			Debuffs.PostUpdate = PostUpdateAura
			if DebuffsMode ~= 'icons' then
				Debuffs.CustomFilter = iconFilter
			end
			self.Debuffs = Debuffs
		end

		--Bars
		local AuraBars = CreateFrame('Frame', nil, self)
		AuraBars:SetHeight(1)
		AuraBars.auraBarTexture = Smoothv2
		AuraBars.PostUpdate = PostUpdateAura
		AuraBars.spellTimeFont = SUI:GetFontFace('Player')
		AuraBars.spellNameFont = SUI:GetFontFace('Player')

		--Hots and Dots Filter
		local Barfilter = function(name, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, spellID)
			--Only Show things with a SHORT durration (HOTS and DOTS)
			if duration > 0 and duration < 60 then
				return true
			end
		end

		-- Determine Buff Bar locaion
		if BuffsMode == 'bars' and DebuffsMode == 'icons' then
			AuraBars.Buffs = true
			self.AuraBars = AuraBars
			BarPosition(self, 1)
		elseif BuffsMode == 'bars' and DebuffsMode == 'both' then
			AuraBars.ShowAll = true
			self.AuraBars = AuraBars
			BarPosition(self, 1)
		elseif BuffsMode == 'bars' and (DebuffsMode == 'bars' or DebuffsMode == 'disabled') then
			if DebuffsMode == 'disabled' then
				AuraBars.Buffs = true
			else
				AuraBars.ShowAll = true
			end
			AuraBars:SetPoint('BOTTOMLEFT', self.BuffAnchor, 'TOPLEFT', 0, 0)
			AuraBars:SetPoint('BOTTOMRIGHT', self.BuffAnchor, 'TOPRIGHT', 0, 0)
			self.AuraBars = AuraBars
		elseif BuffsMode == 'icons' and DebuffsMode == 'icons' then
			Buffs:SetSize(self.BuffAnchor:GetWidth() / 2, (Buffsize * (Buffs.numBuffs / BuffWidth2)))
			Debuffs:SetSize(self.BuffAnchor:GetWidth() / 2, (Debuffsize * (Debuffs.numDebuffs / DeBuffWidth2)))
		elseif BuffsMode == 'icons' and DebuffsMode == 'both' then
			AuraBars.Debuffs = true
			self.AuraBars = AuraBars
			BarPosition(self, 2)
		elseif BuffsMode == 'icons' and DebuffsMode == 'bars' then
			AuraBars.Debuffs = true
			self.AuraBars = AuraBars
			BarPosition(self, 3)
		elseif BuffsMode == 'icons' and DebuffsMode == 'disabled' then
			Buffs:SetSize(self.BuffAnchor:GetWidth(), (Buffsize * (Buffs.numBuffs / self.BuffAnchor:GetWidth())))
		elseif BuffsMode == 'both' and DebuffsMode == 'icons' then
			AuraBars.Buffs = true
			self.AuraBars = AuraBars
			BarPosition(self, 2)
		elseif BuffsMode == 'both' and DebuffsMode == 'both' then
			AuraBars.ShowAll = true
			self.AuraBars = AuraBars
			BarPosition(self, 2)
		elseif BuffsMode == 'both' and DebuffsMode == 'bars' then
			AuraBars.ShowAll = true
			self.AuraBars = AuraBars
			BarPosition(self, 3)
		elseif BuffsMode == 'bars' and DebuffsMode == 'disabled' then
			AuraBars.Buffs = true
			AuraBars:SetPoint('BOTTOMLEFT', self.BuffAnchor, 'TOPLEFT', 0, 0)
			AuraBars:SetPoint('BOTTOMRIGHT', self.BuffAnchor, 'TOPRIGHT', 0, 0)
			self.AuraBars = AuraBars
		elseif BuffsMode == 'disabled' and DebuffsMode == 'bars' then
			AuraBars.Debuffs = true
			AuraBars:SetPoint('BOTTOMLEFT', self.BuffAnchor, 'TOPLEFT', 0, 0)
			AuraBars:SetPoint('BOTTOMRIGHT', self.BuffAnchor, 'TOPRIGHT', 0, 0)
			self.AuraBars = AuraBars
		elseif BuffsMode == 'disabled' and DebuffsMode == 'icons' then
			Debuffs:SetSize(self.BuffAnchor:GetWidth(), (Debuffsize * (Debuffs.numDebuffs / self.BuffAnchor:GetWidth())))
		elseif BuffsMode == 'disabled' and DebuffsMode == 'both' then
			AuraBars.Debuffs = true
			self.AuraBars = AuraBars
			BarPosition(self, 1)
		end

		--Buff Filter for bars
		if self.AuraBars then
			AuraBars.filter = Barfilter
		end

		--Change options if needed
		if SUI.DB.Styles[CurStyle].Frames[unit].Buffs.Mode == 'bars' then
			SUI.opt.args['PlayerFrames'].args['auras'].args[unit].args['Buffs'].args['Number'].disabled = true
			SUI.opt.args['PlayerFrames'].args['auras'].args[unit].args['Buffs'].args['size'].disabled = true
			SUI.opt.args['PlayerFrames'].args['auras'].args[unit].args['Buffs'].args['spacing'].disabled = true
			SUI.opt.args['PlayerFrames'].args['auras'].args[unit].args['Buffs'].args['showType'].disabled = true
		end
		if SUI.DB.Styles[CurStyle].Frames[unit].Debuffs.Mode == 'bars' then
			SUI.opt.args['PlayerFrames'].args['auras'].args[unit].args['Debuffs'].args['Number'].disabled = true
			SUI.opt.args['PlayerFrames'].args['auras'].args[unit].args['Debuffs'].args['size'].disabled = true
			SUI.opt.args['PlayerFrames'].args['auras'].args[unit].args['Debuffs'].args['spacing'].disabled = true
			SUI.opt.args['PlayerFrames'].args['auras'].args[unit].args['Debuffs'].args['showType'].disabled = true
		end

		SUI.opt.args['PlayerFrames'].args['auras'].args[unit].disabled = false
	end
	return self
end

function PlayerFrames:UpdatePosition()
	local FramesList = {
		[1] = 'pet',
		[2] = 'target',
		[3] = 'targettarget',
		[4] = 'focus',
		[5] = 'focustarget',
		[6] = 'player'
	}

	for _, b in pairs(FramesList) do
		if SUI.DBMod.PlayerFrames[b] ~= nil and SUI.DBMod.PlayerFrames[b].moved then
			PlayerFrames[b]:SetMovable(true)
			PlayerFrames[b]:SetUserPlaced(false)
			local Anchors = {}
			for k, v in pairs(SUI.DBMod.PlayerFrames[b].Anchors) do
				Anchors[k] = v
			end
			PlayerFrames[b]:ClearAllPoints()
			PlayerFrames[b]:SetPoint(Anchors.point, nil, Anchors.relativePoint, Anchors.xOfs, Anchors.yOfs)
		elseif SUI.DBMod.PlayerFrames[b] ~= nil then
			PlayerFrames[b]:SetMovable(false)
			PlayerFrames[b]:ClearAllPoints()
			if (SUI.DBMod.PlayerFrames.Style == 'Classic') then
				PlayerFrames:PositionFrame_Classic(b)
			elseif (SUI.DBMod.PlayerFrames.Style == 'plain') then
				PlayerFrames:PositionFrame_Plain(b)
			else
				SUI:GetModule('Style_' .. SUI.DBMod.PlayerFrames.Style):PositionFrame(b)
			end
		else
			print(b .. ' Frame has not been spawned by your theme')
		end
	end

	-- for i = 1, MAX_BOSS_FRAMES do
	if SUI.DBMod.PlayerFrames.BossFrame.display then
		if SUI.DBMod.PlayerFrames.boss.moved then
			PlayerFrames.boss[1]:SetMovable(true)
			PlayerFrames.boss[1]:SetUserPlaced(false)
			local Anchors = {}
			for k, v in pairs(SUI.DBMod.PlayerFrames.boss.Anchors) do
				Anchors[k] = v
			end
			PlayerFrames.boss[1]:ClearAllPoints()
			PlayerFrames.boss[1]:SetPoint(Anchors.point, nil, Anchors.relativePoint, Anchors.xOfs, Anchors.yOfs)
		else
			PlayerFrames.boss[1]:SetPoint('TOPRIGHT', UIParent, 'RIGHT', -50, 60)
			PlayerFrames.boss[1]:SetMovable(false)
		end
	end
	-- end
end

function PlayerFrames:CreatePortrait(self)
	if SUI.DBMod.PlayerFrames.Portrait3D then
		local Portrait = CreateFrame('PlayerModel', nil, self)
		Portrait:SetScript(
			'OnShow',
			function(self)
				self:SetCamera(1)
			end
		)
		Portrait.type = '3D'
		-- Portrait.bg2 = Portrait:CreateTexture(nil,"BACKGROUND");
		-- Portrait.bg2:SetTexture(circle);
		-- Portrait.bg2:SetPoint("TOPLEFT",Portrait,"TOPLEFT",-10,10);
		-- Portrait.bg2:SetPoint("BOTTOMRIGHT",Portrait,"BOTTOMRIGHT",10,-10);
		Portrait:SetFrameLevel(1)
		return Portrait
	else
		return self:CreateTexture(nil, 'BORDER')
	end
end

function PlayerFrames:MakeMovable(self, unit)
	self:RegisterForClicks('AnyDown')
	self:EnableMouse(enable)
	self:SetClampedToScreen(true)

	if self.artwork then
		self.artwork:SetScript(
			'OnEnter',
			function()
				UnitFrame_OnEnter(self, unit)
			end
		)
		self.artwork:SetScript(
			'OnLeave',
			function()
				UnitFrame_OnLeave(self, unit)
			end
		)
	end

	self:SetScript('OnEnter', UnitFrame_OnEnter)
	self:SetScript('OnLeave', UnitFrame_OnLeave)
	return self
end

function PlayerFrames:FirstTime()
	SUI.DBMod.PlayerFrames.SetupDone = false
	local PageData = {
		SubTitle = 'Player Frames style',
		Desc1 = 'Please pick an art style from the options below.',
		Display = function()
			--Container
			SUI_Win.Artwork = CreateFrame('Frame', nil)
			SUI_Win.Artwork:SetParent(SUI_Win.content)
			SUI_Win.Artwork:SetAllPoints(SUI_Win.content)

			local RadioButtons = function(self)
				SUI_Win.Artwork.Classic.radio:SetValue(false)
				SUI_Win.Artwork.Transparent.radio:SetValue(false)
				SUI_Win.Artwork.Minimal.radio:SetValue(false)
				self.radio:SetValue(true)
			end

			local gui = LibStub('AceGUI-3.0')
			local control, radio

			--Classic
			control = gui:Create('Icon')
			control:SetImage('interface\\addons\\SpartanUI_Artwork\\Themes\\Classic\\Images\\base-center')
			control:SetImageSize(120, 60)
			control:SetPoint('TOP', SUI_Win.Artwork, 'TOP', 0, -30)
			control:SetCallback('OnClick', RadioButtons)
			control.frame:SetParent(SUI_Win.Artwork)
			control.frame:Show()

			radio = gui:Create('CheckBox')
			radio:SetLabel('Classic')
			radio:SetUserData('value', 'Classic')
			radio:SetUserData('text', 'Classic')
			radio:SetType('radio')
			radio:SetDisabled(true)
			radio:SetWidth(control.frame:GetWidth() / 1.4)
			radio:SetHeight(16)
			radio.frame:SetPoint('TOP', control.frame, 'BOTTOM', 0, 0)
			radio:SetCallback('OnClick', RadioButton)
			radio.frame:SetParent(control.frame)
			radio.frame:Show()
			control.radio = radio

			SUI_Win.Artwork.Classic = control

			--Transparent
			control = gui:Create('Icon')
			control:SetImage('interface\\addons\\SpartanUI\\media\\Style_Transparent')
			control:SetImageSize(120, 60)
			control:SetPoint('TOPRIGHT', SUI_Win.Artwork.Classic.frame, 'BOTTOMLEFT', 0, -60)
			control:SetCallback('OnClick', RadioButtons)
			control.frame:SetParent(SUI_Win.Artwork)
			control.frame:Show()

			radio = gui:Create('CheckBox')
			radio:SetLabel('Transparent')
			radio:SetUserData('value', 'Transparent')
			radio:SetUserData('text', 'Transparent')
			radio:SetType('radio')
			radio:SetDisabled(true)
			radio:SetWidth(control.frame:GetWidth() / 1.15)
			radio:SetHeight(16)
			radio.frame:SetPoint('TOP', control.frame, 'BOTTOM', 0, 0)
			radio.frame:SetParent(control.frame)
			radio.frame:Show()
			control.radio = radio

			SUI_Win.Artwork.Transparent = control

			--Minimal
			control = gui:Create('Icon')
			control:SetImage('interface\\addons\\SpartanUI\\media\\Style_Minimal')
			control:SetImageSize(120, 60)
			control:SetPoint('TOPLEFT', SUI_Win.Artwork.Classic.frame, 'BOTTOMRIGHT', 0, -60)
			control:SetCallback('OnClick', RadioButtons)
			control.frame:SetParent(SUI_Win.Artwork)
			control.frame:Show()

			radio = gui:Create('CheckBox')
			radio:SetLabel('Minimal')
			radio:SetUserData('value', 'Minimal')
			radio:SetUserData('text', 'Minimal')
			radio:SetType('radio')
			radio:SetDisabled(true)
			radio:SetWidth(control.frame:GetWidth() / 1.15)
			radio:SetHeight(16)
			radio.frame:SetPoint('TOP', control.frame, 'BOTTOM', 0, 0)
			radio.frame:SetParent(control.frame)
			radio.frame:Show()
			control.radio = radio

			SUI_Win.Artwork.Minimal = control
		end,
		Next = function()
			SUI.DBMod.Artwork.PlayerFrames = true

			if (SUI_Win.Artwork.Classic.radio:GetValue()) then
				SUI.DBMod.Artwork.Style = 'Classic'
			end
			if (SUI_Win.Artwork.Transparent.radio:GetValue()) then
				SUI.DBMod.Artwork.Style = 'Transparent'
			end
			if (SUI_Win.Artwork.Minimal.radio:GetValue()) then
				SUI.DBMod.Artwork.Style = 'Minimal'
			end

			SUI.DBMod.PlayerFrames.Style = SUI.DBMod.Artwork.Style
			SUI.DBMod.PartyFrames.Style = SUI.DBMod.Artwork.Style
			SUI.DBMod.RaidFrames.Style = SUI.DBMod.Artwork.Style
			SUI.DBMod.Artwork.FirstLoad = true

			--Reset Moved bars
			if SUI.DB.Styles[SUI.DBMod.Artwork.Style].MovedBars == nil then
				SUI.DB.Styles[SUI.DBMod.Artwork.Style].MovedBars = {}
			end
			local FrameList = {
				BT4Bar1,
				BT4Bar2,
				BT4Bar3,
				BT4Bar4,
				BT4Bar5,
				BT4Bar6,
				BT4BarBagBar,
				BT4BarExtraActionBar,
				BT4BarStanceBar,
				BT4BarPetBar,
				BT4BarMicroMenu
			}
			for _, v in ipairs(FrameList) do
				if SUI.DB.Styles[SUI.DBMod.Artwork.Style].MovedBars[v:GetName()] then
					SUI.DB.Styles[SUI.DBMod.Artwork.Style].MovedBars[v:GetName()] = false
				end
			end

			SUI:GetModule('Style_' .. SUI.DBMod.Artwork.Style):SetupProfile()

			SUI_Win.Artwork:Hide()
			SUI_Win.Artwork = nil
		end,
		RequireReload = true,
		Priority = 1,
		Skipable = true,
		NoReloadOnSkip = true,
		Skip = function()
			SUI.DBMod.PlayerFrames.SetupDone = true
		end
	}

	-- local SetupWindow = SUI:GetModule("SetupWindow")
	-- SetupWindow:AddPage(PageData)
	-- SetupWindow:DisplayPage()

	-- Temporary
	SUI.DBMod.PlayerFrames.SetupDone = true
end

function PlayerFrames:OnInitialize()
	if not SUI.DBMod.PlayerFrames.SetupDone then
		PlayerFrames:FirstTime()
	end
end
