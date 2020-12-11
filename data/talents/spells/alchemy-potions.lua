local DamageType = require "engine.DamageType"
local Object = require "engine.Object"
local Map = require "engine.Map"
local function newPotion(t)
    t.type = { "spell/alchemy-potions", 1 }
    if not t.range then
        t.range = function(self, t)
            if self:knowTalent(self.T_THROW_BOMB_NEW) then
                return self:getTalentRange(self:getTalentFromId(self.T_THROW_BOMB_NEW))
            else
                return 5
            end
        end
    end
    t.direct_hit = true
    t.requires_target = true
    local target = t.target
    t.target = function(self, t)
        if self:isTalentActive(self.T_MANAGE_POTION_3) then
            return { type = "cone", range = 0, radius = self:getTalentRange(t), talent = t, selffire = true, player_selffire = true }
        end
        if not target then
            return { type = "hit", range = self:getTalentRange(t), talent = t }
        else
            return target(self, t)
        end
    end
    t.speed = function(self, t)
        if self:isTalentActive(self.T_MANAGE_POTION_3) then
            return self:getSpeed('spell') * self:callTalent(self.T_MANAGE_POTION_3, "getSpeedUp") / 100
        end
    end
    t.cooldown = 1
    t.max_charge = function(self, t)
        local potion = self:getPotionInfo(t)
        return potion.max or 0
    end
    t.charge = function(self, t)
        local potion = self:getPotionInfo(t)
        local nb = math.floor(potion.nb or 0)
        return nb
    end
    t.recharge = function(self, t, nb, auto)
        local potion = self:getPotionInfo(t)
        if nb < 0 then
            potion.lastUse = game.turn
        end
        if auto and nb > 0 then
            local last = potion.lastUse
            --auto restore only happens after 10 turns to slow the restore out of combat
            if not last or game.turn - 100 < last then return end
        end
        local c_nb = potion.nb or 0
        c_nb = c_nb + nb
        potion.nb = util.bound(c_nb, 0, t.max_charge(self, t))
    end
    t.on_pre_use = function(self, t)
        return t.charge(self, t) > 0
    end
    local action = t.action
    t.action = function(self, t)
        if t.charge(self, t) <= 0 then
            return
        end
        local reduce = self:isTalentActive(self.T_MANAGE_POTION_3)
        if reduce then self:attr("spellpower_reduction", 1) end
        local res = action(self, t)
        if reduce then self:attr("spellpower_reduction", -1) end
        if res then
            t.recharge(self, t, -1)
        end
        return res
    end
    t.on_learn = function(self, t)
        t.recharge(self, t, 0)
    end
    t.on_unlearn = function(self, t)
        t.recharge(self, t, 0)
    end
    t.callbackOnAct = function(self, t)
        t.recharge(self, t, 0)
    end
    t.callbackOnActBase = function(self, t)
        local potion = self:getPotionInfo(t)
        if potion.turn and potion.turn < game.turn - 100 and potion.nb < t.max_charge(self, t) then
            t.recharge(self, t, 1, true)
        else
            t.recharge(self, t, 0)
        end
    end
    t.callbackOnCombat = function(self, t, state)
        local potion = self:getPotionInfo(t)
        if state then
            potion.turn = nil
        else
            potion.turn = game.turn
        end
    end
    local info = t.info
    t.info = function(self, tc)
        --default talent level
        local fake_t = self:getTalentFromId(self.T_MANAGE_POTION_1)
        return ([[%s
        Left charges: %d]]):tformat(info(self, tc, fake_t), tc.charge(self, tc))
    end
    if not t.allowUse then
        t.allowUse = function(self, t) return true end
    end
    newTalent(t)
end

