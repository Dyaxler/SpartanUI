local _G, SUI, L = _G, SUI, SUI.L
local module = SUI:GetModule('Component_UnitFrames')
----------------------------------------------------------------------------------------------------
local anchorPoints = {
	['TOPLEFT'] = 'TOP LEFT',
	['TOP'] = 'TOP',
	['TOPRIGHT'] = 'TOP RIGHT',
	['RIGHT'] = 'RIGHT',
	['CENTER'] = 'CENTER',
	['LEFT'] = 'LEFT',
	['BOTTOMLEFT'] = 'BOTTOM LEFT',
	['BOTTOM'] = 'BOTTOM',
	['BOTTOMRIGHT'] = 'BOTTOM RIGHT'
}
local limitedAnchorPoints = {
	['TOPLEFT'] = 'TOP LEFT',
	['TOPRIGHT'] = 'TOP RIGHT',
	['BOTTOMLEFT'] = 'BOTTOM LEFT',
	['BOTTOMRIGHT'] = 'BOTTOM RIGHT'
}

local frameList = {
	'player',
	'target',
	'targettarget',
	'boss',
	'bosstarget',
	'pet',
	'pettarget',
	'focus',
	'focustarget',
	'party',
	'partypet',
	'partytarget',
	'raid',
	'arena'
}

if SUI.IsClassic then
	frameList = {
		'player',
		'target',
		'targettarget',
		'boss',
		'bosstarget',
		'pet',
		'pettarget',
		'party',
		'partypet',
		'partytarget',
		'raid',
		'arena'
	}
end

----------------------------------------------------------------------------------------------------

local function CreateOptionSet(frameName, order)
	SUI.opt.args.UnitFrames.args[frameName] = {
		name = frameName,
		type = 'group',
		order = order,
		childGroups = 'tab',
		args = {
			indicators = {
				name = 'Indicators',
				type = 'group',
				order = 40,
				childGroups = 'tree',
				args = {}
			},
			text = {
				name = 'Text',
				type = 'group',
				order = 50,
				childGroups = 'tree',
				args = {}
			}
		}
	}
end

local function AddGeneralOptions(frameName)
	SUI.opt.args.UnitFrames.args[frameName].args['general'] = {
		name = 'General',
		desc = 'General display settings',
		type = 'group',
		-- childGroups = 'inline',
		order = 10,
		args = {
			General = {
				name = 'General',
				type = 'group',
				order = 1,
				inline = true,
				args = {
					width = {
						name = 'Frame width',
						type = 'range',
						width = 'full',
						order = 2,
						min = 1,
						max = 300,
						step = .1,
						get = function(info)
							return module.CurrentSettings[frameName].width
						end,
						set = function(info, val)
							--Update memory
							module.CurrentSettings[frameName].width = val
							--Update the DB
							SUI.DB.Unitframes.PlayerCustomizations[SUI.DB.Unitframes.Style][frameName].width = val
							--Update the screen
							module.frames[frameName]:UpdateSize()
						end
					},
					range = {
						name = 'Fade out of range',
						width = 'double',
						type = 'toggle',
						get = function(info)
							return module.CurrentSettings[frameName].elements.Range.enabled
						end,
						set = function(info, val)
							--Update memory
							module.CurrentSettings[frameName].elements.Range.enabled = val
							--Update the DB
							SUI.DB.Unitframes.PlayerCustomizations[SUI.DB.Unitframes.Style][frameName].elements.Range.enabled = val
							--Update the screen
							if module.frames[frameName].Range then
								if val then
									module.frames[frameName]:EnableElement('Range')
									module.frames[frameName].Range:ForceUpdate()
								else
									module.frames[frameName]:DisableElement('Range')
								end
							else
								module.frames[frameName]:UpdateAll()
							end
						end
					}
				}
			},
			portrait = {
				name = 'Portrait',
				type = 'group',
				order = 3,
				inline = true,
				args = {
					enabled = {
						name = L['Enabled'],
						type = 'toggle',
						order = 10,
						get = function(info)
							return module.CurrentSettings[frameName].elements.Portrait.enabled
						end,
						set = function(info, val)
							--Update memory
							module.CurrentSettings[frameName].elements.Portrait.enabled = val
							--Update the DB
							SUI.DB.Unitframes.PlayerCustomizations[SUI.DB.Unitframes.Style][frameName].elements.Portrait.enabled = val
							--Update the screen
							if module.frames[frameName].Portrait then
								if val then
									module.frames[frameName]:EnableElement('Portrait')
									module.frames[frameName].Portrait:ForceUpdate()
								else
									module.frames[frameName]:DisableElement('Portrait')
								end
							else
								module.frames[frameName]:UpdateAll()
							end
						end
					},
					type = {
						name = 'Portrait type',
						type = 'select',
						order = 20,
						values = {
							['3D'] = '3D',
							['2D'] = '2D'
						},
						get = function(info)
							return module.CurrentSettings[frameName].elements.Portrait.type
						end,
						set = function(info, val)
							--Update memory
							module.CurrentSettings[frameName].elements.Portrait.type = val
							--Update the DB
							SUI.DB.Unitframes.PlayerCustomizations[SUI.DB.Unitframes.Style][frameName].elements.Portrait.type = val
							--Update the screen
							module.frames[frameName]:ElementUpdate('Portrait')
						end
					},
					rotation = {
						name = 'Rotation',
						type = 'range',
						min = -1,
						max = 1,
						step = .01,
						order = 21,
						get = function(info)
							return module.CurrentSettings[frameName].elements.Portrait.rotation
						end,
						set = function(info, val)
							--Update memory
							module.CurrentSettings[frameName].elements.Portrait.rotation = val
							--Update the DB
							SUI.DB.Unitframes.PlayerCustomizations[SUI.DB.Unitframes.Style][frameName].elements.Portrait.rotation = val
							--Update the screen
							module.frames[frameName]:ElementUpdate('Portrait')
						end
					},
					camDistanceScale = {
						name = 'Camera Distance Scale',
						type = 'range',
						min = -1,
						max = 5,
						step = .1,
						order = 22,
						get = function(info)
							return module.CurrentSettings[frameName].elements.Portrait.camDistanceScale
						end,
						set = function(info, val)
							--Update memory
							module.CurrentSettings[frameName].elements.Portrait.camDistanceScale = val
							--Update the DB
							SUI.DB.Unitframes.PlayerCustomizations[SUI.DB.Unitframes.Style][frameName].elements.Portrait.camDistanceScale = val
							--Update the screen
							module.frames[frameName]:ElementUpdate('Portrait')
						end
					},
					position = {
						name = 'Position',
						type = 'select',
						order = 30,
						values = {
							['left'] = L['Left'],
							['right'] = L['Right']
						},
						get = function(info)
							return module.CurrentSettings[frameName].elements.Portrait.position
						end,
						set = function(info, val)
							--Update memory
							module.CurrentSettings[frameName].elements.Portrait.position = val
							--Update the DB
							SUI.DB.Unitframes.PlayerCustomizations[SUI.DB.Unitframes.Style][frameName].elements.Portrait.position = val
							--Update the screen
							module.frames[frameName]:ElementUpdate('Portrait')
						end
					}
				}
			}
		}
	}
end

local function AddArtworkOptions(frameName)
	SUI.opt.args.UnitFrames.args[frameName].args['artwork'] = {
		name = 'Artwork',
		type = 'group',
		order = 20,
		args = {
			top = {
				name = 'Top',
				type = 'group',
				order = 1,
				inline = true,
				args = {
					War = {
						name = 'War',
						order = 1.1,
						type = 'description',
						width = 'normal',
						image = function()
							return 'interface\\addons\\SpartanUI\\images\\setup\\Style_Frames_War', 120, 40
						end,
						imageCoords = function()
							return {0, .5, 0, 0.203125}
						end
					},
					Fel = {
						name = 'War',
						order = 1.2,
						width = 'normal',
						type = 'description',
						image = function()
							return 'Interface\\Scenarios\\LegionInvasion', 120, 40
						end,
						imageCoords = function()
							return {0.140625, 0.615234375, 0, 0.14453125}
						end
					},
					enabled = {
						name = 'Enabled',
						type = 'toggle',
						order = 2,
						get = function(info)
							return module.CurrentSettings[frameName].artwork.top.enabled
						end,
						set = function(info, val)
							--Update memory
							module.CurrentSettings[frameName].artwork.top.enabled = val
							--Update the DB
							SUI.DB.Unitframes.PlayerCustomizations[SUI.DB.Unitframes.Style][frameName].artwork.top.enabled = val
						end
					},
					x = {
						name = 'X Axis',
						type = 'range',
						min = -100,
						max = 100,
						step = 1,
						get = function(info)
							return module.CurrentSettings[frameName].artwork.top.x
						end,
						set = function(info, val)
							--Update memory
							module.CurrentSettings[frameName].artwork.top.x = val
							--Update the DB
							SUI.DB.Unitframes.PlayerCustomizations[SUI.DB.Unitframes.Style][frameName].artwork.top.x = val
						end
					},
					y = {
						name = 'Y Axis',
						type = 'range',
						min = -100,
						max = 100,
						step = 1,
						get = function(info)
							return module.CurrentSettings[frameName].artwork.top.y
						end,
						set = function(info, val)
							--Update memory
							module.CurrentSettings[frameName].artwork.top.y = val
							--Update the DB
							SUI.DB.Unitframes.PlayerCustomizations[SUI.DB.Unitframes.Style][frameName].artwork.top.y = val
						end
					},
					StyleDropdown = {
						name = 'Current Style',
						type = 'select',
						order = 3,
						values = {
							['war'] = 'War',
							['fel'] = 'Fel'
						},
						get = function(info)
							return module.CurrentSettings[frameName].artwork.top.graphic
						end,
						set = function(info, val)
							--Update memory
							module.CurrentSettings[frameName].artwork.top.graphic = val
							--Update the DB
							SUI.DB.Unitframes.PlayerCustomizations[SUI.DB.Unitframes.Style][frameName].artwork.top.graphic = val
						end
					}
				}
			}
		}
	}
