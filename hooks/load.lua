local class = require"engine.class"
local Birther = require "engine.Birther"
local ActorTalents = require "engine.interface.ActorTalents"
local ActorTemporaryEffects = require "engine.interface.ActorTemporaryEffects"
local Entity = require "engine.Entity"
class:bindHook("ToME:load", function()
    ActorTemporaryEffects:loadDefinition("/data-new-alchemist/timed_effects.lua")
    ActorTalents:loadDefinition("/data-new-alchemist/talents.lua")
    Birther:loadDefinition("/data-new-alchemist/birth/mage.lua")
end)

class:bindHook("Actor:startTalentCooldown", function(self, data)
	local t = data.t
	if t.id == self.T_THROW_BOMB_NEW and self:knowTalent(self.T_CHAIN_BLASTING) then
	    local chance = self:callTalent(self.T_CHAIN_BLASTING, "getChance")
	    if rng.percent(chance) then
	        data.cd = 0
	        return true
	    end
	end
end)

class:bindHook("UISet:Minimalist:Resources", function(self, data)
	local player = data.player
	local potions = player.alchemy_potions
	if not potions then return data end

	local x = data.x
	local y = data.y
	local width, height = 64, 64
	local showed
	for tid, info in pairs(potions) do
		if player:knowTalent(tid) then
			local talent = player:getTalentFromId(tid)
			local nb = info.nb or 0
			while nb > 0 do
				showed = true
				local image = Entity.new { image = talent.icon }
				image:toScreen(nil, x, y, width, height)
				x = x + 32
				nb = nb - 1
			end
		end
	end
	if showed then
		data.y = y + height + 5
	end
	return data
end)

class:bindHook("UISet:Classic:Resources", function(self, data)
	local player = data.player
	local potions = player.alchemy_potions
	if not potions then return data end

	local x = data.x
	local h = data.h
	local showed
	for tid, info in pairs(potions) do
		if player:knowTalent(tid) then
			local talent = player:getTalentFromId(tid)
			local nb = info.nb or 0
			while nb > 0 do
				showed = true
				self:mouseTooltip("This are your prepared alchemy potions",
						self:makeTexture(("#ANTIQUE_WHITE#%s    :       #ffffff#%d"):tformat(talent.name, nb),
								0, h, 255, 255, 255))
				h = h + self.font_h
				nb = nb - 1
			end
		end
	end
	if showed then
		data.h = h
	end
	return data
end)