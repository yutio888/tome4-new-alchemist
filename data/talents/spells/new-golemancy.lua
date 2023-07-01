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
local Chat = require "engine.Chat"

function getGolem(self)
    if not self.alchemy_golem then
        return nil
    end
    if game.level and game.level:hasEntity(self.alchemy_golem) then
        return self.alchemy_golem, self.alchemy_golem
    elseif self:hasEffect(self.EFF_GOLEM_MOUNT) then
        return self, self.alchemy_golem
    end
end

function makeAlchemistGolem(self)
    local g = require("mod.class.NPC").new {
        type = "construct", subtype = "golem",
        name = "golem",
        display = 'g', color = colors.WHITE, image = "npc/alchemist_golem.png",
        descriptor = { sex = "Male", race = "Construct", subrace = "Runic Golem" },
        moddable_tile = "runic_golem",
        moddable_tile_nude = 1,
        moddable_tile_base = resolvers.generic(function()
            return "base_0" .. rng.range(1, 5) .. ".png"
        end),
        --		level_range = {1, 50}, exp_worth=0,
        level_range = { 1, self.max_level }, exp_worth = 0,
        life_rating = 20,
        life_regen = 1, -- Prevent resting tedium
        never_anger = true,
        save_hotkeys = true,

        combat = { dam = 10, atk = 10, apr = 0, dammod = { str = 1 } },

        body = { INVEN = 1000, QS_MAINHAND = 1, QS_OFFHAND = 1, MAINHAND = 1, OFFHAND = 1, BODY = 1, GEM = { max = 2, stack_limit = 1 }
        , FINGER = 2, HEAD = 1, NECK = 1, BELT = 1 },

        canWearObjectCustom = function(self, o, slot)
            if o.type == "gem" and slot == "GEM" then
                if not self.summoner then
                    return _t "Golem has no master"
                end
                if not self.summoner:knowTalent(self.summoner.T_RUNIC_GOLEM_NEW) then
                    return _t "Master must know the Runic Golem talent"
                end
                if not o.material_level then
                    return _t "impossible to use this gem"
                end
                if o.material_level > self.summoner:getTalentLevelRaw(self.summoner.T_RUNIC_GOLEM_NEW) then
                    return _t "Master's Runic Golem talent too low for this gem"
                end
                return nil
            end
            local table = {
                ["HEAD"] = 2,
                ["BELT"] = 3,
                ["NECK"] = 4,
                ["FINGER"] = 5,
            }
            local req = table[slot] or 0
            if req > 0 then
                if not self.summoner then
                    return _t "Golem has no master"
                end
                local tl = self.summoner:getTalentLevelRaw(self.summoner.T_GOLEM_PORTAL_NEW)
                if req > tl then
                    return _t "Master's Customize talent too low."
                end
            end
        end,
        equipdoll = "alchemist_golem",
        is_alchemist_golem = 1,
        infravision = 10,
        rank = 3,
        size_category = 4,
        resists_cap = { all = 70 },
        inc_damage = { all = -30 },
        resolvers.talents {
            [Talents.T_ARMOUR_TRAINING] = 3,
            [Talents.T_GOLEM_ARMOUR] = 1,
            [Talents.T_WEAPON_COMBAT] = 1,
            [Talents.T_MANA_POOL] = 1,
            [Talents.T_STAMINA_POOL] = 1,
            [Talents.T_GOLEM_DESTRUCT] = 1,
        },

        resolvers.equip { id = true,
                          { type = "weapon", subtype = "battleaxe", autoreq = true, id = true, ego_chance = -1000, not_properties = { "unique" } },
                          { type = "armor", subtype = "heavy", autoreq = true, id = true, ego_chance = -1000, not_properties = { "unique" } }
        },

        talents_types = {
            ["golem/new-fighting"] = true,
            ["golem/new-arcane"] = true,
            ["golem/energy"] = true,
        },
        talents_types_mastery = {
            ["technique/combat-training"] = 0.3,
            ["golem/new-fighting"] = 0.3,
            ["golem/new-arcane"] = 0.3,
            ["golem/energy"] = 0.3,
        },
        forbid_nature = 1,
        power_source = { arcane = true },
        inscription_restrictions = { ["inscriptions/runes"] = true, },
        resolvers.inscription("RUNE:_SHIELDING", { cooldown = 14, dur = 5, power = 100 }),

        hotkey = {},
        hotkey_page = 1,
        move_others = true,

        ai = "tactical",
        ai_state = { talent_in = 1, ai_move = "move_astar", ally_compassion = 10 },
        ai_tactic = resolvers.tactic "tank",
        stats = { str = 14, dex = 12, mag = 12, con = 12 },

        -- No natural exp gain
        gainExp = function()
        end,
        forceLevelup = function(self)
            if self.summoner then
                return mod.class.Actor.forceLevelup(self, self.summoner.level)
            end
        end,

        -- Break control when losing LOS
        on_act = function(self)
            if game.player ~= self then
                return
            end
            if not self.summoner.dead and not self:hasLOS(self.summoner.x, self.summoner.y) then
                if not self:hasEffect(self.EFF_GOLEM_OFS) then
                    self:setEffect(self.EFF_GOLEM_OFS, 8, {})
                end
            else
                if self:hasEffect(self.EFF_GOLEM_OFS) then
                    self:removeEffect(self.EFF_GOLEM_OFS)
                end
            end
        end,

        on_can_control = function(self, vocal)
            if not self:hasLOS(self.summoner.x, self.summoner.y) then
                if vocal then
                    game.logPlayer(game.player, "Your golem is out of sight; you cannot establish direct control.")
                end
                return false
            end
            return true
        end,

        unused_stats = 0,
        unused_talents = 1,
        unused_generics = 1,
        unused_talents_types = 0,

        no_points_on_levelup = function(self)
            self.unused_stats = self.unused_stats + 2
            if self.level % 2 == 0 then
                self.unused_talents = self.unused_talents + 1
            end
            if self.level % 5 == 0 then
                self.unused_generics = self.unused_generics + 1
            end
        end,

        keep_inven_on_death = true,
        --		no_auto_resists = true,
        open_door = true,
        cut_immune = 1,
        blind_immune = 1,
        fear_immune = 1,
        poison_immune = 1,
        disease_immune = 1,
        stone_immune = 1,
        see_invisible = 30,
        no_breath = 1,
        can_change_level = true,
    }

    if self.alchemist_golem_is_drolem then
        g.name = _t "drolem"
        g.image = "invis.png"
        g.add_mos = { { image = "npc/construct_golem_drolem.png", display_h = 2, display_y = -1 } }
        g.moddable_tile = nil
        g:learnTalentType("golem/drolem", true)
    end

    self:attr("summoned_times", 99)

    return g