end

local function AddBarOptions(frameName)
	SUI.opt.args.UnitFrames.args[frameName].args['bars'] = {
		name = 'Bars',
		type = 'group',
		order = 30,
		childGroups = 'tree',
		args = {
			Castbar = {
				name = 'Castbar',
				type = 'group',
				order = 1,
				args = {
					Interruptable = {
						name = 'Show interrupt or spell steal',
						type = 'toggle',
						order = 10,
						get = function(info)
							return module.CurrentSettings[frameName].elements.Castbar.interruptable
						end,
						set = function(info, val)
							--Update memory
							module.CurrentSettings[frameName].elements.Castbar.interruptable = val
							--Update the DB
							SUI.DB.Unitframes.PlayerCustomizations[SUI.DB.Unitframes.Style][frameName].elements.Castbar.interruptable = val
							--Update the screen
							module.frames[frameName]:UpdateAll()
						end
					},
					latency = {
						name = 'Show latency',
						type = 'toggle',
						order = 11,
						get = function(info)
							return module.CurrentSettings[frameName].elements.Castbar.latency
						end,
						set = function(info, val)
							--Update memory
							module.CurrentSettings[frameName].elements.Castbar.latency = val
							--Update the DB
							SUI.DB.Unitframes.PlayerCustomizations[SUI.DB.Unitframes.Style][frameName].elements.Castbar.latency = val
							--Update the screen
							module.frames[frameName]:UpdateAll()
						end
					},
					Icon = {
						name = 'Spell icon',
						type = 'group',
						inline = true,
						order = 30,
						args = {
							enabled = {
								name = 'Enable',
								type = 'toggle',
								order = 1,
								get = function(info)
									return module.CurrentSettings[frameName].elements.Castbar.Icon.enabled
								end,
								set = function(info, val)
									--Update memory
									module.CurrentSettings[frameName].elements.Castbar.Icon.enabled = val
									--Update the DB
									SUI.DB.Unitframes.PlayerCustomizations[SUI.DB.Unitframes.Style][frameName].elements.Castbar.Icon.enabled = val
									--Update the screen
									module.frames[frameName]:UpdateAll()
								end
							},
							size = {
								name = 'Size',
								type = 'range',
								min = 0,
								max = 100,
								step = .1,
								order = 5,
								get = function(info)
									return module.CurrentSettings[frameName].elements.Castbar.Icon.size
								end,
								set = function(info, val)
									--Update memory
									module.CurrentSettings[frameName].elements.Castbar.Icon.size = val
									--Update the DB
									SUI.DB.Unitframes.PlayerCustomizations[SUI.DB.Unitframes.Style][frameName].elements.Castbar.Icon.size = val
									--Update Screen
									if module.frames[frameName].Castbar.Icon then
										module.frames[frameName].Castbar.Icon:SetSize(val, val)
									end
								end
							},
							position = {
								name = 'Position',
								type = 'group',
								order = 50,
								inline = true,
								args = {
									x = {
										name = 'X Axis',
										type = 'range',
										order = 1,
										min = -100,
										max = 100,
										step = 1,
										get = function(info)
											return module.CurrentSettings[frameName].elements.Castbar.Icon.position.x
										end,
										set = function(info, val)
											--Update memory
											module.CurrentSettings[frameName].elements.Castbar.Icon.position.x = val
											--Update the DB
											SUI.DB.Unitframes.PlayerCustomizations[SUI.DB.Unitframes.Style][frameName].elements.Castbar.Icon.position.x =
												val
											--Update Screen
											module.frames[frameName]:UpdateAll()
										end
									},
									y = {
										name = 'Y Axis',
										type = 'range',
										order = 2,
										min = -100,
										max = 100,
										step = 1,
										get = function(info)
											return module.CurrentSettings[frameName].elements.Castbar.Icon.position.y
										end,
										set = function(info, val)
											--Update memory
											module.CurrentSettings[frameName].elements.Castbar.Icon.position.y = val
											--Update the DB
											SUI.DB.Unitframes.PlayerCustomizations[SUI.DB.Unitframes.Style][frameName].elements.Castbar.Icon.position.y =
												val
											--Update Screen
											module.frames[frameName]:UpdateAll()
										end
									},
									anchor = {
										name = 'Anchor point',
										type = 'select',
										order = 3,
										values = anchorPoints,
										get = function(info)
											return module.CurrentSettings[frameName].elements.Castbar.Icon.position.anchor
										end,
										set = function(info, val)
											--Update memory
											module.CurrentSettings[frameName].elements.Castbar.Icon.position.anchor = val
											--Update the DB
											SUI.DB.Unitframes.PlayerCustomizations[SUI.DB.Unitframes.Style][frameName].elements.Castbar.Icon.position.anchor =
												val
											--Update Screen
											module.frames[frameName]:UpdateAll()
										end
									}
								}
							}
						}
					}
				}
			},
			Health = {
				name = 'Health',
				type = 'group',
				order = 2,
				args = {
					healthprediction = {
						name = 'Health prediction',
						type = 'toggle',
						order = 5,
						get = function(info)
							return module.CurrentSettings[frameName].elements.HealthPrediction
						end,
						set = function(info, val)
							--Update the screen
							module.frames[frameName].HealthPrediction = val
							--Update memory
							module.CurrentSettings[frameName].elements.HealthPrediction = val
							--Update the DB
							SUI.DB.Unitframes.PlayerCustomizations[SUI.DB.Unitframes.Style][frameName].elements.HealthPrediction = val
						end
					},
					coloring = {
						name = 'Color health bar by:',
						desc = 'The below options are in order of wich they apply',
						order = 10,
						inline = true,
						type = 'group',
						args = {
							colorTapping = {
								name = 'Tapped',
								desc = "Color's the bar if the unit isn't tapped by the player",
								type = 'toggle',
								order = 1,
								get = function(info)
									return module.CurrentSettings[frameName].elements.Health.colorTapping
								end,
								set = function(info, val)
									--Update memory
									module.CurrentSettings[frameName].elements.Health.colorTapping = val
									--Update the DB
									SUI.DB.Unitframes.PlayerCustomizations[SUI.DB.Unitframes.Style][frameName].elements.Health.colorTapping = val
									--Update the screen
									module.frames[frameName]:UpdateAll()
								end
							},
							colorDisconnected = {
								name = 'Disconnected',
								desc = 'Color the bar if the player is offline',
								type = 'toggle',
								order = 2,
								get = function(info)
									return module.CurrentSettings[frameName].elements.Health.colorDisconnected
								end,
								set = function(info, val)
									--Update memory
									module.CurrentSettings[frameName].elements.Health.colorDisconnected = val
									--Update the DB
									SUI.DB.Unitframes.PlayerCustomizations[SUI.DB.Unitframes.Style][frameName].elements.Health.colorDisconnected =
										val
									--Update the screen
									module.frames[frameName]:UpdateAll()
								end
							},
							colorClass = {
								name = 'Class',
								desc = 'Color the bar based on unit class',
								type = 'toggle',
								order = 3,
								get = function(info)
									return module.CurrentSettings[frameName].elements.Health.colorClass
								end,
								set = function(info, val)
									--Update memory
									module.CurrentSettings[frameName].elements.Health.colorClass = val
									--Update the DB
									SUI.DB.Unitframes.PlayerCustomizations[SUI.DB.Unitframes.Style][frameName].elements.Health.colorClass = val
									--Update the screen
									module.frames[frameName]:UpdateAll()
								end
							},
							colorReaction = {
								name = 'Reaction',
								desc = "color the bar based on the player's reaction towards the player.",
								type = 'toggle',
								order = 4,
								get = function(info)
									return module.CurrentSettings[frameName].elements.Health.colorReaction
								end,
								set = function(info, val)
									--Update memory
									module.CurrentSettings[frameName].elements.Health.colorReaction = val
									--Update the DB
									SUI.DB.Unitframes.PlayerCustomizations[SUI.DB.Unitframes.Style][frameName].elements.Health.colorReaction = val
									--Update the screen
									module.frames[frameName]:UpdateAll()
								end
							},
							colorSmooth = {
								name = 'Smooth',
								desc = "color the bar with a smooth gradient based on the player's current health percentage",
								type = 'toggle',
								order = 5,
								get = function(info)
									return module.CurrentSettings[frameName].elements.Health.colorSmooth
								end,
								set = function(info, val)
									--Update memory
									module.CurrentSettings[frameName].elements.Health.colorSmooth = val
									--Update the DB
									SUI.DB.Unitframes.PlayerCustomizations[SUI.DB.Unitframes.Style][frameName].elements.Health.colorSmooth = val
									--Update the screen
									module.frames[frameName]:UpdateAll()
								end
							}
						}
					}
				}
			},
			Power = {
				name = 'Power',
				type = 'group',
				order = 3,
				childGroups = 'inline',
				args = {}
			}
		}
	}

	local bars = {'Castbar', 'Health', 'Power'}
	for _, key in ipairs(bars) do
		SUI.opt.args.UnitFrames.args[frameName].args['bars'].args[key].args['enabled'] = {
			name = L['Enabled'],
			type = 'toggle',
			width = 'full',
			order = 1,
			get = function(info)
				return module.CurrentSettings[frameName].elements[key].enabled
			end,
			set = function(info, val)
				--Update memory
				module.CurrentSettings[frameName].elements[key].enabled = val
				--Update the DB
				SUI.DB.Unitframes.PlayerCustomizations[SUI.DB.Unitframes.Style][frameName].elements[key].enabled = val
				--Update the screen
				module.frames[frameName]:UpdateAll()
			end
		}
		SUI.opt.args.UnitFrames.args[frameName].args['bars'].args[key].args['height'] = {
			name = 'Height',
			type = 'range',
			width = 'full',
			order = 2,
			min = 2,
			max = 100,
			step = 1,
			get = function(info)
				return module.CurrentSettings[frameName].elements[key].height
			end,
			set = function(info, val)
				--Update memory
				module.CurrentSettings[frameName].elements[key].height = val
				--Update the DB
				SUI.DB.Unitframes.PlayerCustomizations[SUI.DB.Unitframes.Style][frameName].elements[key].height = val
				--Update the screen
				module.frames[frameName]:UpdateSize()
			end
		}
	end

	if frameName == 'player' then
		if not SUI.IsClassic then
			SUI.opt.args.UnitFrames.args.player.args['bars'].args['Power'].args['PowerPrediction'] = {
				name = 'Enable power prediction',
				desc = 'Used to represent cost of spells on top of the Power bar',
				type = 'toggle',
				width = 'double',
				order = 10,
				get = function(info)
					return module.CurrentSettings.player.elements.Power.PowerPrediction
				end,
				set = function(info, val)
					--Update the screen
					if val then
						module.frames.player:EnableElement('PowerPrediction')
					else
						module.frames.player:DisableElement('PowerPrediction')
					end
					--Update memory
					module.CurrentSettings.player.elements.Power.PowerPrediction = val
					--Update the DB
					SUI.DB.Unitframes.PlayerCustomizations[SUI.DB.Unitframes.Style].player.elements.Power.PowerPrediction = val
				end
			}
		end

		SUI.opt.args.UnitFrames.args.player.args['bars'].args['AdditionalPower'] = {
			name = 'Additional power',
			desc = "player's additional power, such as Mana for Balance druids.",
			order = 20,
			type = 'group',
			childGroups = 'inline',
			args = {
				enabled = {
					name = L['Enabled'],
					type = 'toggle',
					width = 'full',
					order = 1,
					get = function(info)
						return module.CurrentSettings.player.elements.AdditionalPower.enabled
					end,
					set = function(info, val)
						--Update the screen
						if val then
							module.frames.player:EnableElement('AdditionalPower')
						else
							module.frames.player:DisableElement('AdditionalPower')
						end
						--Update memory
						module.CurrentSettings.player.elements.AdditionalPower.enabled = val
						--Update the DB
						SUI.DB.Unitframes.PlayerCustomizations[SUI.DB.Unitframes.Style].player.elements.AdditionalPower.enabled = val
					end
				},
				height = {
					name = 'Height',
					type = 'range',
					width = 'full',
					order = 2,
					min = 2,
					max = 100,
					step = 1,
					get = function(info)
						return module.CurrentSettings.player.elements.AdditionalPower.height
					end,
					set = function(info, val)
						--Update memory
						module.CurrentSettings.player.elements.AdditionalPower.height = val
						--Update the DB
						SUI.DB.Unitframes.PlayerCustomizations[SUI.DB.Unitframes.Style].player.elements.AdditionalPower.height = val
						--Update the screen
						module.frames.player:UpdateSize()
					end
				}
			}
		}
	end

	if frameName == 'player' or frameName == 'party' or frameName == 'raid' then
		SUI.opt.args.UnitFrames.args[frameName].args['bars'].args['Castbar'].args['Interruptable'].hidden = true
	end
