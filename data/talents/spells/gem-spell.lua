newTalent {
    name = "Gem Blast",
    type = { "spell/gem-spell", 1 },
    require = spells_req1,
    points = 5,
    range = 10,
    mana = -5,
    direct_hit = true,
    reflectable = true,
    requires_target = true,
    target = function(self, t)
        local ammo = self:hasAlchemistWeapon()
        if not ammo then
            return
        end
        return { type = "bolt", range = self:getTalentRange(t), talent = t, friendlyfire = false, friendlyblock = false, }
    end,
    tactical = function(self, t, aitarget)
        local damtype = self:getGemDamageType()
        local t = { ATTACK = {}, ESCAPE = { knockback = 1}, DISABLE = { knockback = 1 } }
        t.ATTACK[damtype] = 2
        return t
    end,
    cooldown = 2,
    on_pre_use = function(self, t)
        return self:hasAlchemistWeapon()
    end,
    getDamage = function(self, t)
        return self:combatTalentGemDamage(t, 40, 200)
    end,
    action = function(self, t)
        local gem = self:hasAlchemistWeapon()
        if not gem then
            game.logPlayer(self, "You need to ready gems in your quiver.")
            return
        end
        local tg = self:getTalentTarget(t)
        local x, y = self:getTarget(tg)
        if not x or not y then
            return nil
        end
        local dam = self:spellCrit(t.getDamage(self, t))
        local damtype = self:getGemDamageType()
        self:projectApply(tg, x, y, Map.ACTOR, function(target)
            if self:reactionToward(target) >= 0 then
                return
            end
            if gem.alchemist_bomb and gem.alchemist_bomb.power then
                dam = dam * (1 + gem.alchemist_bomb.power * 0.01)
            end
            DamageType:get(damtype).projector(self, target.x, target.y, damtype, dam)
            local _, x, y = self:canProject(tg, x, y)
            game.level.map:particleEmitter(self.x, self.y, math.max(math.abs(x - self.x), math.abs(y - self.y)), "light_beam", { tx = x - self.x, ty = y - self.y })
            self:triggerGemEffect(target, gem, dam)
            self:triggerGemAreaEffect(gem, self:project(tg, x, y, function(tx, ty)
            end))
            if target:checkHit(self:combatSpellpower(), target:combatPhysicalResist(), 0, 95) and target:canBe("knockback") then
                target:knockback(self.x, self.y, 2)
                target:crossTierEffect(target.EFF_OFFBALANCE, self:combatSpellpower())
                game.logSeen(target, "%s is knocked back!", target:getName():capitalize())
            end
        end)

        game:playSoundNear(self, "talents/water")
        return true
    end,
    on_learn = function(self, t)
        self:checkCanWearGem()
    end,
    on_unlearn = function(self, t)
        self:checkCanWearGem()
    end,
    info = function(self, t)
        return ([[Activate your gem's power and fire a bolt of energy to target, dealing %0.2f %s damage.
        If the bolt hits, it will trigger the special effect of gem, and knock back the target for 2 tiles.
        The damage scales with your gem tier and spellpower, and the damage type changes with your gem.
        ]]):tformat(damDesc(self, self:getGemDamageType(), t.getDamage(self, t)), _t(self:getGemDamageType():lower()))
    end,
}

newTalent {
    name = "Gem's Radiance",
    type = { "spell/gem-spell", 2 },
    require = spells_req2,
    points = 5,
    range = function(self, t)
        return math.floor(self:combatTalentScale(t, 2, 6))
    end,
    radius = function(self, t)
        return 4
    end,
    mana = -10,
    direct_hit = true,
    tactical = function(self, t, aitarget)
        local damtype = self:getGemDamageType()
        local t = { ATTACKAREA = {}, CLOSEIN = 2, }
        t.ATTACKAREA[damtype] = 2
        return t
    end,
    target = function(self, t)
        local ammo = self:hasAlchemistWeapon()
        if not ammo then
            return
        end
        return { type = "ball", range = self:getTalentRange(t) + (ammo and ammo.alchemist_bomb and ammo.alchemist_bomb.range or 0), radius = self:getTalentRadius(t), talent = t }
    end,
    cooldown = 12,
    on_pre_use = function(self, t)
        return self:hasAlchemistWeapon()
    end,
    getDamage = function(self, t)
        return self:combatTalentGemDamage(t, 30, 250)
    end,
    on_learn = function(self, t)
        self:checkCanWearGem()
    end,
    on_unlearn = function(self, t)
        self:checkCanWearGem()
    end,
    action = function(self, t)
        local gem = self:hasAlchemistWeapon()
        if not gem then
            game.logPlayer(self, "You need to ready gems in your quiver.")
            return
        end
        local tg = self:getTalentTarget(t)
        local x, y = self:getTarget(tg)
        if not x or not y then
            return nil
        end
        local _, x, y= self:canProject(tg, x, y)
        if not x or not y then
            return nil
        end
        if not self:teleportRandom(x, y, self:getTalentRadius(t)) then
            game.logSeen(self, "%s's teleport fizzles!", self:getName():capitalize())
            game:playSoundNear(self, "talents/teleport")
            return true
        end
        local dam = t.getDamage(self, t)
        local damtype = self:getGemDamageType()
        local grids = self:project(tg, x, y, function(tx, ty)
        end)
        local tgs = 0
        self:projectApply(tg, x, y, Map.ACTOR, function(target)
            if self:reactionToward(target) >= 0 then
                return
            end
            local tdam = dam
            if gem.alchemist_bomb and gem.alchemist_bomb.power then
                tdam = tdam * (1 + gem.alchemist_bomb.power * 0.01)
            end
            DamageType:get(damtype).projector(self, target.x, target.y, damtype, tdam)
            self:triggerGemEffect(target, gem, dam)
            tgs = tgs + 1
        end)
        if tgs > 0 then
            self:triggerGemAreaEffect(gem, grids)
        end

        local _, x, y = self:canProject(tg, x, y)
        game.level.map:particleEmitter(x, y, tg.radius, "ball_physical", { radius = tg.radius, tx = x, ty = y })
        game:playSoundNear(self, "talents/teleport")
        return true
    end,
    info = function(self, t)
        return ([[Invoke the power of gem, teleports you to up to %d tiles away, to a targeted location (radius %d) in line of sight.
        Then deals %0.2f %s damage to all hostile targets in that area.
        If this attack hits, it will trigger the special effect of gem.
        The damage scales with your gem tier and spellpower, and the damage type changes with your gem.
        ]]):tformat(self:getTalentRange(t), self:getTalentRadius(t), damDesc(self, self:getGemDamageType(), t.getDamage(self, t)), _t(self:getGemDamageType():lower()))
    end,
}

