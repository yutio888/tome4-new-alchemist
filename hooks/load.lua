local class = require"engine.class"
local Birther = require "engine.Birther"
local ActorTalents = require "engine.interface.ActorTalents"
class:bindHook("ToME:load", function()
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