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

local Stats = require "engine.interface.ActorStats"

newEntity {
    define_as = "BASE_GEM",
    type = "gem", subtype = "white",
    display = "*", color = colors.YELLOW,
    encumber = 0, slot = "GEM", use_no_wear = true,
    identified = true,
    stacking = true,
    auto_pickup = true, pickup_sound = "actions/gem",
    desc = _t [[Gems can be sold for money or used in arcane rituals.]],
}

local gem_color_attributes = {
    black = {
        damage_type = 'ACID',
        alt_damage_type = 'ACID_DISARM',
        particle = 'acid', },
    blue = {
        damage_type = 'LIGHTNING',
        alt_damage_type = 'LIGHTNING_DAZE',
        particle = 'lightning_explosion', },
    green = {
        damage_type = 'NATURE',
        alt_damage_type = 'SPYDRIC_POISON',
        particle = 'slime', },
    red = {
        damage_type = 'FIRE',
        alt_damage_type = 'FLAMESHOCK',
        particle = 'flame', },
    violet = {
        damage_type = 'ARCANE',
        alt_damage_type = 'ARCANE_SILENCE',
        particle = 'manathrust', },
    white = {
        damage_type = 'COLD',
        alt_damage_type = 'ICE',
        particle = 'freeze', },
    yellow = {
        damage_type = 'LIGHT',
        alt_damage_type = 'LIGHT_BLIND',
        particle = 'light', }, }

-- Let addons alter colors before the gems are created. This is weird,
-- since there's no base class to call it for, since it's just a
-- table. To bind:
-- class.bindHook('GemColorAttributes', function(gem_color_attributes) ... end)
class.triggerHook(gem_color_attributes, { 'GemColorAttributes', })

local function newGem(name, image, cost, rarity, color, min_level, max_level, tier, power, imbue, bomb)
    -- Gems, randomly lootable
    newEntity { base = "BASE_GEM", define_as = "GEM_" .. name:gsub(" ", "_"):upper(),
                name = name:lower(), subtype = color,
                color = colors[color:upper()], image = image,
                level_range = { min_level, max_level },
                rarity = rarity, cost = cost * 10,
                material_level = tier,
                imbue_powers = imbue,
                wielder = imbue,
                attack_type = gem_color_attributes[color].damage_type, -- deprecated, hopefully nothing's still using it.
                color_attributes = gem_color_attributes[color],
                alchemist_power = power,
                alchemist_bomb = bomb,
                require = { flag = { "gem related talents" }, },
                slot = "QUIVER",
    }
    -- Alchemist gems, not lootable, only created by talents
    newEntity { base = "BASE_GEM", define_as = "ALCHEMIST_GEM_" .. name:gsub(" ", "_"):upper(), name = "alchemist " .. name:lower(), type = 'alchemist-gem', subtype = color,
                slot = "QUIVER",
                moddable_tile = resolvers.moddable_tile("gembag"),
                use_no_wear = false,
                color = colors[color:upper()], image = image,
                cost = cost * 0.01,
                material_level = tier,
                alchemist_power = power,
                alchemist_bomb = bomb,
    }
end



--Remake:
--5	Fire	    Fire Opal	+15% dam, +5% crit	+30% splash Fire Burn damage
--5	Cold	    Pearl	+5% resist, +10 armor	+ 25 armor for 3 turns(stack for 3 times)
--5	Lightning	Diamond	+25% move speed	+ 1 free move in 2 turns(stack for 3 times)
--5	Acid	    Jade	+50% stun res	+ 50 life regen for 3 turns(stack for 3 times)
--5	Arcane	    Moonstone	+20 def & saves	50% silence for 2 turns
--4	Fire	    Bloodstone	+12% dam, +4% crit	+24% splash Fire Burn damage
--4	Cold	    Sapphire	+16 def & saves	+12% slpash Ice damage(25% chance to freeze, otherwise wet)
--4	Lightning	Amber	+8 mana on crit	+ 40 mana
--4	Acid	    Emerald	+5% resist	+ 5% affinity for all damage in 3 turns
--4	Nature	    Turquoise	+12% res pen, +12 acc	50% chance to disarm for 2 turns
--3	Fire	    Ruby	+9%dam, +3%crit	+18% splash Fire Burn damage
--3	Cold	    Quartz	+30% stun res	+10% splash Physical Knockback damage
--3	Lightning	Lapis Lazuli	+2 mana regen	+ 30 mana
--3	Acid	    Onyx	+20% heal mod	+30% heal mod for 3 turns
--3	Light	    Amethyst	+10% cast speed	50% chance to cleanse one magical debuff
--2	Fire	    Garnet	+6%dam, +2%crit	+12% splash Fire Burn damage
--2	Cold	    Topaz	+10 def&saves	Throw bomb range + 4
--2	Lightning	Aquamarine	+30% lightning res	+ 20 mana
--2	Acid	    Opal	+ 5 all stats	+ 5% leech
--1	Acid	    Agate	+ 3%dam, +1%crit	+10% bomb damage
--1	Light	    Citrine	+4 light & infravision	Lights terrain
--1	Light	    Zircon	+10 armor	30% daze for 2 turns
--1	Nature	    Spinel	+5 life regen	+20% splash Poison damage
--1	Light	    Ametrine	+10 def	+20 def for 5 turns