newTalent {
    name = "Flickering Gem",
    type = { "spell/gem-spell", 3 },
    require = spells_req3,
    points = 5,
    tactical = { DISABLE = { CONFUSION = 1 } },
    cooldown = 15,
    mana = -10,
    radius = 10,
    getDuration = function(self, t)
        return self:combatTalentScale(t, 3, 7)
    end,
    target = function(self, t)
        local ammo = self:hasAlchemistWeapon()
        if not ammo then
            return
        end
        return { selffire = true, player_selffire = true, friendlyfire = false, type = "ball", range = self:getTalentRange(t) + (ammo and ammo.alchemist_bomb and ammo.alchemist_bomb.range or 0), radius = self:getTalentRadius(t), talent = t }
    end,
    action = function(self, t)
        local gem = self:hasAlchemistWeapon()
        if not gem then
            game.logPlayer(self, "You need to ready gems in your quiver.")
            return
        end
        local tg = self:getTalentTarget(t)
        self:project(tg, self.x, self.y, DamageType.CONFUSION, {
            dur = t.getConfuseDuration(self, t),
            dam = 50,
        })
        self:triggerGemAreaEffect(gem, nil)
        game:playSoundNear(self, "talents/flame")
    end,
    info = function(self, t)
        return ([[Invoke the power of gem, making a flash of light, confuses you and other foes in radius 10 for %d turns.
        Then trigger the beneficial effect of the gem on yourself.]]):tformat(t.getDuration(self, t))
    end,

}

newTalent {
    name = "One with Gem",
    type = { "spell/gem-spell", 4 },
    require = spells_req4,
    points = 5,
    mode = "sustained",
    cooldown = 50,
    no_energy = true,
    tactical = { BUFF = 3 },
    on_learn = function(self, t)
        self:checkCanWearGem()
    end,
    on_unlearn = function(self, t)
        self:checkCanWearGem()
    end,
    getTurn = function(self, t)
        return 1
    end,
    getCost = function(self, t)
        return self:combatTalentLimit(t, 0, 12, 3)
    end,
    iconOverlay = function(self, t, p)
        if not p then
            return ""
        end
        local turn = self.turn_procs.multi and self.turn_procs.multi.trigger_gem and self.turn_procs.multi.trigger_gem.turns or 0
        if turn <= 0 then
            return ""
        end
        return tostring("#RED##{bold}#" .. turn .. "#LAST##{normal}#"), "buff_font_small"
    end,
    callbackOnDealDamage = function(self, t, val, target, dead, death_note)
        if death_note.damtype ~= self:getGemDamageType() then
            return
        end
        local gem = self:hasAlchemistWeapon()
        if not gem then
            return
        end
        if self:hasProc("trigger_gem") then
            return
        end
        local cost = t.getCost(self, t)
        if self:getMana() < cost then
            return
        end
        self:incMana(-cost)
        local proc = { val = true, turns = t.getTurn(self, t) }
        table.set(self, "turn_procs", "multi", "trigger_gem", proc)
        self:triggerGemEffect(target, gem, 0)
    end,
    activate = function(self, t)
        return {}
    end,
    deactivate = function(self, t)
        return true
    end,
    info = function(self, t)
        return ([[When you dealt damage the same type as your gem, you may trigger the special effect of your gem.
        Each trigger drains you %d mana.
        This can happen once per turn.]]):tformat(t.getCost(self, t))
    end,
}