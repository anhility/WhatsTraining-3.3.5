--[[	file meta info
	@file 		Cache.lua
	@brief		Cache functions to build table with data from client
--]]

--[[
	@brief		Accessing the addons private table

	@var 	_		addonName, thrown away
	@var	wt		Global addonTable
--]]
local _, wt = ...

--[[
	@brief		Tables for Spell Cache
--]]
wt.spellInfoCache = {}

-- done has param cacheHit
function wt:CacheSpell(spell, level, done)
	if (self.spellInfoCache[spell.id] ~= nil) then
		done(true)
		return
	end
	-- SpellMixing start
	--[[
	local si = Spell:CreateFromSpellID(spell.id)
	si:ContinueOnSpellLoad(function()
		if (self.spellInfoCache[spell.id] ~= nil) then
			done(true)
			return
		end
		local subText = si:GetSpellSubtext()
		local formattedSubText = (subText and subText ~= "") and
									 format(PARENS_TEMPLATE, subText) or ""
		self.spellInfoCache[spell.id] = {
			id = spell.id,
			name = si:GetSpellName(),
			subText = subText,
			formattedSubText = formattedSubText,
			icon = select(3, GetSpellInfo(spell.id)),
			cost = spell.cost,
			formattedCost = GetCoinTextureString(spell.cost),
			level = level,
			formattedLevel = format(wt.L.LEVEL_FORMAT, level)
		}
		done(false)
	end)
	--]]
	-- SpellMixing End
	if (self.spellInfoCache[spell.id] ~= nil) then
		done(true)
		return
	end
	local subText = select(2, GetSpellInfo(spell.id))
	local formattedSubText = (subText and subText ~= "") and
									 format(PARENS_TEMPLATE, subText) or ""
	self.spellInfoCache[spell.id] = {
		id = spell.id,
		name = select(1, GetSpellInfo(spell.id)),
		subText = subText,
		formattedSubText = formattedSubText,
		icon = select(3, GetSpellInfo(spell.id)),
		cost = spell.cost,
		formattedCost = GetCoinTextureString(spell.cost),
		level = level,
		formattedLevel = format(wt.L.LEVEL_FORMAT, level)
	}
	done(false)
end

function wt:SpellInfo(spellId)
	return self.spellInfoCache[spellId]
end
