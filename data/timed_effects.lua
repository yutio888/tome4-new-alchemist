local Particles = require "engine.Particles"
local Stats = require("engine.interface.ActorStats")
local DamageType = require("engine.DamageType")
newEffect {
    name = "DISRUPTED", image = "talents/mind_drones.png",
    desc = _t "Disrupted",
    long_desc = function(self, eff)
        return ("Talents fail chance %d%%."):tformat(eff.fail)
    end,
    type = "mental",
    subtype = { disrupt = true, confuse = true },
    status = "detrimental",
    parameters = { fail = 10 },
    on_gain = function(self, eff)
        return _t "#Target# has been disrupted by the rune!", true
    end,
    on_lose = function(self, eff)
        return _t "#Target# is free from the disruption.", true
    end,
    activate = function(self, eff)
        self:effectTemporaryValue(eff, "talent_fail_chance", eff.fail)
    end,
}

newEffect {
    name = "SUPERCHARGE_GOLEM_NEW", image = "talents/supercharge_golem_new.png",
    desc = _t "Supercharge Golem",
    long_desc = function(self, eff)
        return ("The target is supercharged, increasing speed by %d%%."):tformat(eff.speed, eff.power)
    end,
    type = "magical",
    subtype = { arcane = true },
    status = "beneficial",
    parameters = { speed = 10 },
    on_gain = function(self, eff)
        return _t "#Target# is overloaded with power.", _t "+Supercharge"
    end,
    on_lose = function(self, eff)
        return _t "#Target# seems less dangerous.", _t "-Supercharge"
    end,
    activate = function(self, eff)
        self:effectTemporaryValue(eff, "inc_damage", { all = eff.power })
        self:effectTemporaryValue(eff, "global_speed_add", eff.speed * 0.01)
        if core.shader.active(4) then
            eff.particle1 = self:addParticles(Particles.new("shader_shield", 1, { toback = true, size_factor = 1.5, y = -0.3, img = "healarcane" }, { type = "healing", time_factor = 4000, noup = 2.0, beamColor1 = { 0x8e / 255, 0x2f / 255, 0xbb / 255, 1 }, beamColor2 = { 0xe7 / 255, 0x39 / 255, 0xde / 255, 1 }, circleColor = { 0, 0, 0, 0 }, beamsCount = 5 }))
            eff.particle2 = self:addParticles(Particles.new("shader_shield", 1, { toback = false, size_factor = 1.5, y = -0.3, img = "healarcane" }, { type = "healing", time_factor = 4000, noup = 1.0, beamColor1 = { 0x8e / 255, 0x2f / 255, 0xbb / 255, 1 }, beamColor2 = { 0xe7 / 255, 0x39 / 255, 0xde / 255, 1 }, circleColor = { 0, 0, 0, 0 }, beamsCount = 5 }))
        end
    end,
    deactivate = function(self, eff)
        self:removeParticles(eff.particle1)
        self:removeParticles(eff.particle2)
    end,
}

newEffect {
    name = "ULTIMATE_POWER", image = "talents/supercharge_golem_new.png",
    desc = _t "Ultimate power",
    long_desc = function(self, eff)
        return ("The target gains ultimate power, increasing stats by %d and damage done by %d%%, and dealing %0.2f elemental damage in radius 6 each turn."):tformat(eff.stats, eff.power, eff.power, eff.dam)
    end,
    type = "magical",
    subtype = { arcane = true },
    status = "beneficial",
    parameters = { speed = 10 },
    on_gain = function(self, eff)
        return _t "#Target# is overloaded with power.", _t "+Ultimate power"
    end,
    on_lose = function(self, eff)
        return _t "#Target# seems less dangerous.", _t "-Ultimate power"
    end,
    activate = function(self, eff)
        self:effectTemporaryValue(eff, "inc_damage", { all = eff.power })
        self:effectTemporaryValue(eff, "inc_stats", {
            [Stats.STAT_STR] = math.floor(eff.stats or 1),
            [Stats.STAT_DEX] = math.floor(eff.stats or 1),
            [Stats.STAT_MAG] = math.floor(eff.stats or 1),
            [Stats.STAT_WIL] = math.floor(eff.stats or 1),
            [Stats.STAT_CUN] = math.floor(eff.stats or 1),
            [Stats.STAT_CON] = math.floor(eff.stats or 1),
        })
        if core.shader.active(4) then
            eff.particle1 = self:addParticles(Particles.new("shader_shield", 1, { toback = true, size_factor = 1.5, y = -0.3, img = "healarcane" }, { type = "healing", time_factor = 4000, noup = 2.0, beamColor1 = { 0x8e / 255, 0x2f / 255, 0xbb / 255, 1 }, beamColor2 = { 0xe7 / 255, 0x39 / 255, 0xde / 255, 1 }, circleColor = { 0, 0, 0, 0 }, beamsCount = 5 }))
            eff.particle2 = self:addParticles(Particles.new("shader_shield", 1, { toback = false, size_factor = 1.5, y = -0.3, img = "healarcane" }, { type = "healing", time_factor = 4000, noup = 1.0, beamColor1 = { 0x8e / 255, 0x2f / 255, 0xbb / 255, 1 }, beamColor2 = { 0xe7 / 255, 0x39 / 255, 0xde / 255, 1 }, circleColor = { 0, 0, 0, 0 }, beamsCount = 5 }))
        end
    end,
    deactivate = function(self, eff)
        self:removeParticles(eff.particle1)
        self:removeParticles(eff.particle2)
    end,
    on_timeout = function(self, eff)
        local tg = { type = "ball", x = self.x, y = self.y, radius = 6, friendlyfire = false }
        local dam = eff.dam or 1
        local damtype = rng.tableRemove({ DamageType.FIRE, DamageType.COLD, DamageType.LIGHTNING, DamageType.ACID })
        self:project(tg, self.x, self.y, damtype, self:spellCrit(dam))

        if core.shader.active() then
            game.level.map:particleEmitter(self.x, self.y, tg.radius, "ball_lightning_beam", { radius = tg.radius }, { type = "lightning" })
        else
            game.level.map:particleEmitter(self.x, self.y, tg.radius, "ball_lightning_beam", { radius = tg.radius })
        end

        game:playSoundNear(self, "talents/lightning")
    end,
}

