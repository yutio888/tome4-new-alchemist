newTalent {
    name = "Throw Bomb: Cone Mode",
    type = { "spell/explosion-control", 1},
    require = spells_req1,
    points = 5,
    mana = 15,
    cooldown = 6,
    callbackOnAlchemistBomb = function(self, t, tgts, talent)
        if t == talent then return end
        self:startTalentCooldown(t.id, 4)
    end,
    target = function(self, t)
        local ammo = self:hasAlchemistWeapon()
        if not ammo then return end
        return {type="hit", range=self:getTalentRange(t)+(ammo and ammo.alchemist_bomb and ammo.alchemist_bomb.range or 0), talent=t}
    end,
    range = function(self, t) return math.max(0, math.floor(self:combatTalentLimit(t, 15, 1.1, 6.1))) end,
    getSpecialRadius = function(self, t) return 7 end,
    on_pre_use = function(self, t)
        local ammo = self:hasAlchemistWeapon()
        if not ammo then return false end
        if self:knowTalent(self.T_THROW_BOMB_NEW) then return true end
    end,
    calcFurtherDamage = function(self, t, tg, ammo, x, y, dam)
        return dam * (1 + bombUtil:getDamageBonus(self, t, math.max(8, bombUtil.theoretical_nbs[6] - 40), 6.5))
    end,
    action = function(self, t)
        local ammo = self:hasAlchemistWeapon()
        if not ammo then
            game.logPlayer(self, "You need to ready gems in your quiver.")
            return
        end

        local tg = self:getTalentTarget(t)
        local x, y = self:getTarget(tg)
        if not x or not y then return nil end
        local _, x, y = self:canProject(tg, x, y)
        local tg2 = {type="cone", range=0, radius=t.getSpecialRadius(self, t), start_x=x, start_y=y, friendlyfire=false, talent=t}
        local x2, y2 = self:getTarget(tg2)
        if not x2 or not y2 then return nil end
        if x == x2 and y == y2 then return nil end
        bombUtil:throwBomb(self, t, ammo, tg2, x2, y2, x, y)
        game:playSoundNear(self, "talents/arcane")
        return true
    end,
    info = function(self, t)
        local ammo = self:hasAlchemistWeapon()
        local dam, damtype = 1, DamageType.PHYSICAL
        if ammo then dam, damtype = bombUtil:getBaseDamage(self, t, ammo) end
        dam =  dam * (1 + bombUtil:getDamageBonus(self, t, math.max(8, bombUtil.theoretical_nbs[6] - 40), 6.5))
        return([[Throw bomb to target location, then making it explode in a radius 7 cone, dealing %0.2f %s damage.
        You can choose the direction of the cone explosion.
        You must know how to throw bomb to use this talent.
        Throwing bomb by any means will put this talent on cooldown for 4 turns.
        ]]):tformat(damDesc(self, damtype, dam), DamageType:get(damtype).name)
    end,
}

newTalent {
    name = "Throw Bomb: Chain Blast",
    type = { "spell/explosion-control", 1},
    require = spells_req1,
    points = 5,
    mana = 15,
    cooldown = 20,
    callbackOnAlchemistBomb = function(self, t, tgts, talent)
        if t == talent then return end
        self:startTalentCooldown(t.id, 4)
    end,
    range = function(self, t) return math.floor(self:combatTalentLimit(t, 15, 5.1, 9.1)) end,
    radius = function(self, t) if self:getTalentLevelRaw(t) > 4 then return 2 else return 1 end end,
    direct_hit = true,
    requires_target = true,
    target = function(self, t)
        local ammo = self:hasAlchemistWeapon()
        if not ammo then return end
        return {type="ball", range=self:getTalentRange(t)+(ammo and ammo.alchemist_bomb and ammo.alchemist_bomb.range or 0), radius=self:getTalentRadius(t), talent=t}
    end,
    on_pre_use = function(self, t)
        local ammo = self:hasAlchemistWeapon()
        if not ammo then return false end
        if self:knowTalent(self.T_THROW_BOMB_NEW) then return true end
    end,
    calcFurtherDamage = function(self, t, tg, ammo, x, y, dam)
        local blasted_time = self.alchemy_blasts
        if not blasted_time then return dam end
        return dam * (100 - t.getReduction(self, t, blasted_time)) / 100
    end,
    getReduction = function(self, t, nb)
        local percent = self:combatTalentLimit(t, 25, 70, 40)
        local current_percent = percent
        if not nb then nb = 0 end
        while nb > 0 do
            nb = nb - 1
            current_percent = (100 - current_percent) * (100 - percent) / 100
        end
        return current_percent
    end,
    action = function(self, t)
        local ammo = self:hasAlchemistWeapon()
        if not ammo then
            game.logPlayer(self, "You need to ready gems in your quiver.")
            return
        end

        local tg = self:getTalentTarget(t)
        local x, y = self:getTarget(tg)
        local blasted_tgts = {}
        local to_blast_tgts
        local tgts = bombUtil:throwBomb(self, t, ammo, tg, x, y)
        self.alchemy_blasts = 1
        to_blast_tgts = tgts
        while #to_blast_tgts > 0 do
            local new_target = table.remove(to_blast_tgts, 1)
            if new_target and new_target.target:reactionToward(self) < 0  then
                new_target = new_target.target
                if not blasted_tgts[new_target] then
                    blasted_tgts[new_target] = true
                    local new_tgts = bombUtil:throwBomb(self, t, ammo, tg, new_target.x, new_target.y)
                    self.alchemy_blasts = (self.alchemy_blasts or 0) + 1
                    for i, tg in ipairs(new_tgts) do
                        if not blasted_tgts[tg.target] then
                            if tg.target:reactionToward(self) < 0 then
                                table.insert(to_blast_tgts, tg)
                            end
                        end
                    end
                end
            end
        end
        self.alchemy_blasts = nil
        return true
    end,
    info = function(self, t)
        local ammo = self:hasAlchemistWeapon()
        local dam, damtype = 1, DamageType.PHYSICAL
        if ammo then dam, damtype = bombUtil:getBaseDamage(self, t, ammo) end
        return ([[Throw bomb to target location dealing %0.2f %s damage, then make a chained blast:
        Any foe inside the explosion radius will trigger a similar explosion.
        Each successive explosion deals %d%% less damage.
        ]]):tformat(damDesc(self, damtype, dam), DamageType:get(damtype).name, t.getReduction(self, t))
    end,
}