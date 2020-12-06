local _M = loadPrevious(...)
local DamageType = require("engine.DamageType")
function _M:combatTalentSpellDamageBase(t, base, max, spellpower_override)
	-- Compute at "max"
	local mod = max / ((base + 100) * ((math.sqrt(5) - 1) * 0.8 + 1))
	-- Compute real
	return (base + (spellpower_override or self:combatSpellpower())) * ((math.sqrt(self:getTalentLevel(t)) - 1) * 0.8 + 1) * mod
end

function _M:combatTalentGemDamage(t, base, max)
    local gem = self:hasAlchemistWeapon()
    if not gem then return 0 end
    local mod = ((math.sqrt(self:getTalentLevel(t)) - 1) * 0.8 + 1) / ((math.sqrt(5) - 1) * 0.8 + 1)
    return ((max - base) * (gem.material_level - 1) / 4 + base) * mod
end

function _M:combatTalentGemPower(t)
    local gem = self:hasAlchemistWeapon()
    if not gem then return 1 end
    return gem.material_level * 20
end

function _M:getGemDamageType()
    local gem = self:hasAlchemistWeapon()
    if not gem or not gem.color_attributes then return DamageType.PHYSICAL end
    return gem.color_attributes.damage_type or DamageType.PHYSICAL
end

function _M:triggerGemEffect(target, gem, dam)
    if gem.alchemist_bomb and gem.alchemist_bomb.splash then
        local gdam = gem.alchemist_bomb.splash.dam
        if type(gdam) == "number" then
            gdam = dam * gdam / 100
        end
	    DamageType:get(DamageType[gem.alchemist_bomb.splash.type]).projector(self, target.x, target.y, DamageType[gem.alchemist_bomb.splash.type], gdam)
    end
    if gem.alchemist_bomb and gem.alchemist_bomb.stun and rng.percent(gem.alchemist_bomb.stun.chance) and target:canBe("stun") then
        target:setEffect(target.EFF_STUNNED, gem.alchemist_bomb.stun.dur, {apply_power=self:combatSpellpower()})
    end
    if gem.alchemist_bomb and gem.alchemist_bomb.daze and rng.percent(gem.alchemist_bomb.daze.chance) and target:canBe("stun") then
        game:onTickEnd(function() target:setEffect(target.EFF_DAZED, gem.alchemist_bomb.daze.dur, {apply_power=self:combatSpellpower()}) end)
    end
    if gem.alchemist_bomb and gem.alchemist_bomb.leech then
        local nb = self.turn_procs.alchemist_bomb_leech or 0
        self.turn_procs.alchemist_bomb_leech = nb + 1
        self:heal(math.max(dam, self.max_life * gem.alchemist_bomb.leech) / (100 * (nb + 1)), gem)
    end
    if gem.alchemist_bomb and gem.alchemist_bomb.mana then self:incMana(gem.alchemist_bomb.mana) end
    if gem.alchemist_bomb and gem.alchemist_bomb.special then gem.alchemist_bomb.special(self, gem, target, dam) end
    
    return dam
end

function _M:checkCanWearGem()
    local tl = {self.T_THROW_BOMB_NEW, self.T_REFIT_GOLEM_NEW, self.T_GEM_BLAST, self.T_GEM_S_RADIENCE, self.T_FLICKERING_GEM, self.T_ONE_WITH_GEM, self.T_GEM_PORTAL}
    for i= 1, #tl do
        if self:knowTalent(tl[i]) then
            if not self:attr("gem related talents") then self:attr("gem related talents", 1) return end
            return
        end
    end
    if self:attr("gem related talents") then self:attr("gem related talents", -1)
    end
end

return _M