end

newTalent {
    name = "Interact with the Golem", short_name = "INTERACT_GOLEM_NEW", image = "talents/interact_golem.png",
    type = { "spell/new-golemancy-base", 1 },
    require = spells_req1,
    points = 1,
    mana = 10,
    no_energy = true,
    no_npc_use = true,
    cant_steal = true,
    no_unlearn_last = true,
    action = function(self, t)
        if not self.alchemy_golem then
            return
        end

        local on_level = false
        for x = 0, game.level.map.w - 1 do
            for y = 0, game.level.map.h - 1 do
                local act = game.level.map(x, y, Map.ACTOR)
                if act and act == self.alchemy_golem then
                    on_level = true
                    break
                end
            end
        end

        -- talk to the golem
        if game.level:hasEntity(self.alchemy_golem) and on_level then
            local chat = Chat.new("alchemist-golem", self.alchemy_golem, self, { golem = self.alchemy_golem, player = self })
            chat:invoke()
        end
        return true
    end,
    info = function(self, t)
        return ([[Interact with your golem to check its inventory, talents, ...
		Note: You can also do that while taking direct control of the golem.]]):
        tformat()
    end,
}

newTalent {
    name = "Refit Golem", short_name = "REFIT_GOLEM_NEW", image = "talents/refit_golem.png",
    type = { "spell/new-golemancy-base", 1 },
    autolearn_talent = "T_INTERACT_GOLEM_NEW",
    require = spells_req1,
    points = 1,
    cooldown = 20,
    mana = 10,
    cant_steal = true,
    no_npc_use = true,
    no_unlearn_last = true,
    on_pre_use = function(self, t)
        return not self.resting
    end,
    getHeal = function(self, t)
        if not self.alchemy_golem then
            return 0
        end
        local ammo = self:hasAlchemistWeapon()

        --	Heal fraction of max life for higher levels
        local healbase = 44 + self.alchemy_golem.max_life * self:combatTalentLimit(self:getTalentLevel(self.T_GOLEM_POWER_NEW), 0.2, 0.01, 0.05) -- Add up to 20% of max life to heal
        return healbase + self:combatTalentSpellDamage(self.T_GOLEM_POWER_NEW, 15, 550, self:combatSpellpower(1, (ammo and (ammo.material_level or 1) * 20))) --I5
    end,
    on_learn = function(self, t)
        self:checkCanWearGem()
        if self:getTalentLevelRaw(t) == 1 and not self.innate_alchemy_golem then
            t.invoke_golem(self, t)
        end
    end,
    on_unlearn = function(self, t)
        if self:getTalentLevelRaw(t) == 0 and self.alchemy_golem and not self.innate_alchemy_golem then
            if game.party:hasMember(self) and game.party:hasMember(self.alchemy_golem) then
                game.party:removeMember(self.alchemy_golem)
            end
            self.alchemy_golem:disappear()
            self.alchemy_golem = nil
        end
        self:checkCanWearGem()
    end,
    invoke_golem = function(self, t)
        self.alchemy_golem = game.zone:finishEntity(game.level, "actor", makeAlchemistGolem(self))
        if game.party:hasMember(self) then
            game.party:addMember(self.alchemy_golem, {
                control = "full", type = "golem", title = _t "Golem", important = true,
                orders = { target = true, leash = true, anchor = true, talents = true, behavior = true },
            })
        end
        if not self.alchemy_golem then
            return
        end
        self.alchemy_golem.faction = self.faction
        self.alchemy_golem.name = ("%s (servant of %s)"):tformat(_t(self.alchemy_golem.name), self:getName())
        self.alchemy_golem.summoner = self
        self.alchemy_golem.summoner_gain_exp = true

        -- Find space
        local x, y = util.findFreeGrid(self.x, self.y, 5, true, { [Map.ACTOR] = true })
        if not x then
            game.logPlayer(self, "Not enough space to refit!")
            return
        end
        game.zone:addEntity(game.level, self.alchemy_golem, "actor", x, y)
    end,
    action = function(self, t)
        if not self.alchemy_golem then
            t.invoke_golem(self, t)
            return
        end

        local wait = function()
            local co = coroutine.running()
            local ok = false
            self:restInit(20, _t "refitting", _t "refitted", function(cnt, max)
                if cnt > max then
                    ok = true
                end
                coroutine.resume(co)
            end)
            coroutine.yield()
            if not ok then
                game.logPlayer(self, "You have been interrupted!")
                return false
            end
            return true
        end

        local ammo = self:hasAlchemistWeapon()

        local on_level = false
        for x = 0, game.level.map.w - 1 do
            for y = 0, game.level.map.h - 1 do
                local act = game.level.map(x, y, Map.ACTOR)
                if act and act == self.alchemy_golem then
                    on_level = true
                    break
                end
            end
        end

        if game.level:hasEntity(self.alchemy_golem) and on_level and self.alchemy_golem.life >= self.alchemy_golem.max_life then
            -- nothing
            return nil
            -- heal the golem
        elseif ((game.level:hasEntity(self.alchemy_golem) and on_level) or self:hasEffect(self.EFF_GOLEM_MOUNT)) and self.alchemy_golem.life < self.alchemy_golem.max_life then
            if not ammo then
                game.logPlayer(self, "You need to ready gems in your quiver to heal your golem.")
                return
            end
            self.alchemy_golem:attr("allow_on_heal", 1)
            self.alchemy_golem:heal(t.getHeal(self, t), self)
            self.alchemy_golem:attr("allow_on_heal", -1)
            if core.shader.active(4) then
                self.alchemy_golem:addParticles(Particles.new("shader_shield_temp", 1, { toback = true, size_factor = 1.5, y = -0.3, img = "healarcane", life = 25 }, { type = "healing", time_factor = 2000, beamsCount = 20, noup = 2.0, beamColor1 = { 0x8e / 255, 0x2f / 255, 0xbb / 255, 1 }, beamColor2 = { 0xe7 / 255, 0x39 / 255, 0xde / 255, 1 }, circleDescendSpeed = 4 }))
                self.alchemy_golem:addParticles(Particles.new("shader_shield_temp", 1, { toback = false, ize_factor = 1.5, y = -0.3, img = "healarcane", life = 25 }, { type = "healing", time_factor = 2000, beamsCount = 20, noup = 1.0, beamColor1 = { 0x8e / 255, 0x2f / 255, 0xbb / 255, 1 }, beamColor2 = { 0xe7 / 255, 0x39 / 255, 0xde / 255, 1 }, circleDescendSpeed = 4 }))
            end

            -- resurrect the golem
        elseif not self:hasEffect(self.EFF_GOLEM_MOUNT) then
            if not ammo then
                game.logPlayer(self, "You need to ready gems in your quiver to heal your golem.")
                return
            end
            if not wait() then
                return
            end
            self.alchemy_golem.dead = nil
            if self.alchemy_golem.life < 0 then
                self.alchemy_golem.life = self.alchemy_golem.max_life / 3
            end

            -- Find space
            local x, y = util.findFreeGrid(self.x, self.y, 5, true, { [Map.ACTOR] = true })
            if not x then
                game.logPlayer(self, "Not enough space to refit!")
                return
            end
            game.zone:addEntity(game.level, self.alchemy_golem, "actor", x, y)
            self.alchemy_golem:setTarget(nil)
            self.alchemy_golem.ai_state.tactic_leash_anchor = self
            self.alchemy_golem:removeAllEffects()
            self.alchemy_golem.max_level = self.max_level
            self.alchemy_golem:forceLevelup(new_level)
        end

        game:playSoundNear(self, "talents/arcane")
        return true
    end,
    -- This is an all-catch talent, and it is auto-learned on anything involving golems, so this is a good place to stick that onto
    callbackOnLevelup = function(self, t, new_level)
        local _, golem = getGolem(self)
        if not golem then
            return
        end
        golem.max_level = self.max_level
        golem:forceLevelup(new_level)
    end,
    info = function(self, t)
        local heal = t.getHeal(self, t)
        return ([[Take care of your golem:
		- If it is destroyed, you will take some time to reconstruct it (this takes 20 turns).
		- If it is alive but hurt, you will be able to repair it for %d . Spellpower, gem and Golem Power talent all influence the healing done.]]):
        tformat(heal)
    end,
}