newEffect {
    name = "FIRE_BURNT", image = "talents/flame.png",
    desc = _t "Fire Burnt",
    long_desc = function(self, eff)
        return ("The target is burnt by the fiery fire, reducing damage dealt by %d%%"):tformat(eff.reduce)
    end,
    type = "physical",
    subtype = { fire = true }, no_ct_effect = true,
    status = "detrimental",
    parameters = { reduce = 1 },
    activate = function(self, eff)
        self:effectTemporaryValue(eff, "numbed", eff.reduce)
    end,
}

newEffect {
    name = "FROST_SHIELD", image = "talents/frost_shield.png",
    desc = _t "Frost Shield",
    long_desc = function(self, eff)
        return ("The target is protected by the frost, reducing all damage except fire by %d."):tformat(eff.power)
    end,
    type = "magical",
    subtype = { ice = true },
    status = "beneficial",
    parameters = {},
    activate = function(self, eff)
    end,
    callbackOnTakeDamage = function(self, eff, src, x, y, type, dam, state)
        if type == DamageType.FIRE then
            return
        end
        local d_color = DamageType:get(type).text_color or "#ORCHID#"
        local reduce = math.min(dam, eff.power)
        if reduce > 0 then
            game:delayedLogDamage(src, self, 0, ("%s(%d frost reduce#LAST#%s)#LAST#"):tformat(d_color, reduce, d_color), false)
        else
            reduce = 0
        end
        return { dam = dam - reduce }
    end,

}

newEffect {
    name = "STONED_ARMOUR", image = "talents/stoneskin.png",
    desc = _t "Stoned Armour",
    long_desc = function(self, eff)
        return ("The target's armour has been enchanted, granting %d armour and %d%% armour hardiness, but decreasing defense by %d."):tformat(eff.ac, eff.hard, eff.ac)
    end,
    type = "physical",
    subtype = { nature = true },
    status = "beneficial",
    parameters = { ac = 10, hard = 10 },
    on_gain = function(self, err)
        return _t "#Target#'s skin looks a bit thorny.", _t "+Stoned Armour"
    end,
    on_lose = function(self, err)
        return _t "#Target# is less thorny now.", _t "-Stoned Armour"
    end,
    activate = function(self, eff)
        self:effectTemporaryValue(eff, "combat_armor", eff.ac)
        self:effectTemporaryValue(eff, "combat_armor_hardiness", eff.hard)
        self:effectTemporaryValue(eff, "combat_def", -eff.ac)
    end,
}

newEffect {
    name = "POTION_OF_MAGIC", image = "talents/gather_the_threads.png",
    desc = _t "Potion of Magic",
    long_desc = function(self, eff)
        return ("The target's spellpower has been increased by %d."):tformat(eff.cur_power or eff.power)
    end,
    charges = function(self, eff)
        return math.floor(eff.cur_power or eff.power)
    end,
    type = "magical",
    subtype = { arcane = true },
    status = "beneficial",
    parameters = { power = 10 },
    on_gain = function(self, err)
        return _t "#Target# is surging arcane power.", _t "+Magic Potion"
    end,
    on_lose = function(self, err)
        return _t "#Target# is no longer surging arcane power.", _t "-Magic Potion"
    end,
    activate = function(self, eff)
        eff.cur_power = eff.power
        eff.tmpid = self:addTemporaryValue("combat_spellpower", eff.power)
        eff.particle = self:addParticles(Particles.new("arcane_power", 1))
    end,
    deactivate = function(self, eff)
        self:removeTemporaryValue("combat_spellpower", eff.tmpid)
        self:removeParticles(eff.particle)
    end,
}