newGem("Diamond", "object/diamond.png", 5, 18, "blue", 40, 50, 5, 70,
        { movement_speed = 0.25 },
        { splash = { desc = _t "Gain one free move in 2 turns (stacks for 3 times)" }, special_area = function(self, gem, grids)
            self:setEffect(self.EFF_DIAMOND_SPEED, 2, { stack = 1 })
        end }
)
newGem("Pearl", "object/pearl.png", 5, 18, "white", 40, 50, 5, 70,
        { resists = { all = 5 }, combat_armor = 10 },
        { splash = { desc = _t "Gain 25 armor in 3 turns (stacks for 3 times)" }, special_area = function(self, gem, grids)
            self:setEffect(self.EFF_PEARL_ARMOUR, 3, { stack = 1 })
        end }
)
newGem("Moonstone", "object/moonstone.png", 5, 18, "violet", 40, 50, 5, 70,
        { combat_def = 20, combat_mentalresist = 20, combat_spellresist = 20, combat_physresist = 20, },
        { special = function(self, gem, target, dam)
            if rng.percent(50) and target:canBe("silence") then
                target:setEffect(target.EFF_SILENCED, 2, {})
            end
        end, splash = { desc = _t "50% chance to silence for 2 turns" } }
)
newGem("Fire Opal", "object/fireopal.png", 5, 18, "red", 40, 50, 5, 70,
        { inc_damage = { all = 15 }, combat_physcrit = 5, combat_mindcrit = 5, combat_spellcrit = 5, },
        { splash = { type = "FIREBURN", dam = 30, desc = ("Deals %d%% extra fireburn damage"):tformat(30) } }
)
newGem("Jade", "object/jade.png", 5, 18, "black", 40, 50, 5, 70,
        { stun_immune = 0.5 },
        { splash = { desc = _t "Regen 150 life in 3 turns (stacks for 3 times)" }, special_area = function(self, gem, grids)
            self:setEffect(self.EFF_JADE_REGEN, 3, { stack = 1 })
        end }
)

newGem("Bloodstone", "object/bloodstone.png", 4, 16, "red", 30, 40, 4, 65,
        { inc_damage = { all = 12 }, combat_physcrit = 4, combat_mindcrit = 4, combat_spellcrit = 4, },
        { splash = { type = "FIREBURN", dam = 24, desc = ("Deals %d%% extra fireburn damage"):tformat(24) } }
)

newGem("Amber", "object/amber.png", 4, 16, "blue", 30, 40, 4, 65,
        { mana_on_crit = 8 },
        { mana = 60 }
)
newGem("Turquoise", "object/turquoise.png", 4, 16, "green", 30, 40, 4, 65,
        { resists_pen = { all = 12 }, combat_atk = 12 },
        { splash = { desc = _t "50% chance to disarm" }, special = function(self, gem, target, dam)
            if rng.percent(50) and target:canBe("disarm") then
                if target:canBe("disarm") then
                    target:setEffect(target.EFF_DISARMED, 3, {})
                end
            end
        end }
)
newGem("Sapphire", "object/sapphire.png", 4, 16, "white", 30, 40, 4, 65,
        { combat_def = 16, combat_mentalresist = 16, combat_spellresist = 16, combat_physresist = 16, },
        { splash = { desc = _t "Deals 12% extra ice damage, may freeze or wet target." }, special = function(self, gem, target, dam)
            local DamageType = require "engine.DamageType"
            DamageType:get(DamageType.ICE).projector(self, target.x, target.y, DamageType.ICE, { dam = dam * 0.12, chance = 25, do_wet = true })
        end, })

