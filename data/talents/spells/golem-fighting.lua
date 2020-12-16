newTalent {
    name = "Knockback", short_name = "GOLEM_KNOCKBACK_NEW", image = "talents/golem_knockback.png",
    type = { "golem/new-fighting", 1 },
    require = techs_req1,
    points = 5,
    cooldown = 10,
    range = 8,
    stamina = 10,
    requires_target = true,
    target = function(self, t)
        return { type = "hit", range = self:getTalentRange(t) }
    end,
    is_melee = true,
    getDamage = function(self, t)
        return self:combatTalentWeaponDamage(t, 0.8, 1.6)
    end,
    tactical = { ATTACK = { weapon = 2 }, DISABLE = { knockback = 1, stun = 1 } },
    getStunDuration = function(self, t)
        return self:combatTalentScale(t, 3, 7)
    end,
    getPhysicalPower = function(self, t)
        return self:combatTalentScale(t, 3, 12)
    end,
    action = function(self, t)
        if self:attr("never_move") then
            game.logPlayer(self, "Your golem cannot do that currently.")
            return
        end

        local tg = self:getTalentTarget(t)
        local olds = game.target.source_actor
        game.target.source_actor = self
        local x, y, target = self:getTarget(tg)
        game.target.source_actor = olds
        if not target then
            return nil
        end

        if self.ai_target then
            self.ai_target.target = target
        end

        if core.fov.distance(self.x, self.y, x, y) > 1 then
            tg.radius = 1
            tg.type = "ball"
            local grids = {}
            self:projectApply(tg, x, y, Map.TERRAIN, function(_, px, py)
                grids[#grids + 1] = { x = px, y = py, dist = core.fov.distance(self.x, self.y, px, py, true) }
            end, function(_, px, py)
                return
                not game.level.map:checkAllEntities(px, py, "block_move", self) and
                        self:hasLOS(px, py)
            end, nil, true)
            table.sort(grids, "dist")
            if #grids == 0 then
                return
            end
            self:forceMoveAnim(grids[1].x, grids[1].y)
        end

        -- Attack ?
        if core.fov.distance(self.x, self.y, x, y) > 1 then
            return true
        end
        local hit = self:attackTarget(target, nil, t.getDamage(self, t), true)

        -- Try to knockback !
        if hit then
            if target:checkHit(self:combatPhysicalpower(), target:combatPhysicalResist(), 0, 95) and target:canBe("knockback") then
                target:knockback(self.x, self.y, 3)
                target:crossTierEffect(target.EFF_OFFBALANCE, self:combatPhysicalpower())
            else
                game.logSeen(target, "%s resists the knockback!", target:getName():capitalize())
            end
            if target:canBe("stun") then
                -- Deprecated call to checkhitold
                target:setEffect(target.EFF_STUNNED, t.getStunDuration(self, t), { apply_power = self:combatPhysicalpower() })
            else
                game.logSeen(target, "%s resists the knockback!", target:getName():capitalize())
            end
        end

        return true
    end,
    info = function(self, t)
        local damage = t.getDamage(self, t)
        return ([[Your golem rushes to the target, dealing %d%% damage and knocking it back 3 tiles, then stun it for %d turns.
		Knockback chance and stun chance increases with your golem's physical power.
		While rushing the golem becomes ethereal, passing harmlessly through creatures on the path to its target.
		Learn this talent grants your golem %d physical power.
		]])
                :tformat(100 * damage, t.getStunDuration(self, t), t.getPhysicalPower(self, t))
    end,
}

newTalent {
    name = "Taunt", short_name = "GOLEM_TAUNT_NEW", image = "talents/golem_taunt.png",
    type = { "golem/new-fighting", 2 },
    require = techs_req2,
    points = 5,
    cooldown = function(self, t)
        return math.ceil(self:combatTalentLimit(t, 0, 18, 10, true, 1.0))
    end, -- Limit to > 0
    range = 10,
    radius = function(self, t)
        return math.floor(self:combatTalentScale(t, 1, 5))
    end,
    stamina = 10,
    requires_target = true,
    target = function(self, t)
        return { type = "ball", radius = self:getTalentRadius(t), range = self:getTalentRange(t), friendlyfire = false }
    end,
    tactical = { PROTECT = 3, DEFEND = 2 },
    getPhysicalPower = function(self, t)
        return self:combatTalentScale(t, 3, 12)
    end,
    getShield = function(self, t)
        return self:combatTalentScale(t, 50, 100)
    end,
    addShield = function(self, t)
        local shield_power = t.getShield(self, t)
        if not self:hasEffect(self.EFF_DAMAGE_SHIELD) then
            self:setEffect(self.EFF_DAMAGE_SHIELD, 2, { power = shield_power })
        else
            -- Shields can't usually merge, so change the parameters manually
            local shield = self:hasEffect(self.EFF_DAMAGE_SHIELD)
            shield.power = shield.power + shield_power
            self.damage_shield_absorb = self.damage_shield_absorb + shield_power
            self.damage_shield_absorb_max = self.damage_shield_absorb_max + shield_power
        end
    end,
    action = function(self, t)
        local tg = self:getTalentTarget(t)
        local olds = game.target.source_actor
        game.target.source_actor = self
        local x, y = self:getTarget(tg)
        game.target.source_actor = olds
        if not x or not y then
            return nil
        end

        self:project(tg, x, y, function(px, py)
            local target = game.level.map(px, py, Map.ACTOR)
            if not target then
                return
            end

            if self:reactionToward(target) < 0 then
                if self.ai_target then
                    self.ai_target.target = target
                end
                target:setTarget(self)
                self:logCombat(target, "#Source# provokes #Target# to attack it.")
                t.addShield(self, t)
            end
        end)
        return true
    end,
    info = function(self, t)
        return ([[The golem taunts targets in a radius of %d, forcing them to attack it.
        Each taunted target will give your golem a shield of %d strenth for 2 turns, or adding to current damage shield.
        Learn this talent grants your golem %d physical power.
        ]]):tformat(self:getTalentRadius(t), t.getShield(self, t), t.getPhysicalPower(self, t))
    end,
}

newTalent {
    name = "Crush", short_name = "GOLEM_CRUSH_NEW", image = "talents/golem_crush.png",
    type = { "golem/new-fighting", 3 },
    require = techs_req3,
    points = 5,
    cooldown = 10,
    range = 8,
    stamina = 10,
    requires_target = true,
    getDamage = function(self, t)
        return self:combatTalentWeaponDamage(t, 0.8, 1.6)
    end,
    getPinDuration = function(self, t)
        return math.floor(self:combatTalentScale(t, 3, 7))
    end,
    getPhysicalPower = function(self, t)
        return self:combatTalentScale(t, 3, 12)
    end,
    getSlow = function(self, t)
        return self:combatTalentLimit(t, 50, 10, 35)
    end,
    tactical = { ATTACK = { weapon = 2 }, DISABLE = { pin = 1, slow = 1 } },
    is_melee = true,
    target = function(self, t)
        return { type = "hit", range = self:getTalentRange(t) }
    end,
    action = function(self, t)
        if self:attr("never_move") then
            game.logPlayer(self, "Your golem cannot do that currently.")
            return
        end

        local tg = self:getTalentTarget(t)
        local olds = game.target.source_actor
        game.target.source_actor = self
        local x, y, target = self:getTarget(tg)
        game.target.source_actor = olds
        if not target then
            return nil
        end

        if self.ai_target then
            self.ai_target.target = target
        end

        if core.fov.distance(self.x, self.y, x, y) > 1 then
            tg.radius = 1
            tg.type = "ball"
            local grids = {}
            self:projectApply(tg, x, y, Map.TERRAIN, function(_, px, py)
                grids[#grids + 1] = { x = px, y = py, dist = core.fov.distance(self.x, self.y, px, py, true) }
            end, function(_, px, py)
                return
                not game.level.map:checkAllEntities(px, py, "block_move", self) and
                        self:hasLOS(px, py)
            end, nil, true)
            table.sort(grids, "dist")
            if #grids == 0 then
                return
            end
            self:forceMoveAnim(grids[1].x, grids[1].y)
        end

        -- Attack ?
        if core.fov.distance(self.x, self.y, x, y) > 1 then
            return true
        end
        local hit = self:attackTarget(target, nil, t.getDamage(self, t), true)

        -- Try to pin
        if hit then
            if target:canBe("pin") then
                target:setEffect(target.EFF_PINNED, t.getPinDuration(self, t), { apply_power = self:combatPhysicalpower() })
            else
                game.logSeen(target, "%s resists the crushing!", target:getName():capitalize())
            end
            if target:canBe("slow") then
                target:setEffect(target.EFF_SLOW, 3, { power = t.getSlow(self, t) * 0.01 })
            end
        end

        return true
    end,
    info = function(self, t)
        local damage = t.getDamage(self, t)
        local duration = t.getPinDuration(self, t)
        return ([[Your golem rushes to the target, crushing it into the ground for %d turns and doing %d%% damage.
        Then target will be slowed for %d%% in 3 turns.
		Pinning chance will increase with your golem's physical power.
		Learn this talent grants your golem %d physical power.
		While rushing the golem becomes ethereal, passing harmlessly through creatures on the path to its target.]]):
        tformat(duration, 100 * damage, t.getSlow(self, t), t.getPhysicalPower(self, t))
    end,
}

newTalent {
    name = "Pound", short_name = "GOLEM_POUND_NEW", image = "talents/golem_pound.png",
    type = { "golem/new-fighting", 4 },
    require = techs_req4,
    points = 5,
    cooldown = 15,
    range = 8,
    radius = 2,
    stamina = 5,
    requires_target = true,
    target = function(self, t)
        return { type = "ballbolt", radius = self:getTalentRadius(t), friendlyfire = false, range = self:getTalentRange(t) }
    end,
    getGolemDamage = function(self, t)
        return self:combatTalentWeaponDamage(t, 1, 1.5)
    end,
    getPhysicalPower = function(self, t)
        return self:combatTalentScale(t, 3, 12)
    end,
    getDazeDuration = function(self, t)
        return math.floor(self:combatTalentScale(t, 3, 7))
    end,
    tactical = { ATTACKAREA = { weapon = 1.5 }, DISABLE = { stun = 1 } },
    action = function(self, t)
        if self:attr("never_move") then
            game.logPlayer(self, "Your golem cannot do that currently.")
            return
        end

        local tg = self:getTalentTarget(t)
        local olds = game.target.source_actor
        game.target.source_actor = self
        local x, y, target = self:getTarget(tg)
        game.target.source_actor = olds
        if not target then
            return nil
        end

        if core.fov.distance(self.x, self.y, x, y) > 1 then
            tg.radius = 1
            tg.type = "ball"
            local grids = {}
            self:projectApply(tg, x, y, Map.TERRAIN, function(_, px, py)
                grids[#grids + 1] = { x = px, y = py, dist = core.fov.distance(self.x, self.y, px, py, true) }
            end, function(_, px, py)
                return
                not game.level.map:checkAllEntities(px, py, "block_move", self) and
                        self:hasLOS(px, py)
            end, nil, true)
            table.sort(grids, "dist")
            if #grids == 0 then
                return
            end
            self:forceMoveAnim(grids[1].x, grids[1].y)
        end

        if self.ai_target then
            self.ai_target.target = target
        end

        -- Attack & daze
        tg.type = "ball"
        self:project(tg, self.x, self.y, function(xx, yy)
            if xx == self.x and yy == self.y then
                return
            end
            local target = game.level.map(xx, yy, Map.ACTOR)
            if target and self:attackTarget(target, nil, t.getGolemDamage(self, t), true) then
                if target:canBe("stun") then
                    target:setEffect(target.EFF_DAZED, t.getDazeDuration(self, t), { apply_power = self:combatPhysicalpower() })
                else
                    game.logSeen(target, "%s resists the dazing blow!", target:getName():capitalize())
                end
            end
        end)

        return true
    end,
    info = function(self, t)
        local duration = t.getDazeDuration(self, t)
        local damage = t.getGolemDamage(self, t)
        return ([[Your golem rushes to the target and creates a shockwave with radius 2, dazing all foes for %d turns and doing %d%% damage.
		Daze chance increases with your golem's physical power.
		Learn this talent grants your golem %d physical power.
		While rushing the golem becomes ethereal, passing harmlessly through creatures on the path to its target.]]):
        tformat(duration, 100 * damage, t.getPhysicalPower(self, t))
    end,
}