newEffect {
    name = "SUPER_LUCKY", image = "talents/lucky_day.png",
    desc = _t "Super Lucky",
    long_desc = function(self, eff)
        return ("%d%% chance to fully absorb any damaging actions."):tformat(eff.power)
    end,
    type = "physical",
    subtype = { nature = true },
    status = "beneficial",
    parameters = { power = 10 },
    charges = function(self, eff)
        return eff.power
    end,
    on_gain = function(self, err)
        return _t "#Target# is super lucky now.", _t "+Super Lucky"
    end,
    on_lose = function(self, err)
        return _t "#Target# seems less lucky.", _t "-Super Lucky"
    end,
    activate = function(self, eff)
        eff.tmpid = self:addTemporaryValue("cancel_damage_chance", eff.power)
    end,
    deactivate = function(self, eff)
        self:removeTemporaryValue("cancel_damage_chance", eff.tmpid)
    end,
}

newEffect {
    name = "SPEED_POTION", image = "talents/rapid_shot.png",
    desc = _t "Swiftness",
    long_desc = function(self, eff)
        return ("Increases movement speed by %d%%, global speed by %d%%."):tformat(eff.power, eff.power_all)
    end,
    type = "physical",
    subtype = { tactic = true },
    status = "beneficial",
    parameters = { power = 10 },
    activate = function(self, eff)
        self:effectTemporaryValue(eff, "movement_speed", eff.power * 0.01)
        self:effectTemporaryValue(eff, "global_speed_add", eff.power_all * 0.01)
    end,
}

newEffect {
    name = "DIAMOND_SPEED", image = "talents/infusion__movement.png",
    desc = _t "Diamond Speed",
    long_desc = function(self, eff)
        return ("Gain %d free moves."):tformat(eff.stack)
    end,
    type = "magical",
    subtype = { speed = true },
    status = "beneficial",
    parameters = { power = 100 },
    charges = function(self, eff)
        return eff.stack
    end,
    activate = function(self, eff)
        self:effectTemporaryValue(eff, "free_movement", 1)
    end,
    on_merge = function(self, old_eff, new_eff)
        local newstack = math.min(3, (old_eff.stack or 0) + (new_eff.stack or 0))
        local dur = math.max(old_eff.dur, new_eff.dur)
        old_eff.stack = newstack
        old_eff.dur = dur
        return old_eff
    end,
    callbackOnMove = function(self, eff, moved, force, ox, oy)
        if not moved or force then
            return
        end
        eff.stack = eff.stack - 1
        if eff.stack <= 0 then
            self:removeEffect(self.EFF_DIAMOND_SPEED)
        end
    end,
}

newEffect {
    name = "PEARL_ARMOUR", image = "effects/checkered-diamond.png",
    desc = _t "Pearl Armour",
    long_desc = function(self, eff)
        return ("Increases armour by %d."):tformat(eff.stack * 25)
    end,
    type = "magical",
    subtype = { speed = true },
    status = "beneficial",
    parameters = { power = 100 },
    charges = function(self, eff)
        return eff.stack * 25
    end,
    activate = function(self, eff)
        eff.speed = self:addTemporaryValue("combat_armor", eff.stack * 25)
    end,
    deactivate = function(self, eff)
        self:removeTemporaryValue("combat_armor", eff.speed)
    end,
    on_merge = function(self, old_eff, new_eff)
        self:removeTemporaryValue("combat_armor", old_eff.speed)
        local newstack = math.min(3, old_eff.stack + new_eff.stack)
        local dur = math.max(old_eff.dur, new_eff.dur)
        old_eff.stack = newstack
        old_eff.dur = dur
        old_eff.speed = self:addTemporaryValue("combat_armor", old_eff.stack * 25)
        return old_eff
    end,
}

newEffect {
    name = "JADE_REGEN", image = "talents/infusion__regeneration.png",
    desc = _t "Jade Regeneration",
    long_desc = function(self, eff)
        return ("Increases life regeneration by %d per turn."):tformat(eff.stack * 50)
    end,
    type = "magical",
    subtype = { healing = true, regeneration = true },
    status = "beneficial",
    parameters = { power = 10 },
    charges = function(self, eff)
        return eff.stack
    end,
    activate = function(self, eff)
        eff.tmpid = self:addTemporaryValue("life_regen", eff.stack * 50)
    end,
    deactivate = function(self, eff)
        self:removeTemporaryValue("life_regen", eff.tmpid)
    end,
    on_merge = function(self, old_eff, new_eff)
        self:removeTemporaryValue("life_regen", old_eff.tmpid)
        local newstack = math.min(3, old_eff.stack + new_eff.stack)
        local dur = math.max(old_eff.dur, new_eff.dur)
        old_eff.stack = newstack
        old_eff.dur = dur
        old_eff.tmpid = self:addTemporaryValue("life_regen", old_eff.stack * 50)
        return old_eff
    end,
}

