local DamageType = require "engine.DamageType"
local function getPotionInfo(self, t)
    local potions = self.alchemy_potions
    if not potions then
        self.alchemy_potions = {}
        potions = self.alchemy_potions
    end
    local potion = potions[t.id]
    if not potion then
        potions[t.id] = { nb = 0, turn = 0 }
        potion = potions[t.id]
    end
    return potion
end

local function newPotion(t)
    t.type = { "spell/alchemy-potions", 1 }
    if not t.range then
        t.range = function(self, t)
            if self:knowTalent(self.T_THROW_BOMB_NEW) then
                return self:getTalentRange(self.T_THROW_BOMB_NEW)
            else
                return 5
            end
        end
    end
    t.direct_hit = true
    t.requires_target = true
    if not t.target then
        t.target = function(self, t)
            return { type = "hit", range = self:getTalentRange(t), talent = t }
        end
    end
    t.cooldown = 0
    t.max_charge = function(self, t)
        return math.ceil(self:getTalentLevelRaw(t) / 2)
    end
    t.charge = function(self, t)
        local potion = getPotionInfo(self, t)
        local nb = potion.nb or 0
        return nb
    end
    t.recharge = function(self, t, nb)
        local potion = getPotionInfo(self, t)
        local c_nb = potion.nb or 0
        c_nb = math.max(0, math.min(t.max_charge(self, t), c_nb + nb))
        potion.nb = c_nb
    end
    t.on_pre_use = function(self, t)
        return t.charge(self, t) > 0
    end
    local action = t.action
    t.action = function(self, t)
        if t.charge(self, t) <= 0 then
            return
        end
        local res = action(self, t)
        if res then
            t.recharge(self, t, -1)
        end
        return res
    end
    t.on_learn = function(self, t)
        t.recharge(self, t, 1)
    end
    t.on_unlearn = function(self, t)
        t.recharge(self, t, 0)
    end
    t.callbackOnActBase = function(self, t)
        local potion = getPotionInfo(self, t)
        if potion.turn and potion.turn < game.turn - 100 and potion.nb < t.max_charge(self, t) then
            potion.recharge(self, t, 1)
        end
    end
    t.callbackOnCombat = function(self, t, state)
        local potion = getPotionInfo(self, t)
        if state then
            potion.turn = nil
        else
            potion.turn = game.turn
        end
    end
    newTalent(t)
end

newPotion {
    name = "Smoke Bomb", short_name = "SMOKE_POTION", image = "talents/smoke_bomb.png",
    tactical = { DISABLE = 1, ESCAPE = 2 },
    getDuration = function(self, t)
        return math.ceil(self:combatSpellDamageBase(t, 20, 2, 7))
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
        return ([[Throw a smoke bombo that lasts for %d turns.]]):tformat(t.getDuration(self, t))
    end,
    info = function(self, t)
        local duration = t.getDuration(self, t)
        return ([[Throw a smoke bomb, blocking everyone's line of sight. The smoke dissipates after %d turns.
        Duration will increase with your Spellpower.]]):
        tformat(duration)
    end,
}

newPotion {
    name = "Healing Potion",
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
        local x, y, target = self:getTarget(tg)
        if not target or not self:canProject(tg, x, y) then
            return nil
        end

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

        game:playSoundNear(self, "talents/heal")
        return true
    end,
    short_info = function(self, t)
        return ([[Heal %d; Cure poisons、diseases and wounds]]):tformat(t.getHeal(self, t))
    end,
    info = function(self, t)
        return ([[Heal target for %d life and cure all poisons、diseases and wounds.
        The amount healed will increase with your Spellpower.]]
        ):tformat(t.getHeal(self, t))
    end,
}

