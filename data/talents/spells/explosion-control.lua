newTalent {
    name = "Throw Bomb: Beam Mode",
    type = { "spell/explosion-control", 1 },
    require = spells_req_high1,
    points = 5,
    tactical = function(self, t, aitarget)
        local damtype = self:getGemDamageType()
        local t = { ATTACK = {} }
        t.ATTACK[damtype] = 4
        return t
    end,
    mana = function(self, t)
        return math.ceil(10 * (1+ t.getInc * 0.01 * (self.consecutive_bombs or 0)))
    end,
    cooldown = 3,
    direct_hit = true,
    requires_target = true,
    callbackOnAlchemistBomb = function(self, t, tgts, talent)
        if t == talent then
            return
        end
        self:startTalentCooldown(t.id, 4)
    end,
    target = function(self, t)
        local ammo = self:hasAlchemistWeapon()
        if not ammo then
            return
        end
        return { type = "widebeam", force_max_range = true, range = self:getTalentRange(t), radius = self:getTalentRadius(t), talent = t,
        friendlyfire = false, selffire = false, }
    end,
    radius = 1,
    range = function(self, t)
        return 10
    end,
    on_pre_use = function(self, t)
        local ammo = self:hasAlchemistWeapon()
        if not ammo then
            return false
        end
        if self:knowTalent(self.T_THROW_BOMB_NEW) then
            return true
        end
    end,
    getInc = 15,
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
                dam = dam + dam * self:callTalent(self.T_EXPLOSION_EXPERT_NEW, "minmax", nb, 30)
            end
        end

        return dam * math.min(2, 1 + t.getInc * 0.01 * (self.consecutive_bombs or 0))
    end,
    bombMod = 0.8,
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
        local nb = self.consecutive_bombs or 0
        bombUtil:throwBomb(self, t, ammo, tg, x, y)
        game:playSoundNear(self, "talents/arcane")
        self.consecutive_bombs = nb + 1
        self.turn_procs.bombproc = true
        return true, { ignore_cd = true }
    end,
    callbackOnActEnd = function(self, t)
        self.consecutive_bombs = self.consecutive_bombs or 0
        if self.consecutive_bombs > 0 then
            if not self:hasProc("bombproc") then
                self:startTalentCooldown(t)
                self.consecutive_bombs = 0
            end
        end
    end,
    info = function(self, t)
        local ammo = self:hasAlchemistWeapon()
        local dam, damtype = 1, DamageType.PHYSICAL
        if ammo then
            dam, damtype = bombUtil:getBaseDamage(self, t, ammo)
        end
        local nb = self.consecutive_bombs or 0
        local futher_info = ""
        if nb > 0 then
            local ndam = dam * (math.min(2, 1 + t.getInc * 0.01 * nb))
            futher_info = ("Current Damage: %0.2f %s"):tformat(damDesc(self, damtype, ndam), DamageType:get(damtype).name)
        end
        return ([[Imbue your gem with pure mana and activate its power as a wide beam and deals %0.2f %s damage.
        This talent can be activated consecutively without going on cooldown, but making any non-instant action other than activation will put this on cooldown.
        Each successful activation will increase damage of the following beams by %d%%, up to 100%%. The mana cost of this beam will also be increased.
        Throwing bomb by any means will put this talent on cooldown for 4 turns.
        %s]]):tformat(damDesc(self, damtype, dam), DamageType:get(damtype).name, t.getInc , futher_info)
    end,
}

