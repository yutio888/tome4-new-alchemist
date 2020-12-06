local function getElementalInsufionType(self)
    if self:knowTalent(self.T_ELEMENTAL_INFUSION) and self.elemental_infusion then
        local type = self.elemental_infusion
        if type == "fire" then return DamageType.FIRE
        elseif type == "acid" then return DamageType.ACID
        elseif type == "cold" then return DamageType.COLD
        elseif type == "lightning" then return DamageType.LIGHTNING
        else return DamageType.PHYSICAL
        end
    end
    return nil
end

newTalent{
	name = "Manage Elemental Infusion", image = "talents/fire_infusion.png",
	type = {"spell/other", 1},
	points = 1,
	cooldown = 5,
	cant_steal = true,
	no_npc_use = true,
	action = function(self, t)
		local Chat = require "engine.Chat"
        local chat = Chat.new("choose-elemental_infusion", {name=_t"Choose your element"}, game.player)
        chat:invoke()
        return true
	end,
	info = function(self, t)
		return (_t[[Manage your elemental infusion.]])
	end,
}

newTalent {
    name = "Elemental Infusion", image = "talents/fire_infusion.png",
	type = {"spell/elemental-alchemy", 1},
	mode = "passive",
	require = spells_req_high1,
	points = 5,
	cooldown = function(self, t) return self:combatTalentLimit(t, 3, 30, 6) end,
	tactical = { BUFF = 2 },
	autolearn_talent = "T_MANAGE_ELEMENTAL_INFUSION",
	getIncrease = function(self, t) return self:combatTalentScale(t, 10, 20) end,
	passives = function(self, t, ret)
	    local type = getElementalInsufionType(self)
    	if type then
    	    self:talentTemporaryValue(ret, "inc_damage", {[type] = t.getIncrease(self, t)})
    	    if self:knowTalent(self.T_BODY_OF_ELEMENT) then
    	        self:talentTemporaryValue(ret, "resists", {[type] = self:callTalent(self.T_BODY_OF_ELEMENT, "getResist")})
    	        self:talentTemporaryValue(ret, "resists_pen", {[type] = self:callTalent(self.T_BODY_OF_ELEMENT, "getResistPen")})
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
		You may choose your infusion in following elements: fire, cold, lightning and acid.]]):
		tformat(_t(self.elemental_infusion) or _t"fire", _t(self.elemental_infusion) or _t"fire", daminc)
	end,
}

newTalent {
    name = "Infusion Enchantment", image = "talents/frost_infusion.png",
    type = {"spell/elemental-alchemy", 2},
    mode = "passive",
    require = spells_req_high2,
    points = 5,
    cooldown = function(self, t) return math.floor(self:combatTalentLimit(t, 1, 10, 6)) end,
    getChance = function(self, t) return math.floor(self:combatTalentLimit(t, 100, 25, 75)) end,
    getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 1, 4)) end,
    callbackOnAlchemistBomb = function(self, t, targets)
        if self:isTalentCoolingDown(t) then return end
        local chance = t.getChance(self, t)
        if not rng.percent(chance) then return end
        self:startTalentCooldown(t)
        local type = getElementalInsufionType(self)
        local dur = t.getDuration(self, t)
        for _, l in ipairs(targets) do
            local target = l.target
            if target and target:reactionToward(self) < 0 then
                if type == DamageType.FIRE then
                    if target:canBe("stun") then
                        target:setEffect(target.EFF_STUNNED, dur, {src = self})
                    end
                elseif type == DamageType.COLD then
                    if target:canBe("pin") then
                        target:setEffect(target.EFF_FROZEN_FEET, dur, {src = self})
                    end
                elseif type == DamageType.ACID then
                    if target:canBe("blind") then
                        target:setEffect(target.EFF_BLINDED, dur, {src = self})
                    end
                elseif type == DamageType.LIGHTNING then
                    if target:canBe("stun") then
                        target:setEffect(target.EFF_DAZED, dur, {src = self})
                    end
                end
            end
        end
    end,
    info = function(self, t)
        return ([[You alchemist bomb now has a %d%% chance to disable your foes for %d turns, the infliced effect changes with your elemental infusion:
        -- Fire: Stun
        -- Cold: Frozen feet
        -- Acid: Blind
        -- Lightning: Daze
        This can trigger every %d turns.
        ]]):tformat(t.getChance(self, t), t.getDuration(self, t), t.cooldown(self, t))
    end,
}

