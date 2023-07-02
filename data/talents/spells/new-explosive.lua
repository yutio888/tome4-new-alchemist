-- ToME - Tales of Maj'Eyal
-- Copyright (C) 2009 - 2019 Nicolas Casalini
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.
--
-- Nicolas Casalini "DarkGod"
-- darkgod@te4.org
local DamageType = require "engine.DamageType"
bombUtil = {}
local emit_table = {
    ["ball"] = function(self, particle, tg, x, y, startx, starty)
        local _, x, y = self:canProject(tg, x, y)
        game.level.map:particleEmitter(x, y, tg.radius, particle, { radius = tg.radius, tx = x, ty = y })
    end,
    ["cone"] = function(self, particle, tg, x, y, startx, starty)
        if not startx then
            startx = self.x
        end
        if not starty then
            starty = self.y
        end
        game.level.map:particleEmitter(startx, starty, tg.radius, particle, { radius = tg.radius, tx = x - startx, ty = y - starty })
    end,
    ["widebeam"] = function(self, particle, tg, x, y, startx, starty)
        if not startx then
            startx = self.x
        end
        if not starty then
            starty = self.y
        end
        game.level.map:particleEmitter(startx, starty, tg.radius, particle, { radius = tg.radius, tx = x - startx, ty = y - starty })
    end,
}
local dam_table = {
    ["default"] = {
        type = DamageType.PHYSICAL,
        ["ball"] = "ball_physical",
        ["cone"] = "breath_earth",
        ["widebeam"] = "earth_beam_wide",
    },
    ["arcane"] = {
        type = DamageType.ARCANE,
        ["ball"] = "ball_arcane",
        ["cone"] = "breath_arcane",
        ["widebeam"] = "mana_beam_wide",
    },
    ["light"] = {
        type = DamageType.LIGHT,
        ["ball"] = "ball_light",
        ["cone"] = "breath_light",
        ["widebeam"] = "light_beam_wide"
    },
    ["darkness"] = {
        type = DamageType.DARKNESS,
        ["ball"] = "ball_darkness",
        ["cone"] = "breath_dark",
        ["widebeam"] = "shadow_beam",
     },
    ["fire"] = {
        type = DamageType.FIRE,
        ["ball"] = "fireflash",
        ["cone"] = "breath_fire",
        ["widebeam"] = "flamebeam_wide",
    },
    ["cold"] = {
        type = DamageType.COLD,
        ["ball"] = "ball_ice",
        ["cone"] = "breath_cold",
        ["widebeam"] = "ice_beam_wide",
    },
    ["acid"] = {
        type = DamageType.ACID,
        ["ball"] = "ball_acid",
        ["cone"] = "breath_acid",
        ["widebeam"] = "acid_beam_wide",
    },
    ["lightning"] = {
        type = DamageType.LIGHTNING,
        ["ball"] = "ball_lightning_beam",
        ["cone"] = "breath_lightning",
        ["widebeam"] = "lightning_beam_wide",
    },
}
function bombUtil:getBaseDamage(self, t, ammo, tg)
    local inc_dam = 0
    local damtype = DamageType.PHYSICAL
    local type = "default"
    local particle
    if self:knowTalent(self.T_ELEMENTAL_INFUSION) then
        type = self.elemental_infusion
    end
    damtype = dam_table[type] or dam_table["default"]
    particle = damtype[tg and tg.type or "ball"] or damtype["ball"]
    damtype = damtype.type or DamageType.PHYSICAL
    inc_dam = inc_dam + (ammo.alchemist_bomb and ammo.alchemist_bomb.power or 0) / 100
    local dam
    if t.getBaseDamage then
        dam = t.getBaseDamage(self, t)
    else
        dam = self:combatTalentSpellDamageBase(t, 30, 200, self:combatSpellpower(1, self:combatGemPower() / 2))
    end
    dam = dam * (1 + inc_dam)
    local arg = emit_table[tg and tg.type or "ball"] or emit_table["ball"]
    return dam, damtype, particle, arg