end

local function AddIndicatorOptions(frameName)
	local PlayerOnly = {
		['CombatIndicator'] = 'Combat',
		['RestingIndicator'] = 'Resting',
		['Runes'] = 'Runes',
		['Stagger'] = 'Stagger',
		['Totems'] = 'Totems'
	}
	local FriendlyOnly = {
		['AssistantIndicator'] = RAID_ASSISTANT,
		['GroupRoleIndicator'] = 'Group role',
		['LeaderIndicator'] = 'Leader',
		['PhaseIndicator'] = 'Phase',
		['PvPIndicator'] = 'PvP',
		['RaidRoleIndicator'] = 'Main tank or assist',
		['ReadyCheckIndicator'] = 'Ready check icon',
		['ResurrectIndicator'] = 'Resurrect',
		['SummonIndicator'] = 'Summon'
	}
	local targetOnly = {
		['QuestIndicator'] = 'Quest'
	}
	local AllIndicators = {
		['SUI_ClassIcon'] = 'Class icon',
		['RaidTargetIndicator'] = RAID_TARGET_ICON,
		['ThreatIndicator'] = 'Threat'
	}

	-- Text indicators
	-- ['StatusText'] = STATUS_TEXT,
	-- ['SUI_RaidGroup'] = 'Raid group'

	-- Check frameName for what tables above need to be applied
	if frameName == 'player' then
		AllIndicators = SUI:MergeData(AllIndicators, PlayerOnly)
	end
	if frameName == 'pet' and SUI.IsClassic then
		local petIndicator = {
			['PetHappiness'] = 'Pet happiness'
		}
		AllIndicators = SUI:MergeData(AllIndicators, petIndicator)
	end
	if frameName == 'target' then
		AllIndicators = SUI:MergeData(AllIndicators, targetOnly)
	end
	if module:IsFriendlyFrame(frameName) then
		AllIndicators = SUI:MergeData(AllIndicators, FriendlyOnly)
	end

	for key, name in pairs(AllIndicators) do
		SUI.opt.args.UnitFrames.args[frameName].args.indicators.args[key] = {
			name = name,
			type = 'group',
			args = {
				enable = {
					name = L['Enabled'],
					type = 'toggle',
					order = 10,
					get = function(info)
						return module.CurrentSettings[frameName].elements[key].enabled
					end,
					set = function(info, val)
						--Update memory
						module.CurrentSettings[frameName].elements[key].enabled = val
						--Update the DB
						SUI.DB.Unitframes.PlayerCustomizations[SUI.DB.Unitframes.Style][frameName].elements[key].enabled = val
						--Update the screen
						if val then
							module.frames[frameName]:EnableElement(key)
							module.frames[frameName][key]:ForceUpdate()
						else
							module.frames[frameName]:DisableElement(key)
							module.frames[frameName][key]:Hide()
						end
					end
				},
				display = {
					name = 'Display',
					type = 'group',
					order = 20,
					inline = true,
					args = {
						size = {
							name = 'Size',
							type = 'range',
							min = 0,
							max = 100,
							step = .1,
							order = 1,
							get = function(info)
								return module.CurrentSettings[frameName].elements[key].size
							end,
							set = function(info, val)
								--Update memory
								module.CurrentSettings[frameName].elements[key].size = val
								--Update the DB
								SUI.DB.Unitframes.PlayerCustomizations[SUI.DB.Unitframes.Style][frameName].elements[key].size = val
								--Update Screen
								module.frames[frameName]:ElementUpdate(key)
							end
						},
						scale = {
							name = 'Scale',
							type = 'range',
							min = .1,
							max = 3,
							step = .01,
							order = 2,
							get = function(info)
								return module.CurrentSettings[frameName].elements[key].scale
							end,
							set = function(info, val)
								--Update memory
								module.CurrentSettings[frameName].elements[key].scale = val
								--Update the DB
								SUI.DB.Unitframes.PlayerCustomizations[SUI.DB.Unitframes.Style][frameName].elements[key].scale = val
								--Update Screen
								module.frames[frameName]:ElementUpdate(key)
							end
						},
						alpha = {
							name = 'Alpha',
							type = 'range',
							min = 0,
							max = 1,
							step = .01,
							order = 3,
							get = function(info)
								return module.CurrentSettings[frameName].elements[key].alpha
							end,
							set = function(info, val)
								--Update memory
								module.CurrentSettings[frameName].elements[key].alpha = val
								--Update the DB
								SUI.DB.Unitframes.PlayerCustomizations[SUI.DB.Unitframes.Style][frameName].elements[key].alpha = val
								--Update Screen
								module.frames[frameName]:ElementUpdate(key)
							end
						}
					}
				},
				position = {
					name = 'Position',
					type = 'group',
					order = 50,
					inline = true,
					args = {
						x = {
							name = 'X Axis',
							type = 'range',
							order = 1,
							min = -100,
							max = 100,
							step = 1,
							get = function(info)
								return module.CurrentSettings[frameName].elements[key].position.x
							end,
							set = function(info, val)
								--Update memory
								module.CurrentSettings[frameName].elements[key].position.x = val
								--Update the DB
								SUI.DB.Unitframes.PlayerCustomizations[SUI.DB.Unitframes.Style][frameName].elements[key].position.x = val
								--Update Screen
								module.frames[frameName]:ElementUpdate(key)
							end
						},
						y = {
							name = 'Y Axis',
							type = 'range',
							order = 2,
							min = -100,
							max = 100,
							step = 1,
							get = function(info)
								return module.CurrentSettings[frameName].elements[key].position.y
							end,
							set = function(info, val)
								--Update memory
								module.CurrentSettings[frameName].elements[key].position.y = val
								--Update the DB
								SUI.DB.Unitframes.PlayerCustomizations[SUI.DB.Unitframes.Style][frameName].elements[key].position.y = val
								--Update Screen
								module.frames[frameName]:ElementUpdate(key)
							end
						},
						anchor = {
							name = 'Anchor point',
							type = 'select',
							order = 3,
							values = anchorPoints,
							get = function(info)
								return module.CurrentSettings[frameName].elements[key].position.anchor
							end,
							set = function(info, val)
								--Update memory
								module.CurrentSettings[frameName].elements[key].position.anchor = val
								--Update the DB
								SUI.DB.Unitframes.PlayerCustomizations[SUI.DB.Unitframes.Style][frameName].elements[key].position.anchor = val
								--Update Screen
								module.frames[frameName]:ElementUpdate(key)
							end
						}
					}
				}
			}
		}
	end
	if SUI.opt.args.UnitFrames.args[frameName].args.indicators.args.PvPIndicator then
		-- Badge
		SUI.opt.args.UnitFrames.args[frameName].args.indicators.args.PvPIndicator.args['Badge'] = {
			name = 'Show honor badge',
			type = 'toggle',
			get = function(info)
				return module.CurrentSettings[frameName].elements.PvPIndicator.badge
			end,
			set = function(info, val)
				--Update memory
				module.CurrentSettings[frameName].elements.PvPIndicator.badge = val
				--Update the DB
				SUI.DB.Unitframes.PlayerCustomizations[SUI.DB.Unitframes.Style][frameName].elements.PvPIndicator.badge = val
				--Update the screen
				if val then
					module.frames[frameName].PvPIndicator.Badge = module.frames[frameName].PvPIndicator.BadgeBackup
				else
					module.frames[frameName].PvPIndicator.Badge:Hide()
					module.frames[frameName].PvPIndicator.Badge = nil
				end
				module.frames[frameName].PvPIndicator:ForceUpdate('OnUpdate')
			end
		}
	end

	-- Non player items like
	if frameName ~= 'player' then
		SUI.opt.args.UnitFrames.args[frameName].args.indicators.args.Range = {
			name = 'Range',
			type = 'group',
			args = {
				enable = {
					name = L['Enabled'],
					type = 'toggle',
					order = 10,
					get = function(info)
						return module.CurrentSettings[frameName].elements.Range.enabled
					end,
					set = function(info, val)
						--Update memory
						module.CurrentSettings[frameName].elements.Range.enabled = val
						--Update the DB
						SUI.DB.Unitframes.PlayerCustomizations[SUI.DB.Unitframes.Style][frameName].elements.Range.enabled = val
						--Update the screen
						if val then
							module.frames[frameName]:EnableElement(key)
						else
							module.frames[frameName]:DisableElement(key)
						end
						module.frames[frameName].Range:ForceUpdate()
					end
				},
				insideAlpha = {
					name = 'In range alpha',
					type = 'range',
					min = 0,
					max = 1,
					step = .1,
					get = function(info)
						return module.CurrentSettings[frameName].elements.Range.insideAlpha
					end,
					set = function(info, val)
						--Update memory
						module.CurrentSettings[frameName].elements.Range.insideAlpha = val
						--Update the DB
						SUI.DB.Unitframes.PlayerCustomizations[SUI.DB.Unitframes.Style][frameName].elements.Range.insideAlpha = val
						--Update the screen
						module.frames[frameName].Range.insideAlpha = val
					end
				},
				outsideAlpha = {
					name = 'Out of range alpha',
					type = 'range',
					min = 0,
					max = 1,
					step = .1,
					get = function(info)
						return module.CurrentSettings[frameName].elements.Range.outsideAlpha
					end,
					set = function(info, val)
						--Update memory
						module.CurrentSettings[frameName].elements.Range.outsideAlpha = val
						--Update the DB
						SUI.DB.Unitframes.PlayerCustomizations[SUI.DB.Unitframes.Style][frameName].elements.Range.outsideAlpha = val
						--Update the screen
						module.frames[frameName].Range.outsideAlpha = val
					end
				}
			}
		}
	end

	-- Hide a few generated options from specific frame
	if frameName == 'player' then
		SUI.opt.args.UnitFrames.args[frameName].args['indicators'].args['ThreatIndicator'].hidden = true
	elseif frameName == 'boss' then
		SUI.opt.args.UnitFrames.args[frameName].args['indicators'].args['SUI_ClassIcon'].hidden = true
	end
