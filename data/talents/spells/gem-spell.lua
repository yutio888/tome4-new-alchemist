newTalent {
    name = "Gem Blast",
    type = {"spell/gem-spell", 1},
    require = spells_req1,
    points = 5,
    range = 10,
    mana = 1,
    direct_hit = true,
	reflectable = true,
	requires_target = true,
	target = function(self, t)
    	local ammo = self:hasAlchemistWeapon()
       	if not ammo then return end
		return {type="hit", range=self:getTalentRange(t), talent=t}
	end,
    tactical = function(self, t, aitarget)
        local damtype = self:getGemDamageType()
        local t = { ATTACK = {} }
        t.ATTACK[damtype] = 2
        return t
    end,
    cooldown = 5,
    on_pre_use = function(self, t)
        return self:hasAlchemistWeapon()
    end,
    getDamage = function(self, t)
        return self:combatTalentGemDamage(t, 30, 420)
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
            local _, x, y = self:canProject(tg, x, y)
            game.level.map:particleEmitter(self.x, self.y, math.max(math.abs(x-self.x), math.abs(y-self.y)), "light_beam", {tx=x-self.x, ty=y-self.y})
            self:triggerGemEffect(target, gem, dam)
            self:triggerGemAreaEffect(gem, self:project(tg, x, y, function(tx, ty) end))
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
    range = function(self, t) return self:combatTalentScale(t, 1, 3) end,
    radius = function(self, t) return 5 end,
    mana = 1,
    direct_hit = true,
	requires_target = true,
    tactical = function(self, t, aitarget)
        local damtype = self:getGemDamageType()
        local t = { ATTACKAREA = {} }
        t.ATTACKAREA[damtype] = 2
        return t
    end,
	target = function(self, t)
    	local ammo = self:hasAlchemistWeapon()
    	if not ammo then return end
    	return {type="ball", range=self:getTalentRange(t) + (ammo and ammo.alchemist_bomb and ammo.alchemist_bomb.range or 0), radius=self:getTalentRadius(t), talent=t}
    end,
    cooldown = 15,
    on_pre_use = function(self, t)
        return self:hasAlchemistWeapon()
    end,
    getDamage = function(self, t)
        return self:combatTalentGemDamage(t, 30, 320)
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
        if not self:teleportRandom(x, y, 0) then
            game.logSeen(self, "%s's teleport fizzles!", self:getName():capitalize())
            game:playSoundNear(self, "talents/teleport")
            return true
        end
		local dam = t.getDamage(self, t)
		local damtype = self:getGemDamageType()
        local grids = self:project(tg, x, y, function(tx, ty) end)
        local tgs = 0
		self:projectApply(tg, x, y, Map.ACTOR, function(target)
		    if self:reactionToward(target) >= 0 then return end
		    self:setProc("trigger_gem", true, 5)
		    local tdam =dam
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
		game.level.map:particleEmitter(x, y, tg.radius, "ball_physical", {radius=tg.radius, tx=x, ty=y})
        game:playSoundNear(self, "talents/teleport")
		return true
    end,
    info = function(self, t)
        return([[Invoke the power of gem, teleports you to up to %d tiles away, to a targeted location in line of sight.
        Then deals %0.2f %s damage to all hostile targets in radius %d.
        If this attack hits, it will trigger the special effect of gem.
        This talent can be activated even in silence.
        Using this talent will disable One with Gem for 5 turns.
        The damage scales with your gem tier, and the damage type changes with your gem.
        This spell cannot crit.
        ]]):tformat(t.range(self, t), damDesc(self,self:getGemDamageType(), t.getDamage(self, t)), _t(self:getGemDamageType():lower()), t.radius(self, t))
    end,
}

newTalent {
    name = "Flickering Gem",
    type = {"spell/gem-spell", 3},
    require = spells_req3,
    points = 5,
    cooldown = 20,
    radius = 10,
    mana = 1,
    tactical = { DEFEND = 1.5 },
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
        This talent can be activated even in silence.
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
	mode = "sustained",
    no_npc_use = true,
    sustain_mana = function(self, t) return self:combatTalentLimit(t, 0, 300, 80) end,
    cooldown = function(self, t) return self:combatTalentLimit(t, 0, 100, 10) end,
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
        return self:combatTalentLimit(t, 0, 40, 5)
    end,
    iconOverlay = function(self, t, p)
        if not p then return "" end
        local turn = self.turn_procs.multi and self.turn_procs.multi.trigger_gem and self.turn_procs.multi.trigger_gem.turns or 0
        if turn <= 0 then return "" end
        return tostring("#RED##{bold}#"..turn.."#LAST##{normal}#"), "buff_font_small"
    end,
    callbackOnDealDamage = function(self, t, val, target, dead, death_note)
        if death_note.damtype ~= self:getGemDamageType() then return end
        local gem = self:hasAlchemistWeapon()
        if not gem then return end
        if self:hasProc("trigger_gem") then return end
        local cost = t.getCost(self, t)
        if self:getMana() < cost then return end
        self:incMana(-cost)
        local proc = {val = true, turns = t.getTurn(self, t)}
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
        local turn = self.turn_procs.multi and self.turn_procs.multi.trigger_gem and self.turn_procs.multi.trigger_gem.turns or 0
        local disabled = ""
        if turn and turn > 0 then
            disabled = ([[This has beed disabled for %d turns]]):tformat(turn)
        end
        return([[When you dealt damage the same type as your gem, you may trigger the special effect of your gem.
        Each trigger drains you %d mana.
        This can happen every %d turns.
        %s]]):tformat(t.getCost(self, t), t.getTurn(self, t), disabled)
    end,
}