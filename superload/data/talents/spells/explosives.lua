local _M = loadPrevious(...)

local bomb = Talents.talents_def['T_THROW_BOMB']

bomb.action = function(self, t)
    local ammo = self:hasAlchemistWeapon()
    if not ammo then
        game.logPlayer(self, "You need to ready alchemist gems in your quiver.")
        return
    end

    local tg = self:getTalentTarget(t)
    local x, y = self:getTarget(tg)
    if not x or not y then
        return nil
    end

    self:attr("no_sound", 1)
    ammo = self:removeObject(self:getInven("QUIVER"), 1)
    self:attr("no_sound", -1)
    if not ammo then
        return
    end

    local dam, damtype, particle = t.computeDamage(self, t, ammo)
    dam = self:spellCrit(dam)
    local prot = self:getTalentLevelRaw(self.T_ALCHEMIST_PROTECTION) * 0.2
    local golem
    if self.alchemy_golem then
        golem = game.level:hasEntity(self.alchemy_golem) and self.alchemy_golem or nil
    end
    local dam_done = 0

    -- Compare theorical AOE zone with actual zone and adjust damage accordingly
    if self:knowTalent(self.T_EXPLOSION_EXPERT) then
        local nb = 0
        local grids = self:project(tg, x, y, function(tx, ty)
        end)
        if grids then
            for px, ys in pairs(grids or {}) do
                for py, _ in pairs(ys) do
                    nb = nb + 1
                end
            end
        end
        if nb > 0 then
            dam = dam + dam * self:callTalent(self.T_EXPLOSION_EXPERT, "minmax", nb)
        end
    end

    local tmp = {}
    local grids = self:project(tg, x, y, function(tx, ty)
        local d = dam
        local target = game.level.map(tx, ty, Map.ACTOR)
        -- Protect yourself
        if tx == self.x and ty == self.y then
            d = dam * (1 - prot)
            -- Protect the golem
        elseif golem and tx == golem.x and ty == golem.y then
            d = dam * (1 - prot)
            if self:isTalentActive(self.T_FROST_INFUSION) and self:knowTalent(self.T_ICE_ARMOUR) then
                self:callTalent(self.T_ICE_ARMOUR, "applyEffect", golem)
            elseif self:isTalentActive(self.T_ACID_INFUSION) and self:knowTalent(self.T_CAUSTIC_GOLEM) then
                self:callTalent(self.T_CAUSTIC_GOLEM, "applyEffect", golem)
            elseif self:isTalentActive(self.T_LIGHTNING_INFUSION) and self:knowTalent(self.T_DYNAMIC_RECHARGE) then
                self:callTalent(self.T_DYNAMIC_RECHARGE, "applyEffect", golem)
            end
        else
            -- reduced damage to friendly npcs (could make random chance like friendlyfire instead)
            if target and self:reactionToward(target) >= 0 then
                d = dam * (1 - prot)
            end
        end
        if d <= 0 then
            return
        end

        --local target = game.level.map(tx, ty, Map.ACTOR)
        DamageType:get(damtype).projector(self, tx, ty, damtype, d, tmp)
        if not target then
            return
        end
        self:triggerGemEffect(target, ammo, dam)
    end)
    self:triggerGemAreaEffect(ammo, grids)

    local _
    _, x, y = self:canProject(tg, x, y)
    game.level.map:particleEmitter(x, y, tg.radius, particle, { radius = tg.radius, grids = grids, tx = x, ty = y })

    game:playSoundNear(self, "talents/arcane")
    return true
end

return _M