end

local function AddDynamicText(frameName, element, count)
	SUI.opt.args.UnitFrames.args[frameName].args['text'].args[element].args[count] = {
		name = 'Text element ' .. count,
		type = 'group',
		inline = true,
		order = (10 + count),
		args = {
			enabled = {
				name = L['Enabled'],
				type = 'toggle',
				order = 1,
				get = function(info)
					return module.CurrentSettings[frameName].elements[element].text[count].enabled
				end,
				set = function(info, val)
					--Update memory
					module.CurrentSettings[frameName].elements[element].text[count].enabled = val
					--Update the DB
					SUI.DB.Unitframes.PlayerCustomizations[SUI.DB.Unitframes.Style][frameName].elements[element].text[count].enabled =
						val
					--Update the screen
					if val then
						module.frames[frameName][element].TextElements[count]:Show()
					else
						module.frames[frameName][element].TextElements[count]:Hide()
					end
				end
			},
			text = {
				name = 'Text',
				type = 'input',
				width = 'full',
				order = 2,
				get = function(info)
					return module.CurrentSettings[frameName].elements[element].text[count].text
				end,
				set = function(info, val)
					--Update memory
					module.CurrentSettings[frameName].elements[element].text[count].text = val
					--Update the DB
					SUI.DB.Unitframes.PlayerCustomizations[SUI.DB.Unitframes.Style][frameName].elements[element].text[count].text = val
					--Update the screen
					module.frames[frameName]:Tag(module.frames[frameName][element].TextElements[count], val)
					module.frames[frameName]:UpdateTags()
				end
			},
			size = {
				name = 'Size',
				type = 'range',
				width = 'full',
				min = 1,
				max = 30,
				step = 1,
				order = 1.5,
				get = function(info)
					return module.CurrentSettings[frameName].elements[element].text[count].size
				end,
				set = function(info, val)
					--Update memory
					module.CurrentSettings[frameName].elements[element].text[count].size = val
					--Update the DB
					SUI.DB.Unitframes.PlayerCustomizations[SUI.DB.Unitframes.Style][frameName].elements[element].text[count].size = val
					--Update the screen
					SUI:UpdateDefaultSize(module.frames[frameName][element].TextElements[count], val, 'UnitFrames')
				end
			},
			position = {
				name = 'Position',
				type = 'group',
				order = 50,
				inline = true,
				args = {
					x = {
						name = 'X Axis',
						type = 'range',
						order = 1,
						min = -100,
						max = 100,
						step = 1,
						get = function(info)
							return module.CurrentSettings[frameName].elements[element].text[count].position.x
						end,
						set = function(info, val)
							--Update memory
							module.CurrentSettings[frameName].elements[element].text[count].position.x = val
							--Update the DB
							SUI.DB.Unitframes.PlayerCustomizations[SUI.DB.Unitframes.Style][frameName].elements[element].text[count].position.x =
								val
							--Update the screen
							local position = module.CurrentSettings[frameName].elements[element].text[count].position
							module.frames[frameName][element].TextElements[count]:ClearAllPoints()
							module.frames[frameName][element].TextElements[count]:SetPoint(
								position.anchor,
								module.frames[frameName],
								position.anchor,
								position.x,
								position.y
							)
						end
					},
					y = {
						name = 'Y Axis',
						type = 'range',
						order = 2,
						min = -100,
						max = 100,
						step = 1,
						get = function(info)
							return module.CurrentSettings[frameName].elements[element].text[count].position.y
						end,
						set = function(info, val)
							--Update memory
							module.CurrentSettings[frameName].elements[element].text[count].position.y = val
							--Update the DB
							SUI.DB.Unitframes.PlayerCustomizations[SUI.DB.Unitframes.Style][frameName].elements[element].text[count].position.y =
								val
							--Update the screen
							local position = module.CurrentSettings[frameName].elements[element].text[count].position
							module.frames[frameName][element].TextElements[count]:ClearAllPoints()
							module.frames[frameName][element].TextElements[count]:SetPoint(
								position.anchor,
								module.frames[frameName],
								position.anchor,
								position.x,
								position.y
							)
						end
					},
					anchor = {
						name = 'Anchor point',
						type = 'select',
						order = 3,
						values = anchorPoints,
						get = function(info)
							return module.CurrentSettings[frameName].elements[element].text[count].position.anchor
						end,
						set = function(info, val)
							--Update memory
							module.CurrentSettings[frameName].elements[element].text[count].position.anchor = val
							--Update the DB
							SUI.DB.Unitframes.PlayerCustomizations[SUI.DB.Unitframes.Style][frameName].elements[element].text[count].position.anchor =
								val
							--Update the screen
							local position = module.CurrentSettings[frameName].elements[element].text[count].position
							module.frames[frameName][element].TextElements[count]:ClearAllPoints()
							module.frames[frameName][element].TextElements[count]:SetPoint(
								position.anchor,
								module.frames[frameName],
								position.anchor,
								position.x,
								position.y
							)
						end
					}
				}
			}
		}
	}
end

