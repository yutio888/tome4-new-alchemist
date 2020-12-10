newTalent {
    name = "Throw Bomb: Cone Mode",
    type = { "spell/explosion-control", 1},
    require = spells_req1,
    points = 5,
    mana = 15,
    cooldown = 10,
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