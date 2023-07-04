local storms = {
    fire = "firestorm",
    cold = "icestorm",
    lightning = "lightningstorm",
    acid="acidstorm",
    light="lightstorm",
    darkness="darkstorm",
    arcane = "arcanestorm",
    physical = "physicalstorm",
}
local function getElementalStorm(self)
    if self:knowTalent(self.T_ELEMENTAL_INFUSION) and self.elemental_infusion then
        local type = self.elemental_infusion
        return storms[type] or "firestorm"
    end
    return "firestorm"
end

newTalent {
    name = "Manage Elemental Infusion", image = "talents/elemental_infusion.png",
    type = { "spell/other", 1 },
    points = 1,
    cooldown = 5,
    cant_steal = true,
    no_npc_use = true,
    action = function(self, t)
        local oldtype = bombUtil:getElementalInsufionType(self)
        local Chat = require "engine.Chat"
        local chat = Chat.new("choose-elemental_infusion", { name = _t "Choose your element" }, game.player)

        local d = chat:invoke()

        self:talentDialog(d)
        local newtype = bombUtil:getElementalInsufionType(self)
        if oldtype ~= newtype then
            game.logPlayer(self, "You have changed your infusion to %s", DamageType:get(newtype).name)
            bombUtil:playSound(self)
            return true
        else
            return false
        end
    end,
    info = function(self, t)
        return ([[Manage your elemental infusion. Your current infusion is %s.]]):tformat(DamageType:get(bombUtil:getElementalInsufionType(self)).name)
    end,
}

newTalent {
    name = "Elemental Infusion",
    type = { "spell/elemental-alchemy", 1 },
    mode = "passive",
    require = spells_req_high1,
    points = 5,
    autolearn_talent = "T_MANAGE_ELEMENTAL_INFUSION",
    getIncrease = function(self, t)
        return self:combatTalentScale(t, 5, 25)
    end,
    passives = function(self, t, ret)
        local type = bombUtil:getElementalInsufionType(self)
        if type then
            self:talentTemporaryValue(ret, "inc_damage", { [type] = t.getIncrease(self, t) })
            if self:knowTalent(self.T_BODY_OF_ELEMENT) then
                self:talentTemporaryValue(ret, "resists", { [type] = self:callTalent(self.T_BODY_OF_ELEMENT, "getResist") })
                self:talentTemporaryValue(ret, "resists_pen", { [type] = self:callTalent(self.T_BODY_OF_ELEMENT, "getResistPen") })
            end
        end
    end,
    on_learn = function(self, t)
        if not self.elemental_infusion then
            self.elemental_infusion = "fire"
        end
    end,
    on_unlearn = function(self, t)

    end,
    info = function(self, t)
        local daminc = t.getIncrease(self, t)
        return ([[When you throw your alchemist bombs, you infuse them with %s.
		In addition, %s damage you do is increased by %d%% .
		You may choose your infusion in following elements: fire, cold, lightning, acid, light, darkness, arcane, physical.]]):
        tformat(_t(self.elemental_infusion) or _t "fire", _t(self.elemental_infusion) or _t "fire", daminc)
    end,
}

newTalent {
    name = "Infusion Enchantment",
    type = { "spell/elemental-alchemy", 2 },
    mode = "passive",
    require = spells_req_high2,
    points = 5,
    cooldown = function(self, t)
        return 12
    end,
    getChance = function(self, t)
        return math.floor(math.min(100, self:combatTalentScale(t, 25, 90)))
    end,
    getDuration = function(self, t)
        return math.floor(self:combatTalentScale(t, 1, 3))
    end,
    callbackOnAlchemistBomb = function(self, t, targets, tt, x, y, startx, starty, crit)
        if self:isTalentCoolingDown(t) then
            return
        end
        if not crit then
            return
        end
        local chance = t.getChance(self, t)
        if not rng.percent(chance) then
            return
        end
        if not self:hasProc("infusion_delay_trigger") then
            self:setProc("infusion_delay_trigger", 1)
            game:onTickEnd(self:startTalentCooldown(t))
        else
            return
        end
        local type = bombUtil:getElementalInsufionType(self)
        local dur = t.getDuration(self, t)
        for _, l in ipairs(targets) do
            local target = l.target
            if target and target:reactionToward(self) < 0 then
                if type == DamageType.FIRE then
                    if target:canBe("stun") then
                        target:setEffect(target.EFF_STUNNED, dur, { src = self, apply_power = self:combatSpellpower() })
                    end
                elseif type == DamageType.COLD then
                    if target:canBe("pin") then
                        target:setEffect(target.EFF_FROZEN_FEET, dur, { src = self, apply_power = self:combatSpellpower() })
                    end
                elseif type == DamageType.ACID then
                    if target:canBe("disarm") then
                        target:setEffect(target.EFF_DISARMED, dur, { src = self, apply_power = self:combatSpellpower() })
                    end
                elseif type == DamageType.LIGHTNING then
                    if target:canBe("stun") then
                        target:setEffect(target.EFF_DAZED, dur, { src = self, apply_power = self:combatSpellpower() })
                    end
                elseif type == DamageType.LIGHT then
                    if target:canBe("blind") then
                        target:setEffect(target.EFF_BLINDED, dur, { src = self, apply_power = self:combatSpellpower() })
                    end
                elseif type == DamageType.DARKNESS then
                    target:setEffect(target.EFF_ITEM_NUMBING_DARKNESS, dur, { reduce = 30, src = self, apply_power = self:combatSpellpower() })
                elseif type == DamageType.ARCANE then
                    if target:canBe("silence") then
                        target:setEffect(target.EFF_SILENCED, dur, { src = self, apply_power = self:combatSpellpower() })
                    end
                else
                    if target:canBe("slow") then
                        target:setEffect(target.EFF_SLOW, dur, {power=0.3, src = self, apply_power = self:combatSpellpower()})
                    end
                end
            end
        end
    end,
    info = function(self, t)
        return ([[If your alchemist bomb crits, it will have a %d%% chance to disable your foes for %d turns, the inflicted effect changes with your elemental infusion:
        -- Fire: Stun
        -- Cold: Frozen feet
        -- Acid: Disarm
        -- Lightning: Daze
        -- Light: Blind
        -- Darkness: Reduces damage by 30%%
        -- Arcane: Silence
        -- Physical: Slow by 30%%
        This can trigger every %d turns.]]):tformat(t.getChance(self, t), t.getDuration(self, t), t.cooldown(self, t))
    end,
}