local function AddTextOptions(frameName)
	SUI.opt.args.UnitFrames.args[frameName].args['text'].args['Castbar'] = {
		name = 'Castbar',
		type = 'group',
		order = 1,
		args = {}
	}
	SUI.opt.args.UnitFrames.args[frameName].args['text'].args['Health'] = {
		name = 'Health',
		type = 'group',
		order = 2,
		args = {}
	}
	SUI.opt.args.UnitFrames.args[frameName].args['text'].args['Power'] = {
		name = 'Power',
		type = 'group',
		order = 3,
		args = {}
	}

	for i in pairs(module.CurrentSettings[frameName].elements.Castbar.text) do
		AddDynamicText(frameName, 'Castbar', i)
	end
	SUI.opt.args.UnitFrames.args[frameName].args['text'].args['Castbar'].args['1'].args['text'].disabled = true
	SUI.opt.args.UnitFrames.args[frameName].args['text'].args['Castbar'].args['2'].args['text'].disabled = true

	for i in pairs(module.CurrentSettings[frameName].elements.Health.text) do
		AddDynamicText(frameName, 'Health', i)
	end

	for i in pairs(module.CurrentSettings[frameName].elements.Power.text) do
		AddDynamicText(frameName, 'Power', i)
	end

	local StringElements = {
		['SUI_RaidGroup'] = 'Raid group',
		['Name'] = 'Name',
		['StatusText'] = 'Player status'
	}

	for key, name in pairs(StringElements) do
		SUI.opt.args.UnitFrames.args[frameName].args['text'].args[key] = {
			name = name,
			type = 'group',
			order = 1,
			args = {
				enabled = {
					name = L['Enabled'],
					type = 'toggle',
					order = 1,
					get = function(info)
						return module.CurrentSettings[frameName].elements[key].enabled
					end,
					set = function(info, val)
						--Update memory
						module.CurrentSettings[frameName].elements[key].enabled = val
						--Update the DB
						SUI.DB.Unitframes.PlayerCustomizations[SUI.DB.Unitframes.Style][frameName].elements[key].enabled = val
						--Update the screen
						if val then
							module.frames[frameName][key]:Show()
						else
							module.frames[frameName][key]:Hide()
						end
					end
				},
				Text = {
					name = '',
					type = 'group',
					inline = true,
					order = 10,
					args = {
						text = {
							name = 'Text',
							type = 'input',
							width = 'full',
							order = 1,
							get = function(info)
								return module.CurrentSettings[frameName].elements[key].text
							end,
							set = function(info, val)
								--Update memory
								module.CurrentSettings[frameName].elements[key].text = val
								--Update the DB
								SUI.DB.Unitframes.PlayerCustomizations[SUI.DB.Unitframes.Style][frameName].elements[key].text = val
								--Update the screen
								module.frames[frameName]:Tag(module.frames[frameName][key], val)
								module.frames[frameName]:UpdateTags()
							end
						},
						size = {
							name = 'Size',
							type = 'range',
							width = 'full',
							min = 1,
							max = 30,
							step = 1,
							order = 1.5,
							get = function(info)
								return module.CurrentSettings[frameName].elements[key].size
							end,
							set = function(info, val)
								--Update memory
								module.CurrentSettings[frameName].elements[key].size = val
								--Update the DB
								SUI.DB.Unitframes.PlayerCustomizations[SUI.DB.Unitframes.Style][frameName].elements[key].size = val
								--Update the screen
								SUI:UpdateDefaultSize(module.frames[frameName][key], val, 'UnitFrames')
							end
						},
						JustifyH = {
							name = 'Horizontal alignment',
							type = 'select',
							order = 2,
							values = {
								['LEFT'] = 'Left',
								['CENTER'] = 'Center',
								['RIGHT'] = 'Right'
							},
							get = function(info)
								return module.CurrentSettings[frameName].elements[key].SetJustifyH
							end,
							set = function(info, val)
								--Update memory
								module.CurrentSettings[frameName].elements[key].SetJustifyH = val
								--Update the DB
								SUI.DB.Unitframes.PlayerCustomizations[SUI.DB.Unitframes.Style][frameName].elements[key].SetJustifyH = val
								--Update the screen
								module.frames[frameName][key]:SetJustifyH(val)
							end
						},
						JustifyV = {
							name = 'Vertical alignment',
							type = 'select',
							order = 3,
							values = {
								['TOP'] = 'Top',
								['MIDDLE'] = 'Middle',
								['BOTTOM'] = 'Bottom'
							},
							get = function(info)
								return module.CurrentSettings[frameName].elements[key].SetJustifyV
							end,
							set = function(info, val)
								--Update memory
								module.CurrentSettings[frameName].elements[key].SetJustifyV = val
								--Update the DB
								SUI.DB.Unitframes.PlayerCustomizations[SUI.DB.Unitframes.Style][frameName].elements[key].SetJustifyV = val
								--Update the screen
								module.frames[frameName][key]:SetJustifyV(val)
							end
						}
					}
				},
				position = {
					name = 'Position',
					type = 'group',
					order = 50,
					inline = true,
					args = {
						x = {
							name = 'X Axis',
							type = 'range',
							order = 1,
							min = -100,
							max = 100,
							step = 1,
							get = function(info)
								return module.CurrentSettings[frameName].elements[key].position.x
							end,
							set = function(info, val)
								--Update memory
								module.CurrentSettings[frameName].elements[key].position.x = val
								--Update the DB
								SUI.DB.Unitframes.PlayerCustomizations[SUI.DB.Unitframes.Style][frameName].elements[key].position.x = val
								--Update the screen
								module.frames[frameName]:ElementUpdate(key)
							end
						},
						y = {
							name = 'Y Axis',
							type = 'range',
							order = 2,
							min = -100,
							max = 100,
							step = 1,
							get = function(info)
								return module.CurrentSettings[frameName].elements[key].position.y
							end,
							set = function(info, val)
								--Update memory
								module.CurrentSettings[frameName].elements[key].position.y = val
								--Update the DB
								SUI.DB.Unitframes.PlayerCustomizations[SUI.DB.Unitframes.Style][frameName].elements[key].position.y = val
								--Update the screen
								module.frames[frameName]:ElementUpdate(key)
							end
						},
						anchor = {
							name = 'Anchor point',
							type = 'select',
							order = 3,
							values = anchorPoints,
							get = function(info)
								return module.CurrentSettings[frameName].elements[key].position.anchor
							end,
							set = function(info, val)
								--Update memory
								module.CurrentSettings[frameName].elements[key].position.anchor = val
								--Update the DB
								SUI.DB.Unitframes.PlayerCustomizations[SUI.DB.Unitframes.Style][frameName].elements[key].position.anchor = val
								--Update the screen
								module.frames[frameName]:ElementUpdate(key)
							end
						}
					}
				}
			}
		}
	end
end

