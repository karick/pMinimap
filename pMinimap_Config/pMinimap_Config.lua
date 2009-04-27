local LSM = LibStub('LibSharedMedia-3.0')local list = LSM:List('font')local function AddToFontStrings()	MiniMapMailText:SetFont(LSM:Fetch('font', pMinimapDB.smfont), pMinimapDB.fontsize, pMinimapDB.fontflag)	MinimapZoneText:SetFont(LSM:Fetch('font', pMinimapDB.smfont), pMinimapDB.fontsize, pMinimapDB.fontflag)	if(pMinimapDB.clock) then		TimeManagerClockTicker:SetFont(LSM:Fetch('font', pMinimapDB.smfont), pMinimapDB.fontsize, pMinimapDB.fontflag)	end	if(pMinimapDB.coords) then		pMinimap.Coord.Text:SetFont(LSM:Fetch('font', pMinimapDB.smfont), pMinimapDB.fontsize, pMinimapDB.fontflag)	endendLibStub('AceConfigDialog-3.0'):AddToBlizOptions('pMinimap', 'pMinimap')LibStub('AceConfig-3.0'):RegisterOptionsTable('pMinimap', {	name = 'pMinimap Options',	type = 'group',	args = {		mapheader = {			name = "Minimap options",			type = "header",			order = 0,		},		scale = {			type = 'range',			order = 1,			name = 'Minimap Scale',			min = 0.50,			max = 2.50,			step = 0.01,			get = function() return pMinimapDB.scale end,			set = function(_, value)				pMinimapDB.scale = value				Minimap:SetScale(value)			end,		},		lock = {			type = 'toggle',			order = 2,			name = 'Unlocked',			get = function() return pMinimapDB.unlocked end,			set = function()				pMinimapDB.unlocked = not pMinimapDB.unlocked				if(pMinimapDB.unlocked) then					Minimap:SetBackdropColor(0, 1, 0, 0.5)				else					Minimap:SetBackdropColor(unpack(pMinimapDB.colors))				end			end		},		level = {			type = 'range',			order = 3,			name = 'Frame level',			min = 1,			max = 15,			step = 1,			get = function() return pMinimapDB.level end,			set = function(_, value)				pMinimapDB.level = value				Minimap:SetFrameLevel(value)			end		},		strata = {			type = 'select',			order = 4,			name = 'Frame Strata',			values = {['DIALOG'] = 'DIALOG', ['HIGH'] = 'HIGH', ['MEDIUM'] = 'MEDIUM', ['LOW'] = 'LOW', ['BACKGROUND'] = 'BACKGROUND'},			get = function() return pMinimapDB.strata end,			set = function(_, strata)				pMinimapDB.strata = strata				Minimap:SetFrameStrata(strata)			end		},		mischeader = {			name = "Misc modules",			type = "header",			order = 5,		},		clock = {			type = 'toggle',			order = 6,			name = 'Clock',			get = function() return pMinimapDB.clock end,			set = function()				pMinimapDB.clock = not pMinimapDB.clock				if(pMinimapDB.clock) then					if(not pMinimap.RunClock) then						pMinimap:CreateClock()					else						TimeManagerClockButton:Show()						TimeManagerClockButton:ClearAllPoints()						TimeManagerClockButton:SetPoint(pMinimapDB.coords and 'BOTTOMLEFT' or 'BOTTOM', Minimap)					end					pMinimap.CALENDAR_UPDATE_PENDING_INVITES()				else					TimeManagerClockButton:Hide()				end				if(pMinimapDB.coords) then					pMinimap.Coord:ClearAllPoints()					pMinimap.Coord:SetPoint(pMinimapDB.clock and 'BOTTOMRIGHT' or 'BOTTOM', Minimap)				end			end		},		coords = {			type = 'toggle',			order = 7,			name = 'Coords',			get = function() return pMinimapDB.coords end,			set = function()				pMinimapDB.coords = not pMinimapDB.coords				if(pMinimapDB.coords) then					if(not pMinimap.Coord) then						pMinimap:CreateCoords()					else						pMinimap.Coord:Show()						pMinimap.Coord:ClearAllPoints()						pMinimap.Coord:SetPoint(pMinimapDB.clock and 'BOTTOMRIGHT' or 'BOTTOM', Minimap)					end				else					pMinimap.Coord:Hide()				end				if(pMinimapDB.clock) then					TimeManagerClockButton:ClearAllPoints()					TimeManagerClockButton:SetPoint(pMinimapDB.coords and 'BOTTOMLEFT' or 'BOTTOM', Minimap)				end			end		},		mail = {			type = 'toggle',			order = 8,			name = 'Mail',			get = function() return pMinimapDB.mail end,			set = function()				pMinimapDB.mail = not pMinimapDB.mail				if(pMinimapDB.mail) then					MiniMapMailIcon:Hide()					MiniMapMailText:Show()				else					MiniMapMailIcon:Show()					MiniMapMailText:Hide()				end			end		},		dura = {			type = 'toggle',			order = 9,			name = 'Durability',			get = function() return pMinimapDB.dura end,			set = function()				pMinimapDB.dura = not pMinimapDB.dura				if(pMinimapDB.dura) then					DurabilityFrame:SetAlpha(0)					pMinimap:RegisterEvent('UPDATE_INVENTORY_ALERTS')					pMinimap.UPDATE_INVENTORY_ALERTS()				else					DurabilityFrame:SetAlpha(1)					pMinimap:UnregisterEvent('UPDATE_INVENTORY_ALERTS')					Minimap:SetBackdropColor(unpack(pMinimapDB.colors))				end			end		},		bgheader = {			name = "Backdrop options",			type = "header",			order = 10,		},		bgthick = {			type = 'range',			order = 11,			name = 'Backdrop Thickness',			min = 0,			max = 10,			step = 0.5,			get = function() return pMinimapDB.offset end,			set = function(_, value)				pMinimapDB.offset = value				Minimap:SetBackdrop({bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=], insets = {top = - value, left = - value, bottom = - value, right = - value}})				Minimap:SetBackdropColor(unpack(pMinimapDB.colors))			end		},		bgcolor = {			type = 'color',			order = 12,			name = 'Backdrop Color',			hasAlpha = true,			get = function() return unpack(pMinimapDB.colors) end,			set = function(_, r, g, b, a)				pMinimapDB.colors = {r, g, b, a}				Minimap:SetBackdropColor(r, g, b, a)			end		},		zoneheader = {			name = "Zone options",			type = "header",			order = 13,		},		zoneoffset = {			type = 'range',			order = 14,			name = 'ZoneText offset',			min = -25,			max = 25,			step = 0.5,			get = function() return pMinimapDB.zoneOffset end,			set = function(_, value)				pMinimapDB.zoneOffset = value				MinimapZoneTextButton:ClearAllPoints()				MinimapZoneTextButton:SetPoint(pMinimapDB.zonePoint == 'TOP' and 'BOTTOM' or 'TOP', Minimap, pMinimapDB.zonePoint, 0, value)			end		},		zone = {			type = 'toggle',			order = 15,			name = 'ZoneText',			get = function() return pMinimapDB.zone end,			set = function()				pMinimapDB.zone = not pMinimapDB.zone				if(pMinimapDB.zone) then					MinimapZoneTextButton:Show()				else					MinimapZoneTextButton:Hide()				end			end		},		zonepoint = {			type = 'select',			order = 16,			name = 'ZoneText point',			values = {['TOP'] = 'TOP', ['BOTTOM'] = 'BOTTOM'},			get = function() return pMinimapDB.zonePoint end,			set = function(_, point)				pMinimapDB.zonePoint = point				if(point == 'TOP') then					MinimapZoneTextButton:ClearAllPoints()					MinimapZoneTextButton:SetPoint('BOTTOM', Minimap, point, 0, pMinimapDB.zoneOffset)				else					MinimapZoneTextButton:ClearAllPoints()					MinimapZoneTextButton:SetPoint('TOP', Minimap, point, 0, pMinimapDB.zoneOffset)				end			end		},		fontheader = {			name = "Font options",			type = "header",			order = 17,		},		font = {			type = 'select',			order = 18,			name = 'Font',			values = list,			get = function()				for k, v in next, list do					if(v == pMinimapDB.smfont) then						return k					end				end			end,			set = function(_, font)				pMinimapDB.smfont = list[font]				AddToFontStrings()			end		},		fontflag = {			type = 'select',			order = 19,			name = 'Font flag',			values = {['OUTLINE'] = 'OUTLINE', ['THICKOUTLINE'] = 'THICKOUTLINE', ['MONOCHROME'] = 'MONOCHROME', ['NONE'] = 'NONE'},			get = function() return pMinimapDB.fontflag end,			set = function(_, flag)				pMinimapDB.fontflag = flag				AddToFontStrings()			end		},		fontsize = {			type = 'range',			order = 20,			name = 'Font Size',			min = 5,			max = 18,			step = 1,			get = function() return pMinimapDB.fontsize end,			set = function(_, value)				pMinimapDB.fontsize = value				AddToFontStrings()			end		}	}})