newPotion {
    name = "Fire Wall", short_name = "FIRE_POTION",
    tactical = { ATTACKAREA = { Fire = 1 } },
    getLength = function(self, t)
        return self:combatTalentScale()
    end,
    target = function(self, t)
        local halflength = math.floor(t.getLength(self, t) / 2)
        return { type = "wall", range = self:getTalentRange(t), halflength = halflength, talent = t, halfmax_spots = halflength + 1 }
    end,
    getDamage = function(self, t)
        return self:combatSpellDamageBase(t, 5, 30) + 5
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
        local _
        _, _, _, x, y = self:canProject(tg, x, y)
        if game.level.map:checkEntity(x, y, Map.TERRAIN, "block_move") then
            return nil
        end
        local fire_damage = self:spellCrit(t.getDamage(self, t))
        local fire_radius = t.getFireRadius(self, t)

        self:project(tg, x, y, function(px, py, tg, self)
            local oe = game.level.map(px, py, Map.TERRAIN)
            if not oe or oe.special then
                return
            end
            if not oe or oe:attr("temporary") or game.level.map:checkAllEntities(px, py, "block_move") then
                return
            end
            local e = Object.new {
                old_feat = oe,
                name = _t "fire wall", image = "fire_particle.png",
                desc = _t "a summoned, transparent wall of fire",
                type = "wall",
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
                act = function(self)
                    local tgts = table.values(self:projectCollect({ type = "ball", range = 0, radius = self.radius, friendlyfire = false, x = self.x, y = self.y }, self.x, self.y, Map.ACTOR))
                    self.summoner.__project_source = self
                    for _, l in ipairs(tgts) do
                        local target = l.target
                        DamageType:get(damtype).projector(self.summoner, target.x, target.y, DamageType.FIRE, self.dam)
                        target:setEffect(target.EFF_FIRE_BURNT, 3, { reduce = t.getReduce(self, t) })
                    end
                    self.summoner.__project_source = nil
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
            game.logSeen(who, "%s conjures a wall of fire!", who.name:capitalize())
        end)
        return true
    end,
    short_info = function(self, t)
        return ([[Create a fire wall; length %d; dam %d; dur %d]]):tformat(t.getLength(self, t), t.getDamage(self, t), t.getDuration(self, t))
    end,
    info = function(self, t)
        return ([[Create a fiery wall of %d length that lasts for %d turns.
        Fire walls may burn any enemy in %d radius, each wall within range deals %d fire damage.
        Burnt enemy will deal %d%% less damage in 3 turns.
        Fire wall does not block movement.]]):
        tformat(t.getLength(self, t), t.getDuration(self, t), t.getFireRadius(self, t), t.getDamage(self, t), t.getReduce(self, t))
    end,
}

newPotion {
    name = "Dissolving Acid", short_name = "ACID_POTION", image = "talents/dissolving_acid.png",
    tactical = { ATTACK = { ACID = 2 }, DISABLE = 2 },
    getDamage = function(self, t) return self:combatTalentSpellDamage(t, 40, 150) end,
    getRemoveCount = function(self, t) return math.floor(self:combatTalentScale(t, 1, 3, "log")) end,
    action = function(self, t)
        local tg = self:getTalentTarget(t)
        local x, y = self:getTarget(tg)
        if not x or not y then return nil end
        local nb = t.getRemoveCount(self,t)
        self:project(tg, x, y, function(px, py)
            local target = game.level.map(px, py, Map.ACTOR)
            if not target then return end
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
        return "This is Acid Potion"
    end,
    info = function(self, t)
        local damage = t.getDamage(self, t)
        return ([[Acid erupts all around your target, dealing %0.1f acid damage.
		The acid attack is extremely distracting, and may remove up to %d sustains (depending on the Spell Save of the target).
		The damage and chance to remove effects will increase with your Spellpower.]]):tformat(damDesc(self, DamageType.ACID, damage), t.getRemoveCount(self, t))
    end,
}

newPotion {
    name = "Lightning Ball", short_name = "LIGHTNING_POTION",
    radius = function(self, t) return math.ceil(self:combatTalentScale(t, 1, 3)) end,
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
            if self:reactionToward(target) >= 0 then return end
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
    info = function(self, t)
        return ([[Throw a ball of lightning of radius %d, daze and blind all targets for %d turns.
        If the target resists the daze effect it is instead shocked, which halves stun/daze/pin resistance, for %d turns.
        ]]):tformat(self:getTalentRadius(t), t.getDazeDuration(self, t), t.getShockDuration(self, t))
    end,
}

newPotion {
    name = "Breath of the Frost", short_name = "FROST_POTION",
    range = 0,
    radius = function(self, t)
        if self:knowTalent(self.T_THROW_BOMB_NEW) then
            return self:getTalentRange(self.T_THROW_BOMB_NEW)
        else
            return 5
        end
    end,
    getDuration = function(self, t) return 6 end,
    getResists = function(self, t) return self:combatSpellDamageBase(t, 5, 30) end,
    getCritShrug = function(self, t) return self:combatTalentScale(t, 15, 45) end,
    action = function(self, t)
        local targets = table.keys(self:projectCollect({type="ball", radius=self:getTalentRadius(t), talent=t}, self.x, self.y, Map.ACTOR, "friend"))
        for _, target in ipairs(targets) do
            target:setEffect(target.EFF_FROST_SHIELD, t.getDuration(self, t), { power = t.getResists(self, t), critdown = t.getCritShrug(self, t)})
        end
    end,
    short_info = function(self, t)
        return ([[Create a frost shield reducing damage and critical hits]]):tformat()
    end,
    info = function(self, t)
        return ([[Create a frost shield for friendly creatures and yourself in radius %d, reducing %d%% all incoming damage except fire, and reducing direct critical damage by %d%%. ]])
                :tformat(self:getTalentRadius(t), t.getResists(self, t), t.getCritShrug(self, t))
    end,
}