end
function bombUtil:throwBomb(self, t, ammo, tg, x, y, startx, starty)
    local dam, damtype, particle, emit, crit = bombUtil:getBaseDamage(self, t, ammo, tg)
    dam, crit = self:spellCrit(dam)
    local golem
    if self.alchemy_golem then
        golem = game.level:hasEntity(self.alchemy_golem) and self.alchemy_golem or nil
    end
    local grids = self:project(tg, x, y, function(tx, ty)
    end)
    self:triggerGemAreaEffect(ammo, grids)

    local tgts = table.values(self:projectCollect(tg, x, y, Map.ACTOR))
    dam = self:callTalent(t.id, "calcFurtherDamage", tg, ammo, x, y, dam, tgts, grids) or dam
    table.sort(tgts, "dist")
    for _, l in ipairs(tgts) do
        local target = l.target
        if target:reactionToward(self) < 0 then
            DamageType:get(damtype).projector(self, target.x, target.y, damtype, dam)
            self:triggerGemEffect(target, ammo, dam)
        end
        if target == self.alchemy_golem and target:knowTalent(target.T_GOLEM_RECHARGE) then
            local tids = table.keys(golem.talents_cd)
            local chance = target:callTalent(target.T_GOLEM_RECHARGE, "getChance")
            local did_something = false
            local nb = 1
            for _, tid in ipairs(tids) do
                if golem.talents_cd[tid] > 0 and rng.percent(chance) then
                    golem.talents_cd[tid] = golem.talents_cd[tid] - nb
                    if golem.talents_cd[tid] <= 0 then
                        golem.talents_cd[tid] = nil
                    end
                    did_something = true
                end
            end
            if did_something then
                game.logSeen(golem, "%s is energized by the attack, reducing some talent cooldowns!", golem.name:capitalize())
            end
        end
    end

    self:fireTalentCheck("callbackOnAlchemistBomb", tgts, t, x, y, startx, starty, crit)
    emit(self, particle, tg, x, y, startx, starty)
    return tgts
end
newTalent {
    name = "Throw Bomb", short_name = "THROW_BOMB_NEW", image = "talents/throw_bomb.png",
    type = { "spell/new-explosive", 1 },
    require = spells_req1,
    points = 5,
    mana = function(self, t)
        return 5
    end,
    cooldown = 4,
    range = function(self, t)
        return math.floor(self:combatTalentLimit(t, 15, 5.1, 9.1))
    end,
    radius = function(self, t)
        return self:callTalent(self.T_EXPLOSION_EXPERT_NEW, "getRadius")
    end,
    requires_target = true,
    target = function(self, t)
        local ammo = self:hasAlchemistWeapon()
        if not ammo then
            return
        end
        return { selffire = false, friendlyfire = false, type = "ball", range = self:getTalentRange(t) + (ammo and ammo.alchemist_bomb and ammo.alchemist_bomb.range or 0), radius = self:getTalentRadius(t), talent = t }
    end,
    on_learn = function(self, t)
        self:checkCanWearGem()
    end,
    on_unlearn = function(self, t)
        self:checkCanWearGem()
    end,
    tactical = { ATTACKAREA = function(self, t, target)
        if self:knowTalent(self.T_ELEMENTAL_INFUSION) then
            local type = self.elemental_infusion
            if type == "fire" then
                return { FIRE = 2 }
            elseif type == "acid" then
                return { ACID = 2 }
            elseif type == "cold" then
                return { COLD = 2 }
            elseif type == "lightning" then
                return { LIGHTNING = 2 }
            else
                return { PHYSICAL = 2 }
            end
        else
            return { PHYSICAL = 2 }
        end
    end },
    calcFurtherDamage = function(self, t, tg, ammo, x, y, dam, tgts, grids)
        local nb = 0
        -- Compare theorical AOE zone with actual zone and adjust damage accordingly
        if self:knowTalent(self.T_EXPLOSION_EXPERT_NEW) then
            if grids then
                for px, ys in pairs(grids or {}) do
                    for py, _ in pairs(ys) do
                        nb = nb + 1
                    end
                end
            end
            if nb > 0 then
                dam = dam + dam * self:callTalent(self.T_EXPLOSION_EXPERT_NEW, "minmax", nb)
            end
        end
        return dam
    end,
    on_pre_use = function(self, t)
        return self:hasAlchemistWeapon()
    end,
    callbackOnAlchemistBomb = function(self, t, tgts, talent)
        if t == talent then
            return
        end
        self:startTalentCooldown(t.id)
    end,
    action = function(self, t)
        local ammo = self:hasAlchemistWeapon()
        if not ammo then
            game.logPlayer(self, "You need to ready gems in your quiver.")
            return
        end

        local tg = self:getTalentTarget(t)
        local x, y = self:getTarget(tg)
        if not x or not y then
            return nil
        end
        bombUtil:throwBomb(self, t, ammo, tg, x, y)
        game:playSoundNear(self, "talents/arcane")
        return true
    end,
    info = function(self, t)
        local ammo = self:hasAlchemistWeapon()
        local dam, damtype = 1, DamageType.PHYSICAL
        if ammo then
            dam, damtype = bombUtil:getBaseDamage(self, t, ammo)
        end
        dam = damDesc(self, damtype, dam)
        return ([[Imbue an alchemist gem with an explosive charge of mana and throw it.
		The gem will explode for %0.1f %s damage.
		Each kind of gem will also provide a specific effect.
		The damage will improve with better gems and with your Spellpower.
		Using this talent will put other bomb talent go on cooldown.]]):tformat(dam, DamageType:get(damtype).name)
    end,
}

