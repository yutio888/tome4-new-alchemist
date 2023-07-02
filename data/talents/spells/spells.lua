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
        sound = "talents/earth",
    },
    ["arcane"] = {
        type = DamageType.ARCANE,
        ["ball"] = "ball_arcane",
        ["cone"] = "breath_arcane",
        ["widebeam"] = "mana_beam_wide",
        sound = "talents/arcane",
    },
    ["light"] = {
        type = DamageType.LIGHT,
        ["ball"] = "ball_light",
        ["cone"] = "breath_light",
        ["widebeam"] = "light_beam_wide",
        sound = "talents/heal",
    },
    ["darkness"] = {
        type = DamageType.DARKNESS,
        ["ball"] = "ball_darkness",
        ["cone"] = "breath_dark",
        ["widebeam"] = "shadow_beam",
        sound = "talents/spell_generic",
    },
    ["fire"] = {
        type = DamageType.FIRE,
        ["ball"] = "fireflash",
        ["cone"] = "breath_fire",
        ["widebeam"] = "flamebeam_wide",
        sound = "talents/fire",
    },
    ["cold"] = {
        type = DamageType.COLD,
        ["ball"] = "ball_ice",
        ["cone"] = "breath_cold",
        ["widebeam"] = "ice_beam_wide",
        sound = "talents/ice",
    },
    ["acid"] = {
        type = DamageType.ACID,
        ["ball"] = "ball_acid",
        ["cone"] = "breath_acid",
        ["widebeam"] = "acid_beam_wide",
        sound = "talents/cloud",
    },
    ["lightning"] = {
        type = DamageType.LIGHTNING,
        ["ball"] = "ball_lightning_beam",
        ["cone"] = "breath_lightning",
        ["widebeam"] = "lightning_beam_wide",
        sound = "talents/lightning",
    },
}
function bombUtil:getElementalInsufionType(self)
    if self:knowTalent(self.T_ELEMENTAL_INFUSION) and self.elemental_infusion then
        local type = self.elemental_infusion
        if type == "fire" then
            return DamageType.FIRE
        elseif type == "acid" then
            return DamageType.ACID
        elseif type == "cold" then
            return DamageType.COLD
        elseif type == "lightning" then
            return DamageType.LIGHTNING
        elseif type == "light" then
            return DamageType.LIGHT
        elseif type == "darkness" then
            return DamageType.DARKNESS
        elseif type == "arcane" then
            return DamageType.ARCANE
        else
            return DamageType.PHYSICAL
        end
    end
    return DamageType.PHYSICAL
end
function bombUtil:getSound(self)
    local damtype = DamageType.PHYSICAL
    if self:knowTalent(self.T_ELEMENTAL_INFUSION) then
        type = self.elemental_infusion
    end
    damtype = dam_table[type] or dam_table["default"]
    return damtype.sound
end
function bombUtil:playSound(self)
    game:playSoundNear(self, bombUtil:getSound(self))
end
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
bombUtil["theoretical_nbs"] = { 9, 21, 37, 69, 97, 137, 177, 225, 293, 349, 421, 489, 577, 665, 749, 861, 973, 1085, 1201, 1313 }


newTalentType { allow_random = true, no_silence = true, is_spell = true, mana_regen = true, type = "spell/new-explosive", name = _t "explosive admixtures", description = _t "Manipulate gems to turn them into explosive magical bombs." }
newTalentType { allow_random = true, no_silence = true, is_spell = true, mana_regen = true, type = "spell/new-golemancy", name = _t "golemancy", speed = "standard", description = _t "Learn to craft and upgrade your golem." }
newTalentType { allow_random = true, no_silence = true, is_spell = true, mana_regen = true, type = "spell/new-advanced-golemancy", name = _t "advanced-golemancy", min_lev = 10, speed = "standard", description = _t "Advanced golem operations." }
newTalentType { allow_random = true, no_silence = true, is_spell = true, mana_regen = true, type = "spell/elemental-alchemy", name = _t "elemental alchemy", min_lev = 10, description = _t "Alchemical spells designed to wage war." }
newTalentType { allow_random = true, no_silence = true, is_spell = true, mana_regen = true, type = "spell/new-golemancy-base", name = _t "golemancy", speed = "standard", hide = true, description = _t "Learn to craft and upgrade your golem." }
newTalentType { allow_random = true, no_silence = true, is_spell = true, type = "spell/gem-spell", name = _t "gem spell", description = _t "invoke your gem power." }
newTalentType { is_spell = true, type = "spell/alchemy-potion", name = _t "alchemy potions", description = _t "prepare some alchemy potions." }
newTalentType { is_spell = true, type = "spell/alchemy-potions", hide = true, name = _t "alchemy potions", description = _t "some useful alchemy potions." }

newTalentType { allow_random = true, no_silence = true, is_spell = true, mana_regen = true, type = "spell/explosion-control", name = _t "explostion-control", min_lev = 10, description = _t "Control your alchemist bomb." }

damDesc = Talents.main_env.damDesc
spells_req1 = Talents.main_env.spells_req1
spells_req2 = Talents.main_env.spells_req2
spells_req3 = Talents.main_env.spells_req3
spells_req4 = Talents.main_env.spells_req4
spells_req5 = Talents.main_env.spells_req5

spells_req_high1 = Talents.main_env.spells_req_high1
spells_req_high2 = Talents.main_env.spells_req_high2
spells_req_high3 = Talents.main_env.spells_req_high3
spells_req_high4 = Talents.main_env.spells_req_high4
spells_req_high5 = Talents.main_env.spells_req_high5
load("/data-new-alchemist/talents/spells/elemental-infusion.lua")
load("/data-new-alchemist/talents/spells/new-explosive.lua")
load("/data-new-alchemist/talents/spells/new-golemancy.lua")
load("/data-new-alchemist/talents/spells/new-advanced-golemancy.lua")
load("/data-new-alchemist/talents/spells/gem-spell.lua")
load("/data-new-alchemist/talents/spells/alchemy-potions.lua")
load("/data-new-alchemist/talents/spells/new-alchemy-potion.lua")
load("/data-new-alchemist/talents/spells/explosion-control.lua")

techs_req1 = Talents.main_env.techs_req1
techs_req2 = Talents.main_env.techs_req2
techs_req3 = Talents.main_env.techs_req3
techs_req4 = Talents.main_env.techs_req4
techs_req5 = Talents.main_env.techs_req5
newTalentType { type = "golem/new-fighting", name = _t "fighting", description = _t "Golem melee capacity." }
newTalentType { type = "golem/new-arcane", no_silence = true, is_spell = true, name = _t "arcane", description = _t "Golem arcane capacity." }
newTalentType { type = "golem/energy", no_silence = true, is_spell = true, generic = true, name = _t "energy", description = _t "Golem energy capacity." }

load("/data-new-alchemist/talents/spells/golem-fighting.lua")
load("/data-new-alchemist/talents/spells/golem-arcane.lua")
load("/data-new-alchemist/talents/spells/golem-energy.lua")