newTalent {
    name = "Energy Recycle",
    type = { "spell/elemental-alchemy", 3 },
    mode = "sustained",
    require = spells_req_high3,
    points = 5,
    sustain_mana = 30,
    cooldown = 30,
    tactical = { BUFF = 10 },
    getCDReduce = function(self, t)
        if self:getTalentLevel(t) > 4 then
            return 2
        else
            return 1
        end
    end,
    getThreshold = function(self, t)
        return self.level * 2
    end,
    getExposure = function(self, t)
        return math.floor(self:combatTalentSpellDamageBase(t, 20, 40))
    end,
    getChance = function(self, t)
        return math.floor(math.min(100, self:combatTalentScale(t, 25, 100)))
    end,
    activate = function(self, t)
        game:playSoundNear(self, "talents/lightning")
        local ret = {}
        if core.shader.active(4) then
            ret.particle = self:addParticles(Particles.new("shader_ring_rotating", 1, { z = 5, rotation = 0, radius = 1.4, img = "alchie_lightning" }, { type = "lightningshield", time_factor = 4000, ellipsoidalFactor = { 1.7, 1.4 } }))
        end

        return ret
    end,
    deactivate = function(self, t, p)
        self:removeParticles(p.particle)
        return true
    end,
    callbackOnDealDamage = function(self, t, val, target, dead, death_note)
        if val < t.getThreshold(self, t) then
            return
        end
        local chance = t.getChance(self, t)
        if not rng.percent(chance) then
            return
        end
        if not dead then
            target:setEffect(target.EFF_ITEM_EXPOSED, 3, { src = self, reduce = t.getExposure(self, t), no_ct_effect = true, apply_power = self:combatSpellpower() })
        end
        local cd = self.turn_procs.alchemist_bomb_cd
        if self:knowTalent(self.T_THROW_BOMB_NEW) then
            if self:isTalentCoolingDown(self.T_THROW_BOMB_NEW) then
                if not cd then
                    self.turn_procs.alchemist_bomb_cd = true
                    self:alterTalentCoolingdown(self.T_THROW_BOMB_NEW, 0 - t.getCDReduce(self, t))
                end
            else
                self.turn_procs.alchemist_bomb_cd = nil
            end
        end
    end,
    info = function(self, t)
        return ([[If you have chosen your elemental infusion, every time you deal damage the same type as your infusion, you have %d%% chance to reduce the remaining cooldown of your bomb by %d turns. Besides, you may lower your targets' defense, reducing saves and defense by %d for 3 turns.
        You must deal more than %d damage to trigger this effect.
        Cooldown reduction can happen once per turn.
        ]]):tformat(t.getChance(self, t), t.getCDReduce(self, t), t.getExposure(self, t), t.getThreshold(self, t))
    end,
}

newTalent {
    name = "Body of Element",
    type = { "spell/elemental-alchemy", 4 },
    require = spells_req_high4,
    points = 5,
    mana = 0,
    cooldown = 30,
    tactical = { BUFF = 10 },
    radius = 6,
    getDuration = function(self, t)
        return self:combatTalentScale(t, 5, 16)
    end,
    getResist = function(self, t)
        return self:combatTalentScale(t, 10, 30)
    end,
    getResistPen = function(self, t)
        return 25
    end,
    getDamage = function(self, t)
        return self:combatTalentSpellDamage(t, 5, 80)
    end,
    getTargetCount = function(self, t)
        return math.floor(self:getTalentLevel(t))
    end,
    target = function(self, t)
        return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), selffire=false, friendlyfire=false}
    end,
    passives = function(self, t)
        self:updateTalentPassives(self.T_ELEMENTAL_INFUSION)
    end,
    action = function(self, t)
        -- Add a lasting map effect
        local ef = game.level.map:addEffect(self,
                self.x, self.y, t.getDuration(self, t),
                bombUtil:getElementalInsufionType(self),
                self:spellCrit(t.getDamage(self, t)),
                self:getTalentRadius(t),
                5, nil,
                {type=getElementalStorm(self), only_one=true},
                function(e)
                    e.x = e.src.x
                    e.y = e.src.y
                    return true
                end,
                0, 0
        )
        ef.name = _t"elemental storm"
        game:playSoundNear(self, bombUtil:getSound(self, t))
        return true
    end,
    info = function(self, t)
        local type = self.elemental_infusion
        if not self:knowTalent(self.T_ELEMENTAL_INFUSION) then
            type = "fire"
        end
        return ([[You body turn into pure element. You gain %d%% resistance and %d%% resistance penetration for the specific element you choose.
        You can activate this talent, to conjure a storm of selected element in radius %d for %d turns, dealing %0.2f %s damage each turn.
        ]]):tformat(t.getResist(self, t), t.getResistPen(self, t), self:getTalentRadius(t), t.getDuration(self, t), damDesc(self, bombUtil:getElementalInsufionType(self), t.getDamage(self, t)), _t(type))
    end,
}