newGem("Emerald", "object/emerald.png", 4, 16, "black", 30, 40, 4, 65,
        { resists = { all = 5 } },
        { splash = { desc = _t "Gain affinity for all damage by 5% in 3 turns (stacks for 3 times)" }, special_area = function(self, gem)
            self:setEffect(self.EFF_EMERALD_AFFINITY, 3, { stack = 1 })
        end }
)
newGem("Ruby", "object/ruby.png", 3, 12, "red", 20, 30, 3, 50,
        { inc_damage = { all = 9 }, combat_physcrit = 3, combat_mindcrit = 3, combat_spellcrit = 3, },
        { splash = { type = "FIREBURN", dam = 18, desc = ("Deals %d%% extra fireburn damage"):tformat(18) } }
)

newGem("Quartz", "object/quartz.png", 3, 12, "white", 20, 30, 3, 50,
        { stun_immune = 0.3 },
        { splash = { type = "SPELLKNOCKBACK", dam = 10, desc = ("Deals %d%% extra physical knockback damage"):tformat(10) } }
)
newGem("Lapis Lazuli", "object/lapis_lazuli.png", 3, 12, "blue", 20, 30, 3, 50,
        { mana_regen = 2 },
        { mana = 40 }
)
newGem("Onyx", "object/onyx.png", 3, 12, "black", 20, 30, 3, 50,
        { healing_factor = 0.2 },
        { splash = { desc = _t "Increases healing factor by 30% for 3 turns (stacks for 3 times)" }, special_area = function(self, gem)
            self:setEffect(self.EFF_ONYX_HEAL_ENCHANT, 3, { stack = 1 })
        end }
)
newGem("Amethyst", "object/amethyst.png", 2, 10, "yellow", 10, 20, 2, 35,
        { combat_spellspeed = 0.1 },
        { splash = { desc = _t "50% chance to cleanse one magical debuff" }, special_area = function(self, gem)
            if rng.percent(50) then
                self:removeEffectsFilter(self, { type = "magical", status = "detrimental" }, 1)
            end
        end }
)
newGem("Garnet", "object/garnet.png", 2, 10, "red", 10, 20, 2, 35,
        { inc_damage = { all = 6 }, combat_physcrit = 2, combat_mindcrit = 2, combat_spellcrit = 2, },
        { splash = { type = "FIREBURN", dam = 12, desc = ("Deals %d%% extra fireburn damage"):tformat(12) } }
)

newGem("Opal", "object/opal.png", 2, 10, "black", 10, 20, 2, 35,
        { inc_stats = { [Stats.STAT_STR] = 5, [Stats.STAT_DEX] = 5, [Stats.STAT_MAG] = 5, [Stats.STAT_WIL] = 5, [Stats.STAT_CUN] = 5, [Stats.STAT_CON] = 5, } },
        { leech = 5 }
)
newGem("Topaz", "object/topaz.png", 2, 10, "white", 10, 20, 2, 35,
        { combat_def = 10, combat_mentalresist = 10, combat_spellresist = 10, combat_physresist = 10, },
        { range = 4 }
)
newGem("Aquamarine", "object/aquamarine.png", 2, 10, "blue", 10, 20, 2, 35,
        { resists = { LIGHTNING = 30 } },
        { mana = 20 }
)
newGem("Ametrine", "object/ametrine.png", 1, 8, "yellow", 1, 10, 1, 20,
        { combat_def = 10 },
        { splash = { desc = _t "gain 20 defense for 5 turns" }, special_area = function(self, gem)
            self:setEffect(self.EFF_OUT_OF_PHASE, 5, { defense = 20 })
        end }
)
newGem("Zircon", "object/zircon.png", 1, 8, "yellow", 1, 10, 1, 20,
        { combat_armor = 10 },
        { daze = { chance = 50, dur = 2 } }
)
newGem("Spinel", "object/spinel.png", 1, 8, "green", 1, 10, 1, 20,
        { combat_def = 4, combat_mentalresist = 4, combat_spellresist = 4, combat_physresist = 4, },
        { splash = { type = "POISON", dam = 50, desc = ("Deals %d%% extra poison damage"):tformat(50) } }
)
newGem("Citrine", "object/citrine.png", 1, 8, "yellow", 1, 10, 1, 20,
        { lite = 4, infravision = 4, },
        { splash = { type = "LITE", dam = 100, desc = _t "Lights terrain (power 100)" } }
)
newGem("Agate", "object/agate.png", 1, 8, "black", 1, 10, 1, 20,
        { inc_stats = { [Stats.STAT_STR] = 2, [Stats.STAT_DEX] = 2, [Stats.STAT_MAG] = 2, [Stats.STAT_WIL] = 2, [Stats.STAT_CUN] = 2, [Stats.STAT_CON] = 2, } },
        { power = 10 }
)