newTalent {
    name = "Throw Bomb: Cone Mode",
    type = { "spell/explosion-control", 1 },
    require = spells_req_high1,
    points = 5,
    no_npc_use = true,
    mana = function(self, t)
        return 15
    end,
    cooldown = 6,
    fixed_cooldown = true,
    direct_hit = true,
    requires_target = true,
    bombMod = 1.2,
    callbackOnAlchemistBomb = function(self, t, tgts, talent, x, y, startx, starty)
        if t == talent then
            for _, l in ipairs(tgts) do
                if l.target:canBe("knockback") then
                    l.target:knockback(startx or x, starty or y, 6)
                end
            end
            return
        end
        self:startTalentCooldown(t.id, 4)
    end,
    target = function(self, t)
        local ammo = self:hasAlchemistWeapon()
        if not ammo then
            return
        end
        return { type = "hit", range = self:getTalentRange(t) + (ammo and ammo.alchemist_bomb and ammo.alchemist_bomb.range or 0), talent = t }
    end,
    range = 7,
    getSpecialRadius = function(self, t)
        return 6
    end,
    on_pre_use = function(self, t)
        local ammo = self:hasAlchemistWeapon()
        if not ammo then
            return false
        end
        if self:knowTalent(self.T_THROW_BOMB_NEW) then
            return true
        end
    end,
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
                dam = dam + dam * self:callTalent(self.T_EXPLOSION_EXPERT_NEW, "minmax", nb, 44)
            end
        end
        return dam * t.bombMod
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
        local _, x, y = self:canProject(tg, x, y)
        local tg2 = { type = "cone", range = 0, radius = t.getSpecialRadius(self, t), cone_angle = 90, start_x = x, start_y = y, friendlyfire = false, talent = t }
        local x2, y2 = self:getTarget(tg2)
        if not x2 or not y2 then
            return nil
        end
        if x == x2 and y == y2 then
            return nil
        end
        bombUtil:throwBomb(self, t, ammo, tg2, x2, y2, x, y)
        game:playSoundNear(self, "talents/arcane")
        return true
    end,
    info = function(self, t)
        local ammo = self:hasAlchemistWeapon()
        local dam, damtype = 1, DamageType.PHYSICAL
        if ammo then
            dam, damtype = bombUtil:getBaseDamage(self, t, ammo)
        end
        dam = dam * t.bombMod
        return ([[Throw bomb to target location, then making it explode in a radius %d cone, dealing %0.2f %s damage and knocking them back.
        You can choose the direction of the explosion.
        You must know how to throw bomb to use this talent.
        Throwing bomb by any means will put this talent on cooldown for 4 turns.
        ]]):tformat(t.getSpecialRadius(self, t), damDesc(self, damtype, dam), DamageType:get(damtype).name)
    end,
}

newTalent {
    name = "Throw Bomb: Implosion",
    type = { "spell/explosion-control", 1 },
    require = spells_req_high1,
    points = 5,
    no_npc_use = true,
    tactical = function(self, t, aitarget)
        local damtype = self:getGemDamageType()
        local t = { ATTACK = {} }
        t.ATTACK[damtype] = 2
        return t
    end,
    mana = function(self, t)
        return 20
    end,
    bombMod = 1.4,
    cooldown = 12,
    fixed_cooldown = true,
    callbackOnAlchemistBomb = function(self, t, tgts, talent)
        if t == talent then
            return
        end
        self:startTalentCooldown(t.id, 4)
    end,
    range = function(self, t)
        return math.max(3, math.floor(self:combatTalentLimit(t, 9, 0.1, 4.1)))
    end,
    radius = function(self, t)
        return math.max(1, math.floor(self:combatTalentLimit(t, 0, 4.1, 1.9)))
    end,
    direct_hit = true,
    requires_target = true,
    target = function(self, t)
        local ammo = self:hasAlchemistWeapon()
        if not ammo then
            return
        end
        return { type = "ball", range = self:getTalentRange(t) + (ammo and ammo.alchemist_bomb and ammo.alchemist_bomb.range or 0), radius = self:getTalentRadius(t), talent = t,
        friendlyfire = false, selffire = false,}
    end,
    on_pre_use = function(self, t)
        local ammo = self:hasAlchemistWeapon()
        if not ammo then
            return false
        end
        if self:knowTalent(self.T_THROW_BOMB_NEW) then
            return true
        end
    end,
    calcFurtherDamage = function(self, t, tg, ammo, x, y, dam, tgts, grids)
        local nb = 0
        local all_tgts = 0
        -- Compare theorical AOE zone with actual zone and adjust damage accordingly
        if self:knowTalent(self.T_EXPLOSION_EXPERT_NEW) then
            if grids then
                for px, ys in pairs(grids or {}) do
                    for py, _ in pairs(ys) do
                        local tgt = game.level.map(px, py, Map.ACTOR)
                        if tgt then all_tgts = all_tgts + 1 end
                        nb = nb + 1
                    end
                end
            end
            if nb > 0 then
                dam = dam + dam * self:callTalent(self.T_EXPLOSION_EXPERT_NEW, "minmax", nb)
            end
        end
        return dam * t.getDamageRadio(self, t, all_tgts) * t.bombMod
    end,
    getDamageRadio = function(self, t, nb)
        -- 1 target 100%
        -- 3 targets 67%
        -- infinite targets 25%
        return 1 - self:combatLimit(nb, 0.75, 0, 1, 1 / 3, 3)
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
        dam = dam * t.bombMod
        local dam1 = dam * t.getDamageRadio(self, t, 1)
        local dam2 = dam * t.getDamageRadio(self, t, 2)
        local dam5 = dam * t.getDamageRadio(self, t, 5)
        local dam10 = dam * t.getDamageRadio(self, t, 10)
        return ([[Throw bomb to target location dealing at most %0.2f %s damage in radius %d.
        The damage decreases with the number of targets inside:
        - 2 : deal %0.2f damage
        - 5 : deal %0.2f damage
        - 10: deal %0.2f damage
        Throwing bomb by any means will put this talent on cooldown for 4 turns.
        ]]):tformat(damDesc(self, damtype, dam1), DamageType:get(damtype).name, self:getTalentRadius(t), damDesc(self, damtype, dam2), damDesc(self, damtype, dam5), damDesc(self, damtype, dam10))
    end,
}