local function AddBuffOptions(frameName)
	SUI.opt.args.UnitFrames.args[frameName].args['auras'] = {
		name = 'Buffs & Debuffs',
		desc = 'Buff & Debuff display settings',
		type = 'group',
		childGroups = 'tree',
		order = 100,
		args = {}
	}

	local function SetOption(val, buffType, setting)
		--Update memory
		module.CurrentSettings[frameName].auras[buffType][setting] = val
		--Update the DB
		SUI.DB.Unitframes.PlayerCustomizations[SUI.DB.Unitframes.Style][frameName].auras[buffType][setting] = val
		--Update the screen
		module.frames[frameName]:UpdateAuras()
	end

	for _, buffType in pairs({'Buffs', 'Debuffs'}) do
		SUI.opt.args.UnitFrames.args[frameName].args.auras.args[buffType] = {
			name = L[buffType],
			type = 'group',
			inline = true,
			order = 1,
			args = {
				enabled = {
					name = L['Enabled'],
					type = 'toggle',
					order = 1,
					get = function(info)
						return module.CurrentSettings[frameName].auras[buffType].enabled
					end,
					set = function(info, val)
						SetOption(val, buffType, 'enabled')
					end
				},
				Number = {
					name = L['Number to show'],
					type = 'range',
					order = 20,
					min = 1,
					max = 30,
					step = 1,
					get = function(info)
						return module.CurrentSettings[frameName].auras[buffType].Number
					end,
					set = function(info, val)
						SetOption(val, buffType, 'Number')
					end
				},
				size = {
					name = L['Size'],
					type = 'range',
					order = 30,
					min = 1,
					max = 30,
					step = 1,
					get = function(info)
						return module.CurrentSettings[frameName].auras[buffType].size
					end,
					set = function(info, val)
						--Update memory
						module.CurrentSettings[frameName].auras[buffType].size = val
						--Update the DB
						SUI.DB.Unitframes.PlayerCustomizations[SUI.DB.Unitframes.Style][frameName].auras[buffType].size = val
						--Update the screen
						PlayerFrames[unit]:UpdateAuras()
					end
				},
				spacing = {
					name = L['Spacing'],
					type = 'range',
					order = 40,
					min = 1,
					max = 30,
					step = 1,
					get = function(info)
						return module.CurrentSettings[frameName].auras[buffType].spacing
					end,
					set = function(info, val)
						SetOption(val, buffType, 'spacing')
					end
				},
				showType = {
					name = L['Show type'],
					type = 'toggle',
					order = 50,
					get = function(info)
						return module.CurrentSettings[frameName].auras[buffType].showType
					end,
					set = function(info, val)
						SetOption(val, buffType, 'showType')
					end
				},
				onlyShowPlayer = {
					name = L['Only show players'],
					type = 'toggle',
					order = 60,
					get = function(info)
						return module.CurrentSettings[frameName].auras[buffType].onlyShowPlayer
					end,
					set = function(info, val)
						SetOption(val, buffType, 'onlyShowPlayer')
					end
				},
				initialAnchor = {
					name = 'Buff anchor point',
					type = 'select',
					values = limitedAnchorPoints,
					get = function(info)
						return module.CurrentSettings[frameName].auras[buffType].initialAnchor
					end,
					set = function(info, val)
						SetOption(val, buffType, 'initialAnchor')
					end
				},
				growthx = {
					name = 'Growth x',
					type = 'select',
					values = {
						['RIGHT'] = 'RIGHT',
						['LEFT'] = 'LEFT'
					},
					get = function(info)
						return module.CurrentSettings[frameName].auras[buffType].growthx
					end,
					set = function(info, val)
						SetOption(val, buffType, 'growthx')
					end
				},
				growthy = {
					name = 'Growth y',
					type = 'select',
					values = {
						['UP'] = 'UP',
						['DOWN'] = 'DOWN'
					},
					get = function(info)
						return module.CurrentSettings[frameName].auras[buffType].growthy
					end,
					set = function(info, val)
						SetOption(val, buffType, 'growthy')
					end
				},
				rows = {
					name = 'Rows',
					type = 'range',
					order = 30,
					min = 1,
					max = 30,
					step = 1,
					get = function(info)
						return module.CurrentSettings[frameName].auras[buffType].rows
					end,
					set = function(info, val)
						SetOption(val, buffType, 'rows')
					end
				},
				position = {
					name = 'Position',
					type = 'group',
					order = 50,
					inline = true,
					args = {
						x = {
							name = 'X Axis',
							type = 'range',
							order = 1,
							min = -100,
							max = 100,
							step = 1,
							get = function(info)
								return module.CurrentSettings[frameName].auras[buffType].position.x
							end,
							set = function(info, val)
								--Update memory
								module.CurrentSettings[frameName].auras[buffType].position.x = val
								--Update the DB
								SUI.DB.Unitframes.PlayerCustomizations[SUI.DB.Unitframes.Style][frameName].auras[buffType].position.x = val
								--Update Screen
								module.frames[frameName]:UpdateAuras()
							end
						},
						y = {
							name = 'Y Axis',
							type = 'range',
							order = 2,
							min = -100,
							max = 100,
							step = 1,
							get = function(info)
								return module.CurrentSettings[frameName].auras[buffType].position.y
							end,
							set = function(info, val)
								--Update memory
								module.CurrentSettings[frameName].auras[buffType].position.y = val
								--Update the DB
								SUI.DB.Unitframes.PlayerCustomizations[SUI.DB.Unitframes.Style][frameName].auras[buffType].position.y = val
								--Update Screen
								module.frames[frameName]:UpdateAuras()
							end
						},
						anchor = {
							name = 'Anchor point',
							type = 'select',
							order = 3,
							values = anchorPoints,
							get = function(info)
								return module.CurrentSettings[frameName].auras[buffType].position.anchor
							end,
							set = function(info, val)
								--Update memory
								module.CurrentSettings[frameName].auras[buffType].position.anchor = val
								--Update the DB
								SUI.DB.Unitframes.PlayerCustomizations[SUI.DB.Unitframes.Style][frameName].auras[buffType].position.anchor = val
								--Update Screen
								module.frames[frameName]:UpdateAuras()
							end
						}
					}
				}
			}
		}
	end
end

local function AddGroupOptions(frameName)
	SUI.opt.args.UnitFrames.args[frameName].args['general'].args['Display'] = {
		name = 'Display',
		type = 'group',
		order = 5,
		inline = true,
		args = {
			toggleraid = {
				name = L['ShowRFrames'],
				type = 'toggle',
				order = 1,
				get = function(info)
					return module.CurrentSettings[frameName].showRaid
				end,
				set = function(info, val)
					module.CurrentSettings[frameName].showRaid = val
				end
			},
			toggleparty = {
				name = L['PartyDispParty'],
				type = 'toggle',
				order = 2,
				get = function(info)
					return module.CurrentSettings[frameName].showParty
				end,
				set = function(info, val)
					module.CurrentSettings[frameName].showParty = val
				end
			},
			togglesolo = {
				name = L['PartyDispSolo'],
				type = 'toggle',
				order = 4,
				get = function(info)
					return module.CurrentSettings[frameName].showSolo
				end,
				set = function(info, val)
					module.CurrentSettings[frameName].showSolo = val
				end
			},
			mode = {
				name = 'Sort order',
				type = 'select',
				order = 3,
				values = {['GROUP'] = 'Groups', ['NAME'] = 'Name', ['ASSIGNEDROLE'] = 'Roles'},
				get = function(info)
					return module.CurrentSettings[frameName].mode
				end,
				set = function(info, val)
					module.CurrentSettings[frameName].mode = val
				end
			},
			bar1 = {name = L['LayoutConf'], type = 'header', order = 20},
			maxColumns = {
				name = L['MaxCols'],
				type = 'range',
				order = 21,
				width = 'full',
				step = 1,
				min = 1,
				max = 40,
				get = function(info)
					return module.CurrentSettings[frameName].maxColumns
				end,
				set = function(info, val)
					module.CurrentSettings[frameName].maxColumns = val
				end
			},
			unitsPerColumn = {
				name = L['UnitPerCol'],
				type = 'range',
				order = 22,
				width = 'full',
				step = 1,
				min = 1,
				max = 40,
				get = function(info)
					return module.CurrentSettings[frameName].unitsPerColumn
				end,
				set = function(info, val)
					module.CurrentSettings[frameName].unitsPerColumn = val
				end
			},
			columnSpacing = {
				name = L['ColSpacing'],
				type = 'range',
				order = 23,
				width = 'full',
				step = 1,
				min = 0,
				max = 200,
				get = function(info)
					return module.CurrentSettings[frameName].columnSpacing
				end,
				set = function(info, val)
					module.CurrentSettings[frameName].columnSpacing = val
				end
			}
		}
	}
end

function module:InitializeOptions()
	SUI.opt.args['UnitFrames'] = {
		name = 'Unit frames',
		type = 'group',
		args = {
			BaseStyle = {
				name = 'Base frame style',
				type = 'group',
				inline = true,
				order = 1,
				args = {
					reset = {
						name = 'Reset to base style (Revert customizations)',
						type = 'execute',
						width = 'full',
						order = 900,
						func = function()
							--Reset the DB
							SUI.DB.Unitframes.PlayerCustomizations[SUI.DB.Unitframes.Style] = nil
							-- Refresh the memory
							module:LoadDB()

							-- Update the screen
							for _, frame in pairs(module.frames) do
								-- Check that its a frame
								if frame.UpdateAll then
									frame:UpdateAll()
								end
							end
						end
					}
				}
			}
		}
	}
	local Skins = {
		'Classic',
		'War',
		'Fel',
		'Digital',
		'Arcane',
		'Transparent',
		'Minimal'
	}

	-- Build style Buttons
	for i, skin in pairs(Skins) do
		SUI.opt.args.UnitFrames.args.BaseStyle.args[skin] = {
			name = skin,
			type = 'execute',
			image = function()
				return 'interface\\addons\\SpartanUI\\images\\setup\\Style_Frames_' .. skin, 120, 60
			end,
			imageCoords = function()
				return {0, .5, 0, .5}
			end,
			func = function()
				SUI.DB.Unitframes.Style = skin
			end
		}
	end

	-- Add built skins selection page to the styles section
	SUI.opt.args.General.args.style.args.Unitframes = SUI.opt.args.UnitFrames.args.BaseStyle

	-- Build frame options
	for i, key in ipairs(frameList) do
		CreateOptionSet(key, i)
		AddGeneralOptions(key)
		AddBarOptions(key)
		AddIndicatorOptions(key)
		AddTextOptions(key)
		AddBuffOptions(key)

		if key == 'player' or key == 'target' or key == 'party' or key == 'boss' then
			AddArtworkOptions(key)
		end
	end

	AddGroupOptions('raid')
	AddGroupOptions('party')
	AddGroupOptions('boss')
	AddGroupOptions('arena')

	SUI.opt.args.UnitFrames.args.player.args.general.args.General.args.range.hidden = true
end

----------------------------------------------------------------------------------------------------

