newTalent {
    name = "Gem Blast",
    type = {"spell/gem-spell", 1},
    require = spells_req1,
    points = 5,
    range = 10,
    direct_hit = true,
	reflectable = true,
	requires_target = true,
	target = function(self, t)
    	local ammo = self:hasAlchemistWeapon()
       	if not ammo then return end
		return {type="hit", range=self:getTalentRange(t), talent=t}
	end,
	no_npc_use = true,
    cooldown = 6,
    on_pre_use = function(self, t)
        return self:hasAlchemistWeapon()
    end,
    getDamage = function(self, t)
        return self:combatTalentGemDamage(t, 120, 500)
    end,
    action = function(self, t)
        local gem = self:hasAlchemistWeapon()
        if not gem then
            game.logPlayer(self, "You need to ready gems in your quiver.")
            return
        end
        local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		if not x or not y then return nil end
		local dam = t.getDamage(self, t)
		local damtype = self:getGemDamageType()
		self:projectApply(tg, x, y, Map.ACTOR, function(target)
		    if self:reactionToward(target) >= 0 then return end
		    self:setProc("trigger_gem", true, 5)
		    if gem.alchemist_bomb and gem.alchemist_bomb.power then
                dam = dam * (1 + gem.alchemist_bomb.power * 0.01)
            end
            DamageType:get(damtype).projector(self, target.x, target.y, damtype, dam)
            local _ _, x, y = self:canProject(tg, x, y)
            game.level.map:particleEmitter(self.x, self.y, math.max(math.abs(x-self.x), math.abs(y-self.y)), "light_beam", {tx=x-self.x, ty=y-self.y})
            self:triggerGemEffect(target, gem, dam)
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
        return([[Deals %0.2f %s damage to target.
        If this attack hits, it will trigger the special effect of gem.
        This talent can be activated even in silence.
        Using this talent will disable One with Gem for 5 turns.
        The damage scales with your gem tier, and the damage type changes with your gem.
        This spell cannot crit.
        ]]):tformat(damDesc(self,self:getGemDamageType(), t.getDamage(self, t)), _t(self:getGemDamageType():lower()))
    end,
}

newTalent {
    name = "Gem's Radiance",
    type = {"spell/gem-spell", 2},
    require = spells_req2,
    points = 5,
    range = function(self, t) return self:combatTalentScale(t, 2, 6) end,
    radius = function(self, t) return 5 end,
    direct_hit = true,
	reflectable = true,
	requires_target = true,
	target = function(self, t)
    	local ammo = self:hasAlchemistWeapon()
    	if not ammo then return end
    	return {type="ball", range=self:getTalentRange(t) + (ammo and ammo.alchemist_bomb and ammo.alchemist_bomb.range or 0), radius=self:getTalentRadius(t), talent=t}
    end,
	no_npc_use = true,
    cooldown = 12,
    on_pre_use = function(self, t)
        return self:hasAlchemistWeapon()
    end,
    getDamage = function(self, t)
        return self:combatTalentGemDamage(t, 100, 320)
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
		if not x or not y then return nil end
		if not x or not y then return nil end
		local dam = t.getDamage(self, t)
		local damtype = self:getGemDamageType()
		self:projectApply(tg, x, y, Map.ACTOR, function(target)
		    if self:reactionToward(target) >= 0 then return end
		    self:setProc("trigger_gem", true, 5)
		    local tdam =dam
		    if gem.alchemist_bomb and gem.alchemist_bomb.power then
                tdam = tdam * (1 + gem.alchemist_bomb.power * 0.01)
            end
            DamageType:get(damtype).projector(self, target.x, target.y, damtype, tdam)
            self:triggerGemEffect(target, gem, dam)
        end)

        local _ _, x, y = self:canProject(tg, x, y)
		game.level.map:particleEmitter(x, y, tg.radius, "ball_physical", {radius=tg.radius, tx=x, ty=y})
		game:playSoundNear(self, "talents/arcane")
		return true
    end,
    info = function(self, t)
        return([[Deals %0.2f %s damage to all targets in radius %d.
        If this attack hits, it will trigger the special effect of gem.
        This talent can be activated even in silence.
        Using this talent will disable One with Gem for 5 turns.
        The damage scales with your gem tier, and the damage type changes with your gem.
        This spell cannot crit.
        ]]):tformat(damDesc(self,self:getGemDamageType(), t.getDamage(self, t)), _t(self:getGemDamageType():lower()), t.radius(self, t))
    end,
}

newTalent {
    name = "Flickering Gem",
    type = {"spell/gem-spell", 3},
    require = spells_req3,
    points = 5,
	no_npc_use = true,
    cooldown = 20,
    radius = 10,
    getSummonNb = function(self, t) return self:combatTalentScale(t, 1, 3) end,
    getDuration = function(self, t) return self:combatTalentGemDamage(t, 5, 12) end,
    on_learn = function(self, t)
        self:checkCanWearGem()
    end,
    on_unlearn = function(self, t)
        self:checkCanWearGem()
    end,
    on_pre_use = function(self, t)
        return self:hasAlchemistWeapon()
    end,
    action = function(self, t)
        local gem = self:hasAlchemistWeapon()
        if not gem then
            game.logPlayer(self, "You need to ready gems in your quiver.")
            return
        end
        if not self:canBe("summon") then game.logPlayer(self, "You cannot summon; you are suppressed!") return end

		local NPC = require "mod.class.NPC"
		local list = NPC:loadList("/data/general/npcs/crystal.lua")
		local nb = t.getSummonNb(self, t)
		for i = 1, nb do
			-- Find space
			local x, y = util.findFreeGrid(self.x, self.y, 5, true, {[engine.Map.ACTOR]=true})
			if not x then break end
				local e
			repeat e = rng.tableRemove(list)

			until not e.unique and e.rarity
			e = e:clone()
			local crystal = game.zone:finishEntity(game.level, "actor", e)
			crystal.make_escort = nil
			crystal.silent_levelup = true
			crystal.faction = self.faction
			crystal.ai = "summoned"
			crystal.ai_real = "dumb_talented_simple"
			crystal.summoner = self
			crystal.summon_time = 10
			crystal.exp_worth = 0
			crystal:forgetInven(crystal.INVEN_INVEN)

			local setupSummon = getfenv(self:getTalentFromId(self.T_SPIDER).action).setupSummon
			setupSummon(self, crystal, x, y)
			game:playSoundNear(self, "talents/slime")
		end

		local tg = self:getTalentTarget(t)
		local targets = table.keys(self:projectCollect({type="ball", radius=self:getTalentRadius(t), talent=t}, self.x, self.y, Map.ACTOR, "hostile"))
		if not targets then return true end
		local target = rng.tableRemove(targets)
		if target then
		    self:triggerGemEffect(target, gem, 0)
		    self:setProc("trigger_gem", true, 5)
		end

		return true
    end,
    info = function(self, t)
        return([[Invoke the power of your gem, summon %d crystal around you for %d turns.
        Then randomly select target in radius 10 and trigger the special effect of gem.
        Using this talent will disable One with Gem for 5 turns.
        Summon duration scales with your gem.
        ]]):tformat(t.getSummonNb(self, t), t.getDuration(self, t))
    end,
}

newTalent {
    name = "One with Gem",
    type = {"spell/gem-spell", 4},
    require = spells_req4,
    points = 5,
	no_npc_use = true,
	mode = "sustained",
    cooldown = 1,
    on_learn = function(self, t)
        self:checkCanWearGem()
    end,
    on_unlearn = function(self, t)
        self:checkCanWearGem()
    end,
    getTurn = function(self, t)
        return math.max(1, math.ceil(self:combatTalentScale(t, 5, 2.2)))
    end,
    callbackOnDealDamage = function(self, t, val, target, dead, death_note)
        if death_note.damtype ~= self:getGemDamageType() then return end
        local gem = self:hasAlchemistWeapon()
        if not gem then return end
        if self:hasProc("trigger_gem") then return end
        self:setProc("trigger_gem", true, t.getTurn(self, t))
        self:triggerGemEffect(target, gem, 0)
    end,
    activate = function(self, t)
        return {}
    end,
    deactivate = function(self, t)
        return true
    end,
    info = function(self, t)
        local turn = self.turn_procs.multi and self.turn_procs.multi.trigger_gem and self.turn_procs.multi.trigger_gem.turns or 0
        local disabled = ""
        if turn and turn > 0 then
            disabled = ([[This has beed disabled for %d turns]]):tformat(turn)
        end
        return([[When you dealt damage the same type as your gem, you may trigger the special effect of your gem.
        This can happen every %d turns.
        %s]]):tformat(t.getTurn(self, t), disabled)
    end,
}