newTalent {
    name = "Throw Bomb: Chain Blast",
    type = { "spell/explosion-control", 1 },
    require = spells_req_high1,
    points = 5,
    mana = function(self, t)
        return 25
    end,
    cooldown = 24,
    fixed_cooldown = true,
    tactical = function(self, t, aitarget)
        local damtype = self:getGemDamageType()
        local t = { ATTACK = {} }
        t.ATTACK[damtype] = 2
        return t
    end,
    callbackOnAlchemistBomb = function(self, t, tgts, talent)
        if t == talent then
            return
        end
        self:startTalentCooldown(t.id, 4)
    end,
    range = function(self, t)
        return 5
    end,
    radius = function(self, t)
        return util.bound(math.floor(self:getTalentLevel(t) / 2) + 1, 1, 3)
    end,
    direct_hit = true,
    requires_target = true,
    target = function(self, t)
        local ammo = self:hasAlchemistWeapon()
        if not ammo then
            return
        end
        return { type = "ball", range = self:getTalentRange(t) + (ammo and ammo.alchemist_bomb and ammo.alchemist_bomb.range or 0), radius = self:getTalentRadius(t), talent = t,
        friendlyfire = false, selffire = false}
    end,
    on_pre_use = function(self, t)
        local ammo = self:hasAlchemistWeapon()
        if not ammo then
            return false
        end
        if self:knowTalent(self.T_THROW_BOMB_NEW) then
            return true
        end
    end,
    bombMod = 0.5,
    getReduction = function(self, t, nb)
        local percent = self:combatTalentLimit(t, 5, 50, 15) / 100
        return math.ceil(100 * (1 - math.pow(1 - percent, nb or 1)))
    end,
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
                local radius = self:getTalentRadius(t)
                dam = dam + dam * self:callTalent(self.T_EXPLOSION_EXPERT_NEW, "minmax", nb, bombUtil["theoretical_nbs"][radius])
            end
        end
        local blasted_time = self.alchemy_blasts
        if not blasted_time then
            return dam
        end
        return dam * (100 - t.getReduction(self, t, blasted_time)) / 100 * t.bombMod
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
        local blasted_tgts = {}
        local to_blast_tgts
        local tgts = bombUtil:throwBomb(self, t, ammo, tg, x, y)
        self.alchemy_blasts = 1
        to_blast_tgts = tgts
        while #to_blast_tgts > 0 do
            local new_target = table.remove(to_blast_tgts, 1)
            if new_target and new_target.target:reactionToward(self) < 0 then
                new_target = new_target.target
                if not blasted_tgts[new_target] then
                    blasted_tgts[new_target] = true
                    local new_tgts = bombUtil:throwBomb(self, t, ammo, tg, new_target.x, new_target.y)
                    self.alchemy_blasts = (self.alchemy_blasts or 0) + 1
                    for _, tg in ipairs(new_tgts) do
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
        if ammo then
            dam, damtype = bombUtil:getBaseDamage(self, t, ammo)
        end
        dam = dam * t.bombMod
        return ([[Throw bomb to target location dealing %0.2f %s damage in radius %d, then make a chained blast:
        Any foe inside the explosion radius will trigger a similar explosion.
        Each successive explosion deals %d%% less damage.
        Throwing bomb by any means will put this talent on cooldown for 4 turns.
        ]]):tformat(damDesc(self, damtype, dam), DamageType:get(damtype).name, self:getTalentRadius(t), t.getReduction(self, t))
    end,
}