newTalent {
    name = "Elemental Fury", image = "talents/living_lightning.png",
    type = {"spell/elemental-alchemy", 3},
    mode = "sustained",
    require = spells_req_high3,
    points = 5,
    sustain_mana = 100,
    cooldown = 30,
    getCDReduce = function(self, t) if self:getTalentLevel(t) > 4 then return 2 else return 1 end end,
    getThreshold = function(self, t) return self.level * 2 end,
    getExposure = function(self, t) return math.floor(self:combatTalentSpellDamage(t, 0, 60)) end,
    getChance = function(self, t) return math.floor(self:combatTalentLimit(t, 100, 25, 75)) end,
    activate = function(self, t)
    	game:playSoundNear(self, "talents/lightning")
        local ret = {}
        if core.shader.active(4) then
        	ret.particle = self:addParticles(Particles.new("shader_ring_rotating", 1, {z=5, rotation=0, radius=1.4, img="alchie_lightning"}, {type="lightningshield", time_factor = 4000, ellipsoidalFactor = {1.7, 1.4}}))
        end

        return ret
    end,
    deactivate = function(self, t, p)
    	self:removeParticles(p.particle)
        return true
    end,
    callbackOnDealDamage = function(self, t, val, target, dead, death_note)
    	if val < t.getThreshold(self, t) then return end
    	local cd = self.turn_procs.alchemist_bomb_cd
    	self.turn_procs.alchemist_bomb_cd = true
    	local chance = t.getChance(self, t)
    	if not rng.percent(chance) then return end
        if not dead then target:setEffect(target.EFF_ITEM_EXPOSED, 3, {src = self, reduce = t.getExposure(self, t), no_ct_effect = true, apply_power = self:combatSpellpower()}) end
    	if self:knowTalent(self.T_THROW_BOMB_NEW) then
    	    if self:isTalentCoolingDown(self.T_THROW_BOMB_NEW) then
    	        if not cd then self:alterTalentCoolingdown(self.T_THROW_BOMB_NEW, 0-t.getCDReduce(self, t)) end
            else
                self.turn_procs.alchemist_bomb_cd = nil
            end
        end
    end,
    info = function(self, t)
        return ([[If you have chosen your elemental infusion, every time you deal damage the same type as your infusion, you have %d%% chance to reduce the remaining cooldown of your bomb by %d turns. Besides, you may lower your targets' defense, reducing saves and defensed by %d for 3 turns.
        You must deal more than %d damage to trigger this effect.
        Cooldown reduction can happen once per turn.
        ]]):tformat(t.getChance(self, t), t.getCDReduce(self, t), t.getExposure(self, t), t.getThreshold(self, t))
    end,
}


newTalent {
    name = "Body of Element", image = "talents/body_of_fire.png",
    type = {"spell/elemental-alchemy", 4},
    mode = "sustained",
    require = spells_req_high4,
    points = 5,
    sustain_mana = 100,
    cooldown = 30,
    getResist = function(self, t) return self:combatTalentScale(t, 20, 50) end,
    getResistPen = function(self, t) return 33 end,
    getDamage = function(self, t) return self:combatTalentSpellDamage(t, 5, 80) end,
    activate = function(self, t)
    	game:playSoundNear(self, "talents/fireflash")
    	local ret = {}
    	self:addShaderAura("body_of_fire", "awesomeaura", {time_factor=3500, alpha=1, flame_scale=1.1}, "particles_images/wings.png")
    	self:updateTalentPassives(self.T_ELEMENTAL_INFUSION)
    	return ret
    end,
    deactivate = function(self, t, p)
    	self:removeShaderAura("body_of_fire")
    	game.logSeen(self, "#FF8000#The raging fire around %s calms down and disappears.", self:getName())
    	self:updateTalentPassives(self.T_ELEMENTAL_INFUSION)
    	return true
    end,
    getTargetCount = function(self, t) return math.floor(self:getTalentLevel(t)) end,
    callbackOnActBase = function(self, t)
    	local type = getElementalInsufionType(self) or DamageType.FIRE
        local nb = t.getTargetCount(self, t)
		local dam = self:spellCrit(t.getDamage(self, t))
        local targets = table.keys(self:projectCollect({type="ball", radius=6, talent=t}, self.x, self.y, Map.ACTOR, "hostile"))
        while #targets > 0 and nb > 0 do
        	local target = rng.tableRemove(targets)
        	nb = nb - 1
        	DamageType:get(type).projector(self, target.x, target.y, type, dam)
            game.level.map:particleEmitter(target.x, target.y, 1, "circle", {base_rot=0, oversize=1.1, a=230, limit_life=8, appear=6, speed=0, img="healred", radius=0, shader=true})

        end
    end,
    info = function(self, t)
        local type = self.elemental_infusion
        if not self:knowTalent(self.T_ELEMENTAL_INFUSION) then
            type = "fire"
        end
        return ([[You body turn into pure element.
        You gain %d%% resistance, %d%% resistance penetration for the specific element you choose.
        Every turn, a random elemental bolt will hit up to %d of your foes in radius 6, dealing %0.2f %s damage.
        ]]):tformat(t.getResist(self, t), t.getResistPen(self, t), t.getTargetCount(self, t), damDesc(self, getElementalInsufionType(self), t.getDamage(self, t)), _t(type))
    end,
}