function PlayerOptions()
	SUI.opt.args['PlayerFrames'].args['frameDisplay'] = {
		name = 'Disable Frames',
		type = 'group',
		desc = 'Enable and Disable Specific frames',
		args = {
			player = {
				name = L['DispPlayer'],
				type = 'toggle',
				order = 1,
				get = function(info)
					return SUI.DBMod.PlayerFrames.player.display
				end,
				set = function(info, val)
					SUI.DBMod.PlayerFrames.player.display = val
					if SUI.DBMod.PlayerFrames.player.display then
						PlayerFrames.player:Enable()
					else
						PlayerFrames.player:Disable()
					end
				end
			},
			pet = {
				name = L['DispPet'],
				type = 'toggle',
				order = 2,
				get = function(info)
					return SUI.DBMod.PlayerFrames.pet.display
				end,
				set = function(info, val)
					SUI.DBMod.PlayerFrames.pet.display = val
					if SUI.DBMod.PlayerFrames.pet.display then
						PlayerFrames.pet:Enable()
					else
						PlayerFrames.pet:Disable()
					end
				end
			},
			target = {
				name = L['DispTarget'],
				type = 'toggle',
				order = 3,
				get = function(info)
					return SUI.DBMod.PlayerFrames.target.display
				end,
				set = function(info, val)
					SUI.DBMod.PlayerFrames.target.display = val
					if SUI.DBMod.PlayerFrames.target.display then
						PlayerFrames.target:Enable()
					else
						PlayerFrames.target:Disable()
					end
				end
			},
			targettarget = {
				name = L['DispToT'],
				type = 'toggle',
				order = 4,
				get = function(info)
					return SUI.DBMod.PlayerFrames.targettarget.display
				end,
				set = function(info, val)
					SUI.DBMod.PlayerFrames.targettarget.display = val
					if SUI.DBMod.PlayerFrames.targettarget.display then
						PlayerFrames.targettarget:Enable()
					else
						PlayerFrames.targettarget:Disable()
					end
				end
			},
			focustarget = {
				name = L['DispFocusTar'],
				type = 'toggle',
				order = 5,
				get = function(info)
					return SUI.DBMod.PlayerFrames.focustarget.display
				end,
				set = function(info, val)
					SUI.DBMod.PlayerFrames.focustarget.display = val
					if SUI.DBMod.PlayerFrames.focustarget.display then
						PlayerFrames.focustarget:Enable()
					else
						PlayerFrames.focustarget:Disable()
					end
				end
			}
		}
	}

	SUI.opt.args['PlayerFrames'].args['castbar'] = {
		name = L['castbar'],
		type = 'group',
		desc = L['UnitCastSet'],
		args = {
			player = {
				name = L['PlayerStyle'],
				type = 'select',
				style = 'radio',
				values = {[0] = L['FillLR'], [1] = L['DepRL']},
				get = function(info)
					return SUI.DBMod.PlayerFrames.Castbar.player
				end,
				set = function(info, val)
					SUI.DBMod.PlayerFrames.Castbar.player = val
				end
			},
			target = {
				name = L['TargetStyle'],
				type = 'select',
				style = 'radio',
				values = {[0] = L['FillLR'], [1] = L['DepRL']},
				get = function(info)
					return SUI.DBMod.PlayerFrames.Castbar.target
				end,
				set = function(info, val)
					SUI.DBMod.PlayerFrames.Castbar.target = val
				end
			},
			targettarget = {
				name = L['ToTStyle'],
				type = 'select',
				style = 'radio',
				values = {[0] = L['FillLR'], [1] = L['DepRL']},
				get = function(info)
					return SUI.DBMod.PlayerFrames.Castbar.targettarget
				end,
				set = function(info, val)
					SUI.DBMod.PlayerFrames.Castbar.targettarget = val
				end
			},
			pet = {
				name = L['PetStyle'],
				type = 'select',
				style = 'radio',
				values = {[0] = L['FillLR'], [1] = L['DepRL']},
				get = function(info)
					return SUI.DBMod.PlayerFrames.Castbar.pet
				end,
				set = function(info, val)
					SUI.DBMod.PlayerFrames.Castbar.pet = val
				end
			},
			focus = {
				name = L['FocusStyle'],
				type = 'select',
				style = 'radio',
				values = {[0] = L['FillLR'], [1] = L['DepRL']},
				get = function(info)
					return SUI.DBMod.PlayerFrames.Castbar.focus
				end,
				set = function(info, val)
					SUI.DBMod.PlayerFrames.Castbar.focus = val
				end
			},
			text = {
				name = L['CastText'],
				desc = L['CastTextDesc'],
				type = 'group',
				args = {
					player = {
						name = L['TextStyle'],
						type = 'select',
						style = 'radio',
						values = {[0] = L['CountUp'], [1] = L['CountDown']},
						get = function(info)
							return SUI.DBMod.PlayerFrames.Castbar.text.player
						end,
						set = function(info, val)
							SUI.DBMod.PlayerFrames.Castbar.text.player = val
						end
					},
					target = {
						name = L['TextStyle'],
						type = 'select',
						style = 'radio',
						values = {[0] = L['CountUp'], [1] = L['CountDown']},
						get = function(info)
							return SUI.DBMod.PlayerFrames.Castbar.text.target
						end,
						set = function(info, val)
							SUI.DBMod.PlayerFrames.Castbar.text.target = val
						end
					},
					targettarget = {
						name = L['TextStyle'],
						type = 'select',
						style = 'radio',
						values = {[0] = L['CountUp'], [1] = L['CountDown']},
						get = function(info)
							return SUI.DBMod.PlayerFrames.Castbar.text.targettarget
						end,
						set = function(info, val)
							SUI.DBMod.PlayerFrames.Castbar.text.targettarget = val
						end
					},
					pet = {
						name = L['TextStyle'],
						type = 'select',
						style = 'radio',
						values = {[0] = L['CountUp'], [1] = L['CountDown']},
						get = function(info)
							return SUI.DBMod.PlayerFrames.Castbar.text.pet
						end,
						set = function(info, val)
							SUI.DBMod.PlayerFrames.Castbar.text.pet = val
						end
					},
					focus = {
						name = L['TextStyle'],
						type = 'select',
						style = 'radio',
						values = {[0] = L['CountUp'], [1] = L['CountDown']},
						get = function(info)
							return SUI.DBMod.PlayerFrames.Castbar.text.focus
						end,
						set = function(info, val)
							SUI.DBMod.PlayerFrames.Castbar.text.focus = val
						end
					}
				}
			}
		}
	}
	SUI.opt.args['PlayerFrames'].args['bossarena'] = {
		name = L['BossArenaFrames'],
		type = 'group',
		args = {
			bar0 = {name = L['BossFrames'], type = 'header', order = 0},
			boss = {
				name = L['ShowFrames'],
				type = 'toggle',
				order = 1,
				--disabled=true,
				get = function(info)
					return SUI.DBMod.PlayerFrames.BossFrame.display
				end,
				set = function(info, val)
					SUI.DBMod.PlayerFrames.BossFrame.display = val
				end
			},
			bossscale = {
				name = L['ScaleFrames'],
				type = 'range',
				order = 3,
				width = 'full',
				--disabled=true,
				min = .01,
				max = 2,
				step = .01,
				get = function(info)
					return SUI.DBMod.PlayerFrames.BossFrame.scale
				end,
				set = function(info, val)
					SUI.DBMod.PlayerFrames.BossFrame.scale = val
				end
			},
			bar2 = {name = L['ArenaFrames'], type = 'header', order = 20},
			arena = {
				name = L['ShowFrames'],
				type = 'toggle',
				order = 21,
				get = function(info)
					return SUI.DBMod.PlayerFrames.ArenaFrame.display
				end,
				set = function(info, val)
					SUI.DBMod.PlayerFrames.ArenaFrame.display = val
				end
			},
			arenascale = {
				name = L['ScaleFrames'],
				type = 'range',
				order = 23,
				width = 'full',
				min = .01,
				max = 2,
				step = .01,
				get = function(info)
					return SUI.DBMod.PlayerFrames.ArenaFrame.scale
				end,
				set = function(info, val)
					SUI.DBMod.PlayerFrames.ArenaFrame.scale = val
				end
			}
		}
	}
end

----------------------------------------------------------------------------------------------------