newTalent {
    name = "Alchemist Protection", short_name = "NEW_ALCHEMIST_PROTECTION", image = "talents/alchemist_protection.png",
    type = { "spell/new-explosive", 2 },
    require = spells_req2,
    points = 5,
    getResists = function(self, t)
        return self:combatTalentSpellDamageBase(t, 5, 10) + 5
    end,
    cooldown = function(self, t)
        return 20 - self:combatTalentLimit(t, 18, 0, 10)
    end,
    mana = 25,
    no_energy = true,
    getDur = function(self, t) return 8 end,
    passives = function(self, t, ret)
        self:talentTemporaryValue(ret, "resists", {
            [DamageType.FIRE] = t.getResists(self, t),
            [DamageType.COLD] = t.getResists(self, t),
            [DamageType.LIGHTNING] = t.getResists(self, t),
            [DamageType.ACID] = t.getResists(self, t),
        })
    end,
    action = function(self, t)
        local cleanse = self:getTalentLevel(t) >= 3
        if cleanse then
            self:removeEffectsFilter(self, { status = "detrimental", subtype = { fire = true, cold = true, lightning = true, acid = true} }, 999)
        end
        self:setEffect(self.EFF_ELEMENTAL_PROTECTION, t.getDur(self, t), {power = t.getResists(self, t), cleanse = cleanse})
        game:playSoundNear(self, "talents/flame")
        return true
    end,
    getMana = function(self, t)
        return self:combatTalentLimit(t, 25, 5, 12)
    end,
    callbackOnTakeDamage = function(self, t, src, x, y, type, dam, state)
        if type == DamageType.FIRE or type == DamageType.ACID or type == DamageType.COLD or type == DamageType.LIGHTNING then
            self:incMana(t.getMana(self, t))
        end
    end,
    info = function(self, t)
        return ([[Grants protection against external elemental damage (fire, cold, lightning and acid) by %d%%.
		You can activate this talent, to grant yourself extra %d%% elemental resistance for %d turns.
		At talent level 3, the flow of elemental energy will cleanse and block elemental detrimental effects.]]):
        tformat(t.getResists(self, t), t.getResists(self, t), t.getDur(self, t))
    end,
}