newEffect {
    name = "EMERALD_AFFINITY", image = "talents/infusion__wild.png",
    desc = _t "Emerald Affinity",
    long_desc = function(self, eff)
        return ("Increases affinity for all damage by %d%%."):tformat(eff.stack * 5)
    end,
    type = "magical",
    subtype = {  },
    status = "beneficial",
    parameters = { power = 10 },
    charges = function(self, eff)
        return eff.stack
    end,
    activate = function(self, eff)
        eff.tmpid = self:addTemporaryValue("damage_affinity", { all = eff.stack * 5 })
    end,
    deactivate = function(self, eff)
        self:removeTemporaryValue("damage_affinity", eff.tmpid)
    end,
    on_merge = function(self, old_eff, new_eff)
        self:removeTemporaryValue("damage_affinity", old_eff.tmpid)
        local newstack = math.min(3, old_eff.stack + new_eff.stack)
        local dur = math.max(old_eff.dur, new_eff.dur)
        old_eff.stack = newstack
        old_eff.dur = dur
        old_eff.tmpid = self:addTemporaryValue("damage_affinity", { all = old_eff.stack * 5 })
        return old_eff
    end,
}

newEffect {
    name = "ONYX_HEAL_ENCHANT", image = "talents/infusion__wild.png",
    desc = _t "Onyx Heal Enchant",
    long_desc = function(self, eff)
        return ("Increases healing factor by %d%%."):tformat(eff.stack * 20)
    end,
    type = "magical",
    subtype = { heal = true },
    status = "beneficial",
    parameters = { power = 10 },
    charges = function(self, eff)
        return eff.stack
    end,
    activate = function(self, eff)
        eff.tmpid = self:addTemporaryValue("healing_factor", eff.stack * 0.2)
    end,
    deactivate = function(self, eff)
        self:removeTemporaryValue("healing_factor", eff.tmpid)
    end,
    on_merge = function(self, old_eff, new_eff)
        self:removeTemporaryValue("healing_factor", old_eff.tmpid)
        local newstack = math.min(3, old_eff.stack + new_eff.stack)
        local dur = math.max(old_eff.dur, new_eff.dur)
        old_eff.stack = newstack
        old_eff.dur = dur
        old_eff.tmpid = self:addTemporaryValue("healing_factor", old_eff.stack * 0.3)
        return old_eff
    end,
}

newEffect{
    name = "AMETRINE_DEFENSE", image = "talents/phase_door.png",
    desc = _t"Ametrine Defense",
    long_desc = function(self, eff) return ("The target's defense is boosted by %d."):tformat(eff.defense) end,
    type = "physical",
    subtype = { evade=true },
    status = "beneficial",
    parameters = { defense=10 },
    activate = function(self, eff)
        eff.defenseChangeId = self:addTemporaryValue("combat_def", eff.defense)
    end,
    deactivate = function(self, eff)
        self:removeTemporaryValue("combat_def", eff.defenseChangeId)
    end,
}
newEffect {
    name = "ELEMENTAL_PROTECTION", image = "talents/alchemist_protection.png",
    desc = _t "Elemental Protection",
    long_desc = function(self, eff)
        return ("Increases %d%% elemental resistance.%s"):tformat(eff.power,
         eff.cleanse and _t" Blocks fire/cold/lightning/acid detrimental effects" or "")
    end,
    type = "magical",
    subtype = { elemental = true },
    status = "beniicial",
    parameters = { },
    activate = function(self, eff)
        self:effectTemporaryValue(eff, "resists", {
            [DamageType.FIRE] = eff.power,
            [DamageType.COLD] = eff.power,
            [DamageType.LIGHTNING] = eff.power,
            [DamageType.ACID] = eff.power,
        })
    end,
    callbackOnTemporaryEffect = function(self, eff, eff_id, e, p)
        if not eff.cleanse then return end
        if e.status == "beneficial" then return end
        if e.subtype.fire or e.subtype.cold or e.subtype.lightning or e.subtype.acid then
            return true
        end
    end,
}
newEffect{
    name = "POTION_RECYCLE", image = "talents/ingredient_recycle.png",
    desc = _t"Ingredient Recycle",
    long_desc = function(self, eff) return ("You have %d power stored."):tformat(self._potion_pts or 0) end,
    type = "other",
    subtype = { heal=true },
    status = "beneficial",
    parameters = { power = 10 },
}