function RaidOptions()
	SUI.opt.args['RaidFrames'].args['DisplayOpts'] = {
		name = L['DisplayOpts'],
		type = 'group',
		order = 100,
		inline = true,
		args = {
			toggleraid = {
				name = L['ShowRFrames'],
				type = 'toggle',
				order = 1,
				get = function(info)
					return SUI.DBMod.RaidFrames.showRaid
				end,
				set = function(info, val)
					SUI.DBMod.RaidFrames.showRaid = val
					RaidFrames:UpdateRaid('FORCE_UPDATE')
				end
			},
			toggleparty = {
				name = L['PartyDispParty'],
				type = 'toggle',
				order = 2,
				get = function(info)
					return SUI.DBMod.RaidFrames.showParty
				end,
				set = function(info, val)
					SUI.DBMod.RaidFrames.showParty = val
					RaidFrames:UpdateRaid('FORCE_UPDATE')
				end
			},
			togglesolo = {
				name = L['PartyDispSolo'],
				type = 'toggle',
				order = 4,
				get = function(info)
					return SUI.DBMod.RaidFrames.showSolo
				end,
				set = function(info, val)
					SUI.DBMod.RaidFrames.showSolo = val
					RaidFrames:UpdateRaid('FORCE_UPDATE')
				end
			},
			toggleclassname = {
				name = L['ClrNameClass'],
				type = 'toggle',
				order = 1,
				get = function(info)
					return SUI.DBMod.RaidFrames.showClass
				end,
				set = function(info, val)
					SUI.DBMod.RaidFrames.showClass = val
					RaidFrames:UpdateRaid('FORCE_UPDATE')
				end
			},
			scale = {
				name = L['ScaleSize'],
				type = 'range',
				order = 5,
				width = 'full',
				step = .01,
				min = .01,
				max = 2,
				get = function(info)
					return SUI.DBMod.RaidFrames.scale
				end,
				set = function(info, val)
					if (InCombatLockdown()) then
						SUI:Print(ERR_NOT_IN_COMBAT)
					else
						SUI.DBMod.RaidFrames.scale = val
						RaidFrames:UpdateRaid('FORCE_UPDATE')
					end
				end
			},
			bar1 = {name = L['LayoutConf'], type = 'header', order = 20},
			maxColumns = {
				name = L['MaxCols'],
				type = 'range',
				order = 21,
				width = 'full',
				step = 1,
				min = 1,
				max = 40,
				get = function(info)
					return SUI.DBMod.RaidFrames.maxColumns
				end,
				set = function(info, val)
					if (InCombatLockdown()) then
						SUI:Print(ERR_NOT_IN_COMBAT)
					else
						SUI.DBMod.RaidFrames.maxColumns = val
						RaidFrames:UpdateRaid('FORCE_UPDATE')
					end
				end
			},
			unitsPerColumn = {
				name = L['UnitPerCol'],
				type = 'range',
				order = 22,
				width = 'full',
				step = 1,
				min = 1,
				max = 40,
				get = function(info)
					return SUI.DBMod.RaidFrames.unitsPerColumn
				end,
				set = function(info, val)
					if (InCombatLockdown()) then
						SUI:Print(ERR_NOT_IN_COMBAT)
					else
						SUI.DBMod.RaidFrames.unitsPerColumn = val
						RaidFrames:UpdateRaid('FORCE_UPDATE')
					end
				end
			},
			columnSpacing = {
				name = L['ColSpacing'],
				type = 'range',
				order = 23,
				width = 'full',
				step = 1,
				min = 0,
				max = 200,
				get = function(info)
					return SUI.DBMod.RaidFrames.columnSpacing
				end,
				set = function(info, val)
					if (InCombatLockdown()) then
						SUI:Print(ERR_NOT_IN_COMBAT)
					else
						SUI.DBMod.RaidFrames.columnSpacing = val
						RaidFrames:UpdateRaid('FORCE_UPDATE')
					end
				end
			},
			desc1 = {name = L['LayoutConfDesc'], type = 'description', order = 29.9},
			bar3 = {name = L['TextStyle'], type = 'header', order = 30},
			healthtextstyle = {
				name = L['HTextStyle'],
				type = 'select',
				order = 31,
				desc = L['TextStyle1Desc'] .. '|n' .. L['TextStyle2Desc'] .. '|n' .. L['TextStyle3Desc'],
				values = {
					['long'] = L['TextStyle1'],
					['longfor'] = L['TextStyle2'],
					['dynamic'] = L['TextStyle3'],
					['disabled'] = L['Disabled']
				},
				get = function(info)
					return SUI.DBMod.RaidFrames.bars.health.textstyle
				end,
				set = function(info, val)
					SUI.DBMod.RaidFrames.bars.health.textstyle = val
					RaidFrames:UpdateText()
				end
			},
			healthtextmode = {
				name = L['HTextMode'],
				type = 'select',
				order = 32,
				values = {[1] = L['HTextMode1'], [2] = L['HTextMode2'], [3] = L['HTextMode3']},
				get = function(info)
					return SUI.DBMod.RaidFrames.bars.health.textmode
				end,
				set = function(info, val)
					SUI.DBMod.RaidFrames.bars.health.textmode = val
					RaidFrames:UpdateText()
				end
			}
		}
	}

	SUI.opt.args['RaidFrames'].args['mode'] = {
		name = L['LayMode'],
		type = 'select',
		order = 3,
		values = {['NAME'] = L['LayName'], ['GROUP'] = L['LayGrp'], ['ASSIGNEDROLE'] = L['LayRole']},
		get = function(info)
			return SUI.DBMod.RaidFrames.mode
		end,
		set = function(info, val)
			SUI.DBMod.RaidFrames.mode = val
			RaidFrames:UpdateRaid('FORCE_UPDATE')
		end
	}
	SUI.opt.args['RaidFrames'].args['raidLockReset'] = {
		name = L['ResetRaidPos'],
		type = 'execute',
		order = 11,
		func = function()
			if (InCombatLockdown()) then
				SUI:Print(ERR_NOT_IN_COMBAT)
			else
				SUI.DBMod.RaidFrames.moved = false
				RaidFrames:UpdateRaidPosition()
			end
		end
	}
	SUI.opt.args['RaidFrames'].args['HideBlizz'] = {
		name = L['HideBlizzFrames'],
		type = 'toggle',
		order = 4,
		get = function(info)
			return SUI.DBMod.RaidFrames.HideBlizzFrames
		end,
		set = function(info, val)
			SUI.DBMod.RaidFrames.HideBlizzFrames = val
		end
	}
end

----------------------------------------------------------------------------------------------------

function module:UpdateText()
	for i = 1, 5 do
		if _G['SUI_PartyFrameHeaderUnitButton' .. i] then
			local unit = _G['SUI_PartyFrameHeaderUnitButton' .. i]
			if unit then
				unit:TextUpdate()
			end
		end
	end
end

function PartyOptions()
	SUI.opt.args['PartyFrames'].args['DisplayOpts'] = {
		name = L['DisplayOpts'],
		type = 'group',
		order = 100,
		inline = true,
		desc = L['DisplayOptsPartyDesc'],
		args = {
			bar1 = {name = L['WhenDisplayParty'], type = 'header', order = 0},
			toggleraid = {
				name = L['PartyDispRaid'],
				type = 'toggle',
				order = 1,
				get = function(info)
					return SUI.DBMod.PartyFrames.showPartyInRaid
				end,
				set = function(info, val)
					SUI.DBMod.PartyFrames.showPartyInRaid = val
					PartyFrames:UpdateParty('FORCE_UPDATE')
				end
			},
			toggleparty = {
				name = L['PartyDispParty'],
				type = 'toggle',
				order = 2,
				get = function(info)
					return SUI.DBMod.PartyFrames.showParty
				end,
				set = function(info, val)
					SUI.DBMod.PartyFrames.showParty = val
					PartyFrames:UpdateParty('FORCE_UPDATE')
				end
			},
			toggleplayer = {
				name = L['PartyDispSelf'],
				type = 'toggle',
				order = 3,
				get = function(info)
					return SUI.DBMod.PartyFrames.showPlayer
				end,
				set = function(info, val)
					SUI.DBMod.PartyFrames.showPlayer = val
					PartyFrames:UpdateParty('FORCE_UPDATE')
				end
			},
			togglesolo = {
				name = L['PartyDispSolo'],
				type = 'toggle',
				order = 4,
				get = function(info)
					return SUI.DBMod.PartyFrames.showSolo
				end,
				set = function(info, val)
					SUI.DBMod.PartyFrames.showSolo = val
					PartyFrames:UpdateParty('FORCE_UPDATE')
				end
			},
			bar2 = {name = L['SubFrameDisp'], type = 'header', order = 10},
			DisplayPet = {
				name = L['DispPet'],
				type = 'toggle',
				order = 11,
				get = function(info)
					return SUI.DBMod.PartyFrames.display.pet
				end,
				set = function(info, val)
					SUI.DBMod.PartyFrames.display.pet = val
				end
			},
			DisplayTarget = {
				name = L['DispTarget'],
				type = 'toggle',
				order = 12,
				get = function(info)
					return SUI.DBMod.PartyFrames.display.target
				end,
				set = function(info, val)
					SUI.DBMod.PartyFrames.display.target = val
				end
			},
			bar3 = {name = L['TextStyle'], type = 'header', order = 20},
			healthtextstyle = {
				name = L['HTextStyle'],
				type = 'select',
				order = 21,
				desc = L['TextStyle1Desc'] .. '|n' .. L['TextStyle2Desc'] .. '|n' .. L['TextStyle3Desc'],
				values = {
					['Long'] = L['TextStyle1'],
					['longfor'] = L['TextStyle2'],
					['dynamic'] = L['TextStyle3'],
					['disabled'] = L['Disabled']
				},
				get = function(info)
					return SUI.DBMod.PartyFrames.bars.health.textstyle
				end,
				set = function(info, val)
					SUI.DBMod.PartyFrames.bars.health.textstyle = val
					module:UpdateText()
				end
			},
			healthtextmode = {
				name = L['HTextMode'],
				type = 'select',
				order = 22,
				values = {[1] = L['HTextMode1'], [2] = L['HTextMode2'], [3] = L['HTextMode3']},
				get = function(info)
					return SUI.DBMod.PartyFrames.bars.health.textmode
				end,
				set = function(info, val)
					SUI.DBMod.PartyFrames.bars.health.textmode = val
					module:UpdateText()
				end
			},
			manatextstyle = {
				name = L['MTextStyle'],
				type = 'select',
				order = 23,
				desc = L['TextStyle1Desc'] .. '|n' .. L['TextStyle2Desc'] .. '|n' .. L['TextStyle3Desc'],
				values = {
					['Long'] = L['TextStyle1'],
					['longfor'] = L['TextStyle2'],
					['dynamic'] = L['TextStyle3'],
					['disabled'] = L['Disabled']
				},
				get = function(info)
					return SUI.DBMod.PartyFrames.bars.mana.textstyle
				end,
				set = function(info, val)
					SUI.DBMod.PartyFrames.bars.mana.textstyle = val
					module:UpdateText()
				end
			},
			manatextmode = {
				name = L['MTextMode'],
				type = 'select',
				order = 24,
				values = {[1] = L['HTextMode1'], [2] = L['HTextMode2'], [3] = L['HTextMode3']},
				get = function(info)
					return SUI.DBMod.PartyFrames.bars.mana.textmode
				end,
				set = function(info, val)
					SUI.DBMod.PartyFrames.bars.mana.textmode = val
					module:UpdateText()
				end
			},
			toggleclasscolorname = {
				name = L['ClrNameClass'],
				type = 'toggle',
				order = 25,
				get = function(info)
					return SUI.DBMod.PartyFrames.showClass
				end,
				set = function(info, val)
					SUI.DBMod.PartyFrames.showClass = val
					PartyFrames:UpdateParty('FORCE_UPDATE')
				end
			}
		}
	}
	SUI.opt.args['PartyFrames'].args['partyReset'] = {
		name = L['ResetPartyPos'],
		type = 'execute',
		order = 5,
		func = function()
			-- if (InCombatLockdown()) then
			-- SUI:Print(ERR_NOT_IN_COMBAT);
			-- else
			SUI.DBMod.PartyFrames.moved = false
			PartyFrames:UpdatePartyPosition()
			-- end
		end
	}
end