newTalent {
    name = "Gem Golem", short_name = "GEM_GOLEM_NEW", image = "talents/gem_golem.png",
    type = { "spell/other", 1 },
    mode = "passive",
    points = 1,
    cant_steal = true,
    getGemNB = function(self, t)
        local nb = 0
        for inven_id, inven in pairs(self.inven) do
            if inven.worn then
                for item, o in ipairs(inven) do
                    if o and item and o.type == "gem" then
                        nb = nb + o.material_level or 1
                    end
                end
            end
        end
        return nb
    end,
    passives = function(self, t, p)
        local nb = t.getGemNB(self, t)
        self:talentTemporaryValue(p, "combat_armor", nb * 3)
        self:talentTemporaryValue(p, "resists", { all = nb })
    end,
    callbackOnWear = function(self, t, o, bypass_set)
        self:updateTalentPassives(t)
    end,
    callbackOnTakeoff = function(self, t, o, bypass_set)
        self:updateTalentPassives(t)
    end,
    on_learn = function(self, t)
        self:updateTalentPassives(t)
    end,
    info = function(self, t)
        return ([[Golem's armor is increased by 3 per gem's tier, and resistance is increased by 1 per gem's tier.]]):tformat()
    end,

}

newTalent {
    name = "Golem Power", short_name = "GOLEM_POWER_NEW",
    type = { "spell/new-golemancy", 1 },
    mode = "passive",
    require = spells_req1,
    points = 5,
    cant_steal = true,
    no_unlearn_last = true,
    getHealingFactor = function(self, t)
        return self:combatTalentLimit(t, 2, 0.4, 1)
    end,
    autolearn_talent = "T_REFIT_GOLEM_NEW",
    on_learn = function(self, t)
        if not self.alchemy_golem then
            return
        end -- Safety net
        self.alchemy_golem:learnTalent(Talents.T_WEAPON_COMBAT, true, nil, { no_unlearn = true })
        self.alchemy_golem:learnTalent(Talents.T_STAFF_MASTERY, true, nil, { no_unlearn = true })
        self.alchemy_golem:learnTalent(Talents.T_KNIFE_MASTERY, true, nil, { no_unlearn = true })
        self.alchemy_golem:learnTalent(Talents.T_WEAPONS_MASTERY, true, nil, { no_unlearn = true })
        self.alchemy_golem:learnTalent(Talents.T_EXOTIC_WEAPONS_MASTERY, true, nil, { no_unlearn = true })

        self.alchemy_golem:learnTalent(Talents.T_THICK_SKIN, true, nil, { no_unlearn = true })
        self.alchemy_golem:learnTalent(Talents.T_GOLEM_ARMOUR, true, nil, { no_unlearn = true })
    end,
    on_unlearn = function(self, t)
        if not self.alchemy_golem then
            return
        end -- Safety net
        self.alchemy_golem:unlearnTalent(Talents.T_WEAPON_COMBAT, nil, nil, { no_unlearn = true })
        self.alchemy_golem:unlearnTalent(Talents.T_STAFF_MASTERY, nil, nil, { no_unlearn = true })
        self.alchemy_golem:unlearnTalent(Talents.T_KNIFE_MASTERY, nil, nil, { no_unlearn = true })
        self.alchemy_golem:unlearnTalent(Talents.T_WEAPONS_MASTERY, nil, nil, { no_unlearn = true })
        self.alchemy_golem:unlearnTalent(Talents.T_EXOTIC_WEAPONS_MASTERY, nil, nil, { no_unlearn = true })
        self.alchemy_golem:unlearnTalent(Talents.T_THICK_SKIN, nil, nil, { no_unlearn = true })
        self.alchemy_golem:unlearnTalent(Talents.T_GOLEM_ARMOUR, nil, nil, { no_unlearn = true })
    end,
    passives = function(self, t, p)
        if not self.alchemy_golem then
            return
        end -- Safety net
        self:talentTemporaryValue(p, "alchemy_golem", { healing_factor = t.getHealingFactor(self, t) })
    end,
    info = function(self, t)
        if not self.alchemy_golem then
            return _t "Improves your golem's proficiency with weapons, increasing its attack and damage. Then Improves your golem's armour training, damage resistance, and healing efficiency."
        end
        local rawlev = self:getTalentLevelRaw(t)
        local olda, oldd = self.alchemy_golem.talents[Talents.T_WEAPON_COMBAT], self.alchemy_golem.talents[Talents.T_WEAPONS_MASTERY]
        self.alchemy_golem.talents[Talents.T_WEAPON_COMBAT], self.alchemy_golem.talents[Talents.T_WEAPONS_MASTERY] = 1 + rawlev, rawlev
        local ta, td = self:getTalentFromId(Talents.T_WEAPON_COMBAT), self:getTalentFromId(Talents.T_WEAPONS_MASTERY)
        local attack = ta.getAttack(self.alchemy_golem, ta)
        local power = td.getDamage(self.alchemy_golem, td)
        local damage = td.getPercentInc(self.alchemy_golem, td)
        self.alchemy_golem.talents[Talents.T_WEAPON_COMBAT], self.alchemy_golem.talents[Talents.T_WEAPONS_MASTERY] = olda, oldd

        local oldh, olda = self.alchemy_golem.talents[Talents.T_THICK_SKIN], self.alchemy_golem.talents[Talents.T_GOLEM_ARMOUR]
        self.alchemy_golem.talents[Talents.T_THICK_SKIN], self.alchemy_golem.talents[Talents.T_GOLEM_ARMOUR] = rawlev, 1 + rawlev
        local th, ta, ga = self:getTalentFromId(Talents.T_THICK_SKIN), self:getTalentFromId(Talents.T_ARMOUR_TRAINING), self:getTalentFromId(Talents.T_GOLEM_ARMOUR)
        local res = th.getRes(self.alchemy_golem, th)
        local heavyarmor = ta.getArmor(self.alchemy_golem, ta) + ga.getArmor(self.alchemy_golem, ga)
        local hardiness = ta.getArmorHardiness(self.alchemy_golem, ta) + ga.getArmorHardiness(self.alchemy_golem, ga)
        local crit = ta.getCriticalChanceReduction(self.alchemy_golem, ta) + ga.getCriticalChanceReduction(self.alchemy_golem, ga)
        self.alchemy_golem.talents[Talents.T_THICK_SKIN], self.alchemy_golem.talents[Talents.T_GOLEM_ARMOUR] = oldh, olda
        return ([[Improves your golem's proficiency with weapons, increasing its Accuracy by %d, Physical Power by %d and damage by %d%%.
		Then improves your golem's armour training, damage resistance, and healing efficiency.
        Increases all damage resistance by %d%%; increases Armour value by %d, Armour hardiness by %d%%, reduces chance to be critically hit by %d%% when wearing heavy mail or massive plate armour, and increases healing factor by %d%%.
        The golem can always use any kind of armour, including massive armours.]]):
        tformat(attack, power, 100 * damage, res, heavyarmor, hardiness, crit, t.getHealingFactor(self, t) * 100)
    end,
}

newTalent {
    name = "Runic Golem", short_name = "RUNIC_GOLEM_NEW",
    type = { "spell/new-golemancy", 2 },
    require = spells_req2,
    mode = "passive",
    points = 5,
    cant_steal = true,
    no_unlearn_last = true,
    on_learn = function(self, t)
        if not self.alchemy_golem then
            return
        end -- Safety net
        self.alchemy_golem.life_regen = self.alchemy_golem.life_regen + 1
        self.alchemy_golem.mana_regen = self.alchemy_golem.mana_regen + 1
        self.alchemy_golem.stamina_regen = self.alchemy_golem.stamina_regen + 1
        local lev = self:getTalentLevelRaw(t)
        if lev == 1 or lev == 3 or lev == 5 then
            self.alchemy_golem.max_inscriptions = self.alchemy_golem.max_inscriptions + 1
            self.alchemy_golem.inscriptions_slots_added = self.alchemy_golem.inscriptions_slots_added + 1
        end
        if not self.alchemy_golem:knowTalent(self.T_GEM_GOLEM_NEW) then
            self.alchemy_golem:learnTalent(self.T_GEM_GOLEM_NEW, true)
        end
        if not self.alchemy_golem:attr("gem related talents") then
            self.alchemy_golem:attr("gem related talents", 1)
        end
    end,
    on_unlearn = function(self, t)
        if not self.alchemy_golem then
            return
        end -- Safety net
        self.alchemy_golem.life_regen = self.alchemy_golem.life_regen - 1
        self.alchemy_golem.mana_regen = self.alchemy_golem.mana_regen - 1
        self.alchemy_golem.stamina_regen = self.alchemy_golem.stamina_regen - 1
        local lev = self:getTalentLevelRaw(t)
        if lev == 0 or lev == 2 or lev == 4 then
            self.alchemy_golem.max_inscriptions = self.alchemy_golem.max_inscriptions - 1
            self.alchemy_golem.inscriptions_slots_added = self.alchemy_golem.inscriptions_slots_added - 1
        end
        if lev == 0 and self.alchemy_golem:knowTalent(self.T_GEM_GOLEM_NEW) then
            self.alchemy_golem:unlearnTalentFull(self.T_GEM_GOLEM_NEW)
        end
    end,
    info = function(self, t)
        return ([[Insert a pair of gems into your golem, providing it with the gem bonuses and changing its melee attack damage type. You may remove the gems and insert different ones; this does not destroy the gems you remove.
        Gem level usable: %d
        Gem changing is done in the golem's inventory.
        Each gem will proivide extra armour and all damage resistance which increases with tier.
        Increases your golem's life, mana and stamina regeneration rates by %0.2f.
        At level 1, 3 and 5, the golem also gains a new rune slot.
        Even without this talent, Golems start with three rune slots.]]):
        tformat(self:getTalentLevelRaw(t), self:getTalentLevelRaw(t))
    end,
}

newTalent {
    name = "Double Heal",
    type = { "spell/new-golemancy", 3 },
    require = spells_req3,
    points = 5,
    mana = 20,
    cooldown = 15,
    cant_steal = true,
    tactical = { HEAL = 2 },
    getHeal = function(self, t)
        return self:combatTalentSpellDamage(t, 15, 500)
    end,
    action = function(self, t)
        local heal = self:spellCrit(t.getHeal(self, t))
        self:attr("allow_on_heal", 1)
        self:heal(heal, self)
        self:attr("allow_on_heal", -1)
        local golem = self.alchemy_golem
        -- ressurect the golem
        if not game.level:hasEntity(golem) or golem.dead then
            golem.dead = nil

            -- Find space
            local x, y = util.findFreeGrid(self.x, self.y, 5, true, { [Map.ACTOR] = true })
            if not x then
                game.logPlayer(self, "Not enough space to resurrect!")
                return true
            end
            game.zone:addEntity(game.level, golem, "actor", x, y)
            golem:setTarget(nil)
            golem.ai_state.tactic_leash_anchor = self
            golem:removeAllEffects()
            golem.max_level = self.max_level
            golem:forceLevelup(self.level)
            golem.life = golem.max_life / 2
            return true
        end

        golem:setEffect(golem.EFF_DAMAGE_SHIELD, 5, { power = heal / 2 })
        golem:attr("allow_on_heal", 1)
        golem:heal(heal, self)
        golem:attr("allow_on_heal", -1)
        game:playSoundNear(self, "talents/arcane")
        return true
    end,
    info = function(self, t)
        local power = t.getHeal(self, t)
        return ([[You invoke the power of your gem, healing you and your golem for %d.
        If your golem is dead, it will be resurrected at 50%% life.
        If your golem is active, it will gain a shield which can absorb %d damage for 5 turns.]]):
        tformat(power, power / 2)
    end,
}

newTalent {
    name = "Golem Portal", short_name = "DYNAMIC_RECHARGE_NEW", image = "talents/dodging_new.png",
    type = { "spell/new-golemancy", 4 },
    require = spells_req4,
    points = 5,
    mana = 30,
    cant_steal = true,
    tactical = { DEFEND = 2, ESCAPE = 2 },
    getDuration = function(self, t)
        return math.floor(self:combatTalentLimit(t, 8, 2, 5))
    end, -- Limit < 8
    cooldown = function(self, t)
        return math.ceil(self:combatTalentLimit(t, 8, 25, 15))
    end, -- Limit to > 8
    action = function(self, t)
        local mover, golem = getGolem(self)
        if not golem then
            game.logPlayer(self, "Your golem is currently inactive.")
            return
        end

        local chance = math.min(100, self:getTalentLevel(t) * 15 + 25)
        local px, py = self.x, self.y
        local gx, gy = golem.x, golem.y

        self:move(gx, gy, true)
        golem:move(px, py, true)
        self:move(gx, gy, true)
        golem:move(px, py, true)
        game.level.map:particleEmitter(px, py, 1, "teleport")
        game.level.map:particleEmitter(gx, gy, 1, "teleport")

        for uid, e in pairs(game.level.entities) do
            if e.getTarget then
                local _, _, tgt = e:getTarget()
                if e:reactionToward(self) < 0 and tgt == self and rng.percent(chance) then
                    e:setTarget(golem)
                    golem:logCombat(e, "#Target# focuses on #Source#.")
                end
            end
        end

        self:setEffect(self.EFF_EVASION, t.getDuration(self, t), { chance = 50 })
        golem:setEffect(golem.EFF_EVASION, t.getDuration(self, t), { chance = 50 })
        return true
    end,
    info = function(self, t)
        return ([[Teleport to your golem, while your golem teleports to your location. Your foes will be confused, and those that were attacking you will have a %d%% chance to target your golem instead.
        After teleportation, you and your golem gain 50%% evasion for %d turns.]]):
        tformat(math.min(100, self:getTalentLevel(t) * 15 + 25), t.getDuration(self, t))
    end,
}
--newTalent{
--	name = "Dynamic Recharge", short_name = "DYNAMIC_RECHARGE_NEW",
--	type = {"spell/new-golemancy",4},
--	require = spells_req4,
--    mode = "passive",
--	points = 5,
--	getChance = function(self, t) return math.floor(self:combatTalentLimit(t, 100, 35, 75)) end,
--	getNb = function(self, t) return self:getTalentLevel(t) <= 5 and 1 or 2 end,
--	callbackOnAlchemistBomb = function(self, t, tgts)
--	    for _, l in ipairs(tgts) do
--	        local target = l.target
--	        local golem = self.alchemy_golem
--	        if target == self.alchemy_golem then
--	            local tids = table.keys(golem.talents_cd)
--    		    local did_something = false
--    		    local nb = t.getNb(self, t)
--    		    for _, tid in ipairs(tids) do
--    			    if golem.talents_cd[tid] > 0 and rng.percent(t.getChance(self, t)) then
--    			    	golem.talents_cd[tid] = golem.talents_cd[tid] - nb
--    				    if golem.talents_cd[tid] <= 0 then golem.talents_cd[tid] = nil end
--    			    	did_something = true
--    			    end
--    		    end
--    		    if did_something then
--    			    game.logSeen(golem, "%s is energized by the attack, reducing some talent cooldowns!", golem.name:capitalize())
--    		    end
--    		    return
--    		end
--        end
--	end,
--	info = function(self, t)
--		return ([[Your bombs energize your golem.
--		All talents on cooldown on your golem have %d%% chance to be reduced by %d.]]):
--		tformat(t.getChance(self, t), t.getNb(self, t))
--	end,
--}
