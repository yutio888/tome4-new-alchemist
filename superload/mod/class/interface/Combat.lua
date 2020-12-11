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

function _M:triggerGemAreaEffect(gem, grids)
    if gem.alchemist_bomb and gem.alchemist_bomb.splash and gem.alchemist_bomb.splash.type == "LITE" then
        if grids then
            for px, ys in pairs(grids or {}) do
                for py, _ in pairs(ys) do
                    DamageType:get(DamageType.LITE).projector(self, px, py, DamageType.LITE, gem.alchemist_bomb.splash.dam or 1)
                end
            end
        end
    end
end

function _M:triggerGemEffect(target, gem, dam)
    if gem.alchemist_bomb and gem.alchemist_bomb.splash and gem.alchemist_bomb.splash.type ~= "LITE" then
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
    if gem.alchemist_bomb and gem.alchemist_bomb.mana then
        local nb = self.turn_procs.alchemist_bomb_mana or 0
        self.turn_procs.alchemist_bomb_mana = nb + 1
        self:incMana(gem.alchemist_bomb.mana / nb)
    end
    if gem.alchemist_bomb and gem.alchemist_bomb.special then gem.alchemist_bomb.special(self, gem, target, dam) end

    return dam
end
return _M