newPotion {
    name = "Smoke Bomb", short_name = "SMOKE_POTION", image = "talents/smoke_bomb.png",
    icon = "object/elixir_of_stoneskin.png",
    tactical = { DISABLE = 1, ESCAPE = 2 },
    getDuration = function(self, t)
        return math.ceil(self:combatTalentScale(t, 2, 7))
    end,
    target = function(self, t)
        return { type = "ball", range = self:getTalentRange(t), radius = 2, talent = t }
    end,
    action = function(self, t)
        local tg = self:getTalentTarget(t)
        local x, y = self:getTarget(tg)
        if not x or not y then
            return nil
        end

        self:project(tg, x, y, function(px, py)
            local e = Object.new {
                block_sight = true,
                temporary = t.getDuration(self, t),
                x = px, y = py,
                canAct = false,
                act = function(self)
                    self:useEnergy()
                    self.temporary = self.temporary - 1
                    if self.temporary <= 0 then
                        game.level.map:remove(self.x, self.y, engine.Map.TERRAIN + 2)
                        game.level:removeEntity(self)
                        game.level.map:scheduleRedisplay()
                    end
                end,
                summoner_gain_exp = true,
                summoner = self,
            }
            game.level:addEntity(e)
            game.level.map(px, py, Map.TERRAIN + 2, e)
        end, nil, { type = "dark" })

        game:playSoundNear(self, "talents/breath")
        game.level.map:redisplay()
        return true
    end,
    short_info = function(self, t)
        return ([[Throw the smoke bomb.]]):tformat(t.getDuration(self, t))
    end,
    info = function(self, t, fake_t)
        local duration = t.getDuration(self, fake_t or t)
        return ([[Throw a smoke bomb, blocking everyone's line of sight. The smoke dissipates after %d turns.]]):
        tformat(duration)
    end,
}

newPotion {
    name = "Healing Potion", icon = "object/elixir_of_the_fox.png",
    tactical = {
        HEAL = 1,
        CURE = function(self, t, target)
            local nb = 0
            for eff_id, p in pairs(self.tmp) do
                local e = self.tempeffect_def[eff_id]
                if e.status == "detrimental" then
                    if e.subtype.wound or e.subtype.poison or e.subtype.disease then
                        nb = nb + 1
                    end
                end
            end
            return nb
        end
    },
    onAIGetTarget = function(self, t)
        -- find target to heal (prefers self, usually, doesn't consider Solipsism)
        local target
        local heal, bestheal = t.getHeal(self, t), 0
        if self.max_life - self.life > 0 then
            -- check self
            target = self
            bestheal = math.min(self.max_life - self.life, heal * self.healing_factor) * (self.ai_state.self_compassion or 5)
        end
        local targets = table.keys(self:projectCollect({ type = "ball", radius = self:getTalentRange(t), talent = t }, self.x, self.y, Map.ACTOR, "friend"))
        for _, act in ipairs(targets) do
            if act and self:reactionToward(act) > 0 and not act:attr("undead") then
                local effectheal = math.min(act.max_life - act.life, heal * act.healing_factor) * (self.ai_state.ally_compassion or 1)
                if effectheal > bestheal then
                    target, bestheal = act, effectheal
                end
            end
        end
        if target and bestheal > 0 then
            return target.x, target.y, target
        end
    end,
    on_pre_use_ai = function(self, t, silent)
        return t.onAIGetTarget(self, t) and true or false
    end,
    is_heal = true, ignore_is_heal_test = true,
    getHeal = function(self, t)
        return self:combatTalentSpellDamageBase(t, 20, 300)   -- relatively low heal due to no cd & full cleanse
    end,
    action = function(self, t)
        local tg = self:getTalentTarget(t)
        local x, y = self:getTarget(tg)
        if not x or not y  then
            return nil
        end
        local targets = table.keys(self:projectCollect(tg, x, y, Map.ACTOR))
        if #targets <= 0 then return nil end
        for _, target in ipairs(targets) do
            target:attr("allow_on_heal", 1)
            target:heal(t.getHeal(self, t), self)
            target:attr("allow_on_heal", -1)
            target:removeEffectsFilter(target, function(e)
                return e.subtype.wound or e.subtype.poison or e.subtype.disease
            end, 999)
            if core.shader.active(4) then
                target:addParticles(Particles.new("shader_shield_temp", 1, { toback = true, size_factor = 1.5, y = -0.3, img = "healgreen", life = 25 }, { type = "healing", time_factor = 2000, beamsCount = 20, noup = 2.0 }))
                target:addParticles(Particles.new("shader_shield_temp", 1, { toback = false, size_factor = 1.5, y = -0.3, img = "healgreen", life = 25 }, { type = "healing", time_factor = 2000, beamsCount = 20, noup = 1.0 }))
            end
        end

        game:playSoundNear(self, "talents/heal")
        return true
    end,
    short_info = function(self, t)
        return ([[Heal and cure, rid of poison and diseases.]]):tformat()
    end,
    info = function(self, t, fake_t)
        return ([[Heal target for %d life and cure all poisons、diseases and wounds.
        The amount healed will increase with your Spellpower.]]
        ):tformat(t.getHeal(self, fake_t or t))
    end,
}

newPotion {
    name = "Fiery Wall", short_name = "FIRE_POTION", image = "talents/fire_wall.png", icon = "object/elixir_of_explosive_force.png",
    tactical = { ATTACKAREA = { Fire = 1 } },
    target = function(self, t)
        local halflength = math.floor(t.getLength(self, t) / 2)
        return { type = "wall", range = self:getTalentRange(t), halflength = halflength, talent = t, halfmax_spots = halflength + 1 }
    end,
    getDuration = function(self, t)
        return self:combatTalentScale(t, 3, 6)
    end,
    getLength = function(self, t)
        return self:combatTalentScale(t, 5, 12)
    end,
    getDamage = function(self, t)
        return self:combatTalentSpellDamageBase(t, 25, 50)
    end,
    getFireRadius = function(self, t)
        return math.ceil(self:combatTalentScale(t, 1, 2))
    end,
    getReduce = function(self, t)
        return math.ceil(self:combatTalentScale(t, 5, 20))
    end,
    action = function(self, t)
        local tg = self:getTalentTarget(t)
        local x, y = self:getTarget(tg)
        if not x or not y then
            return nil
        end

        if tg.type == "wall" then
            _, _, _, x, y = self:canProject(tg, x, y)
        end
        local fire_damage = self:spellCrit(t.getDamage(self, t))
        local fire_radius = t.getFireRadius(self, t)
        local reduce = t.getReduce(self, t)

        self:project(tg, x, y, function(px, py, tg, self)
            local oe = game.level.map(px, py, Map.TERRAIN)
            if not oe or oe.special then
                return
            end
            if not oe or oe:attr("temporary") or game.level.map:checkAllEntities(px, py, "block_move") then
                return
            end
            local e = Object.new {
                old_feat = oe, type = oe.type, subtype = oe.subtype,
                name = _t "fire wall", image = oe.image, add_mos = {{image = "fire_particle.png"}},
                desc = _t "a summoned, transparent wall of fire",
                display = '~', color = colors.LIGHT_RED, back_color = colors.RED,
                always_remember = true,
                can_pass = false,
                does_block_move = false,
                show_tooltip = true,
                block_move = false,
                block_sight = false,
                temporary = t.getDuration(self, t),
                x = px, y = py,
                canAct = false,
                dam = fire_damage,
                radius = fire_radius,
                reduce = reduce,
                act = function(self)
                    local DamageType = require "engine.DamageType"
                    local Map = require "engine.Map"
                    local tgts = table.values(self.summoner:projectCollect({ type = "ball", range = 0, radius = self.radius, friendlyfire = false, x = self.x, y = self.y }, self.x, self.y, Map.ACTOR))
                    --self.summoner.__project_source = self
                    for _, l in ipairs(tgts) do
                        local target = l.target
                        DamageType:get(DamageType.FIRE).projector(self.summoner, target.x, target.y, DamageType.FIRE, self.dam)
                        target:setEffect(target.EFF_FIRE_BURNT, 3, { reduce = self.reduce })
                    end
                    --self.summoner.__project_source = nil
                    self:useEnergy()
                    self.temporary = self.temporary - 1
                    if self.temporary <= 0 then
                        game.level.map(self.x, self.y, engine.Map.TERRAIN, self.old_feat)
                        game.level:removeEntity(self)
                        game.level.map:updateMap(self.x, self.y)
                        game.nicer_tiles:updateAround(game.level, self.x, self.y)
                    end
                end,
                summoner_gain_exp = true,
                summoner = self,
            }
            e.tooltip = mod.class.Grid.tooltip
            game.level:addEntity(e)
            game.level.map(px, py, Map.TERRAIN, e)
            game.logSeen(self, "%s conjures a wall of fire!", self:getName():capitalize())
        end)
        return true
    end,
    short_info = function(self, t)
        return _t"Create a fire wall that burns nearby foe"
    end,
    info = function(self, t, fake_t)
        return ([[Create a fiery wall of %d length that lasts for %d turns.
        Fire walls may burn any enemy in %d radius, each wall within range deals %d fire damage.
        Burnt enemy will deal %d%% less damage in 3 turns.
        Fire wall does not block movement.]]):
        tformat(t.getLength(self, fake_t or t), t.getDuration(self, fake_t or t), t.getFireRadius(self, fake_t or t), t.getDamage(self, fake_t or t), t.getReduce(self, fake_t or t))
    end,
}

newPotion {
    name = "Dissolving Acid", short_name = "ACID_POTION", image = "talents/dissolving_acid.png", icon = "object/elixir_of_avoidance.png",
    tactical = { ATTACK = { ACID = 2 }, DISABLE = 2 },
    getDamage = function(self, t) return self:combatTalentSpellDamage(t, 40, 150) end,
    getRemoveCount = function(self, t) return math.floor(self:combatTalentScale(t, 1, 3, "log")) end,
    action = function(self, t)
        local tg = self:getTalentTarget(t)
        local x, y = self:getTarget(tg)
        if not x or not y then return nil end
        self:project(tg, x, y, function(px, py)
            local target = game.level.map(px, py, Map.ACTOR)
            if not target then return end
            if target == self then return end
            local nb = t.getRemoveCount(self,t)
            DamageType:get(DamageType.ACID).projector(self, px, py, DamageType.ACID, (self:spellCrit(t.getDamage(self, t))))

            local effs = {}

            -- Go through all sustains
            for tid, act in pairs(target.sustain_talents) do
                local t = self:getTalentFromId(tid)
                if act then
                    effs[#effs+1] = {"talent", tid}
                end
            end

            for i = 1, nb do
                if #effs == 0 then break end
                local eff = rng.tableRemove(effs)

                if self:checkHit(self:combatSpellpower(), target:combatSpellResist(), 0, 95, 5) then
                    target:crossTierEffect(target.EFF_SPELLSHOCKED, self:combatSpellpower())
                    target:dispel(eff[2], self)
                end
            end

        end, nil, {type="acid"})
        game:playSoundNear(self, "talents/acid")
        return true
    end,
    short_info = function(self, t)
        return _t"Throw bottle of acid that removes sustain"
    end,
    info = function(self, t, fake_t)
        local damage = t.getDamage(self, fake_t or t)
        return ([[Acid erupts all around your target, dealing %0.1f acid damage.
		The acid attack is extremely distracting, and may remove up to %d sustains (depending on the Spell Save of the target).
		The damage and chance to remove effects will increase with your Spellpower.]]):tformat(damDesc(self, DamageType.ACID, damage), t.getRemoveCount(self, fake_t or t))
    end,
}

newPotion {
    name = "Lightning Ball", short_name = "LIGHTNING_POTION", icon = "object/elixir_of_serendipity.png",
    radius = function(self, t) return math.ceil(self:combatTalentScale(t, 1, 3)) end,
    tactical = { DISABLE = { daze = 2, blind = 2 } },
    target = function(self, t)
        return { type = "ball", range = self:getTalentRange(t), radius = self:getTalentRadius(t), talent = t }
    end,
    getDazeDuration = function(self, t) return self:combatTalentScale(t, 2, 4) end,
    getShockDuration = function(self, t) return self:combatTalentScale(t, 4, 6) end,
    action = function(self, t)
        local tg = self:getTalentTarget(t)
        local x, y = self:getTarget(tg)
        if not x or not y then return nil end
        self:projectApply(tg, x, y, Map.ACTOR, function(target)
            if target == self then return end
            if target:canBe("stun") then
                target:setEffect(target.EFF_DAZED, t.getDazeDuration(self, t), {})
            else
                target:setEffect(target.EFF_SHOCKED, t.getShockDuration(self, t), {})
            end

            if target:canBe("blind") then
                target:setEffect(target.EFF_BLINDED, t.getDazeDuration(self, t), {})
            end
        end)
        game:playSoundNear(self, "talents/lightning")
        return true
    end,
    short_info = function(self, t)
        return ([[Throw a ball of lightning, daze and blind all targets.]]):tformat()
    end,
    info = function(self, t, fake_t)
        return ([[Throw a ball of lightning of radius %d, daze and blind all targets for %d turns.
        If the target resists the daze effect it is instead shocked, which halves stun/daze/pin resistance, for %d turns.
        ]]):tformat(t.radius(self, fake_t or t), t.getDazeDuration(self, fake_t or t), t.getShockDuration(self, fake_t or t))
    end,
}

newPotion {
    name = "Breath of the Frost", short_name = "FROST_POTION", image = "talents/frost_shield.png", icon = "object/elixir_of_mysticism.png",
    tactical = { DEFEND = 3 },
    getDuration = function(self, t) return 6 end,
    getResists = function(self, t) return self:combatTalentScale(t, 5, 20) end,
    getCritShrug = function(self, t) return self:combatTalentScale(t, 15, 45) end,
    action = function(self, t)
        local tg = self:getTalentTarget(t)
        local x, y = self:getTarget(tg)
        if not x or not y then return nil end
        local targets = table.keys(self:projectCollect(tg, x, y, Map.ACTOR))
        for _, target in ipairs(targets) do
            target:setEffect(target.EFF_FROST_SHIELD, t.getDuration(self, t), { power = t.getResists(self, t), critdown = t.getCritShrug(self, t)})
        end
        return true
    end,
    short_info = function(self, t)
        return ([[Create a frost shield reducing damage and critical hits]]):tformat()
    end,
    info = function(self, t, fake_t)
        return ([[Create a frost shield in range %d, reducing %d%% all incoming damage except fire, and reducing direct critical damage by %d%%.
        Frost shield lasts %d turns.]])
                :tformat(t.range(self, fake_t or t), t.getResists(self, fake_t or t), t.getCritShrug(self, fake_t or t), t.getDuration(self, fake_t or t))
    end,
}

newPotion {
    name = "Stoned Armour", short_name = "STONE_POTION", image = "talents/stoneskin.png", icon = "object/elixir_of_invulnerability.png",
    tactical = { DEFEND = 2 },
    getDuration = function(self, t) return 6 end,
    getArmor = function(self, t) return self:combatTalentScale(t, 30, 100) end,
    allowUse = function(self, t)
        if self ~= game.player then return false end
        if config.settings.cheat then return true end
        local quest = game.player:hasQuest("brotherhood-of-alchemists")
        return quest.winner == "Ungrol of Last Hope"
    end,
    action = function(self, t)
        local tg = self:getTalentTarget(t)
        local x, y = self:getTarget(tg)
        if not x or not y then return nil end
        local targets = table.keys(self:projectCollect(tg, x, y, Map.ACTOR))
        for _, target in ipairs(targets) do
            target:setEffect(target.EFF_STONED_ARMOUR, 6, {ac=t.getArmor(self, t), hard=50})
        end
        return true
    end,
    isSpecialPotion = 5,
    short_info = function(self, t)
        return ([[Greatly enchants armor while lowering defense.]]):tformat()
    end,
    info = function(self, t, fake_t)
        return ([[Increase armor by %d , armor hardiness by %d%%, and decrease defense by %d for 6 turns.]])
        :tformat(t.getArmor(self, fake_t or t), 50, t.getArmor(self, fake_t or t))
    end,
}

newPotion {
    name = "Potion of Magic", short_name = "ARCANE_POTION", image = "talents/arcane_power.png", icon = "object/elixir_of_invulnerability.png",
    tactical = { BUFF = 3 },
    getDuration = function(self, t) return 6 end,
    getSpellpower = function(self, t) return self:combatTalentScale(t, 20, 40) end,
    getManaRegen = function(self, t) return self:combatTalentScale(t, 80, 300) end,
    allowUse = function(self, t)
        if self ~= game.player then return false end
        if config.settings.cheat then return true end
        local quest = game.player:hasQuest("brotherhood-of-alchemists")
        return quest.winner == "Marus of Elvala"
    end,
    isSpecialPotion = 5,
    action = function(self, t)
        local tg = self:getTalentTarget(t)
        local x, y = self:getTarget(tg)
        if not x or not y then return nil end
        local targets = table.keys(self:projectCollect(tg, x, y, Map.ACTOR))
        for _, target in ipairs(targets) do
            target:incMana(t.getManaRegen(self, t))
            target:setEffect(target.EFF_POTION_OF_MAGIC, 6, { power = t.getSpellpower(self, t)})
        end
        return true
    end,
    short_info = function(self, t)
        return ([[Restore mana and gain massive spellpower.]]):tformat()
    end,
    info = function(self, t, fake_t)
        return ([[Restore %d mana and gain %d spellpower in 6 turns]])
                :tformat(t.getManaRegen(self, fake_t or t), t.getSpellpower(self, fake_t or t))
    end,
}

newPotion {
    name = "Potion of Luck", short_name = "LUCK_POTION", image = "talents/lucky_day.png", icon = "object/elixir_of_invulnerability.png",
    tactical = { DEFEND = 2 },
    getDuration = function(self, t) return 6 end,
    getEvasion = function(self, t)  return self:combatTalentScale(t, 10, 25) + (self:getLck() - 50) end,
    allowUse = function(self, t)
        if self ~= game.player then return false end
        if config.settings.cheat then return true end
        local quest = game.player:hasQuest("brotherhood-of-alchemists")
        return quest.winner == "Agrimley the hermit"
    end,
    isSpecialPotion = 5,
    action = function(self, t)
        local tg = self:getTalentTarget(t)
        local x, y = self:getTarget(tg)
        if not x or not y then return nil end
        local targets = table.keys(self:projectCollect(tg, x, y, Map.ACTOR))
        for _, target in ipairs(targets) do
            target:setEffect(target.EFF_SUPER_LUCKY, 6, { power = t.getEvasion(self, t)})
        end
        return true
    end,
    short_info = function(self, t)
        return ([[Becomes super lucky and may ignore incoming damage.]]):tformat()
    end,
    info = function(self, t, fake_t)
        return ([[Becomes super lucky, have %d%% chance to ignore damage in 6 turns.
        Chance increases with your luck.]]):tformat(t.getEvasion(self, fake_t or t))
    end,
}

newPotion {
    name = "Potion of Swiftness", short_name = "SPEED_POTION", image = "talents/nimble_movements.png", icon = "object/elixir_of_invulnerability.png",
    tactical = { BUFF = 3 },
    getDuration = function(self, t) return 6 end,
    getSpeed = function(self, t) return self:combatTalentScale(t, 20, 50) end,
    getMove = function(self, t) return self:combatTalentScale(t, 100, 400) end,
    allowUse = function(self, t)
        if self ~= game.player then return false end
        if config.settings.cheat then return true end
        local quest = game.player:hasQuest("brotherhood-of-alchemists")
        return quest.winner == "Stire of Derth"
    end,
    isSpecialPotion = 5,
    action = function(self, t)
        local tg = self:getTalentTarget(t)
        local x, y = self:getTarget(tg)
        if not x or not y then return nil end
        local targets = table.keys(self:projectCollect(tg, x, y, Map.ACTOR))
        for _, target in ipairs(targets) do
            target:setEffect(target.EFF_SPEED_POTION, t.getDuration(self, t), { power = t.getMove(self, t), power_all = t.getSpeed(self, t)})
        end
        return true
    end,
    short_info = function(self, t)
        return ([[Becomes much faster than before.]]):tformat()
    end,
    info = function(self, t, fake_t)
        return ([[Becomes extremely fast, gain %d%% movement speed and %d%% global speed for %d turns.]])
                :tformat(t.getMove(self, fake_t or t), t.getSpeed(self, fake_t or t), t.getDuration(self, fake_t or t))
    end,
}