bombUtil["theoretical_nbs"] = { 9, 21, 37, 69, 97, 137, 177, 225, 293, 349, 421, 489, 577, 665, 749, 861, 973, 1085, 1201, 1313 }
newTalent {
    name = "Explosion Expert", short_name = "EXPLOSION_EXPERT_NEW", image = "talents/explosion_expert.png",
    type = { "spell/new-explosive", 3 },
    require = spells_req3,
    mode = "passive",
    points = 5,
    getRadius = function(self, t)
        return math.max(1, math.floor(self:combatTalentLimit(t, 20, 2.5, 6.6)))
    end,
    mingrids = function(self, t)
        return math.max(0, self:combatTalentScale(t, 1, 5))
    end,
    reduction = 2,
    minmax = function(self, t, grids, expected_grids)
        local theoretical_nb = expected_grids or bombUtil.theoretical_nbs[t.getRadius(self, t)]
        if grids then
            local lostgrids = math.max(theoretical_nb - grids, t.mingrids(self, t))
            local mult = math.max(0, math.log10(lostgrids)) / (6 - math.min(self:getTalentLevel(self.T_EXPLOSION_EXPERT_NEW), 5))
            mult = mult / t.reduction
            print("Adjusting explosion damage to account for ", lostgrids, " lost tiles => ", mult * 100)
            return mult
        else
            local min = (math.max(0, math.log10(t.mingrids(self, t))) / (6 - math.min(self:getTalentLevel(t), 5))) / t.reduction
            local max = (math.log10(theoretical_nb) / (6 - math.min(self:getTalentLevel(t), 5))) / t.reduction
            return min, max
        end
    end,
    info = function(self, t)
        local min, max = t.minmax(self, t)
        return ([[Your alchemist bombs now affect a radius of %d around them. (This only works for the basic Throwing Bomb talent.)
		Explosion damage may increase by %d%% (if the explosion is not contained) to %d%% if the area of effect is confined.]]):
        tformat(t.getRadius(self, t), min * 100, max * 100)
    end,
}

newTalent {
    name = "Explosion Shield", short_name = "CHAIN_BLASTING", image = "talents/shockwave_bomb.png",
    type = { "spell/new-explosive", 4 },
    require = spells_req4,
    mode = "sustained",
    points = 5,
    tactical = {  SPECIAL = 2 },
    sustain_mana = 25,
    critResist = function(self, t)
        return self:combatTalentLimit(t, 75, 10, 50)
    end,
    getShieldFlat = function(self, t)
        return self:combatTalentSpellDamageBase(t, 50, 200)
    end,
    callbackOnAlchemistBomb = function(self, t, tgts, tt, x, y, startx, starty, crit)
        if crit and not self._bomb_shield then
            self._bomb_shield = 4
            local shield_power = self:spellCrit(t.getShieldFlat(self, t))
            if self:hasEffect(self.EFF_DAMAGE_SHIELD) then
                local shield = self:hasEffect(self.EFF_DAMAGE_SHIELD)
                shield.power = shield.power + shield_power
                self.damage_shield_absorb = self.damage_shield_absorb + shield_power
                self.damage_shield_absorb_max = self.damage_shield_absorb_max + shield_power
            else
                self:setEffect(self.EFF_DAMAGE_SHIELD, 5, { power = shield_power})
            end
        end
    end,
    callbackOnActBase = function(self, t)
        if self._bomb_shield then
            self._bomb_shield = self._bomb_shield - 1
            if self._bomb_shield <= 0 then
                self._bomb_shield = nil
            end
        end
    end,
    activate = function(self, t)
        local ret = {}
        self:talentTemporaryValue(ret, "ignore_direct_crits", t.critResist(self, t))
        return ret
    end,
    deactivate = function(self, t)
        return true
    end,
    iconOverlay = function(self, t, p)
        local val = self._bomb_shield or 0
        if val <= 0 then return "" end
        return tostring(math.ceil(val)), "buff_font_small"
    end,
    info = function(self, t)
        local cd = _t"available"
        if self._bomb_shield then
            cd = ("%d"):format(self._bomb_shield)
        end
        return ([[Your mastery of explosive material makes you much more resilient against all kinds of critical hits.
        All direct critical hits (physical, mental, spells) against you have a %d%% lower critical multiplier
        Besides, each time your bomb deals a critical hit, you'll gain a shield of %d for 5 turns, or if you already have a shield, increasing its shield power instead. This effect has a cooldown of 4 turns. (Current: %s)
        The power of the shield can crit.]])
                :tformat(t.critResist(self, t), t.getShieldFlat(self, t), cd)
    end,
}