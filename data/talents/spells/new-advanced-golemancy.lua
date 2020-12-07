newTalent{
	name = "Supercharge Golem", short_name = "SUPERCHARGE_GOLEM_NEW",
	type = {"spell/new-advanced-golemancy", 1},
	require = spells_req_high1,
	points = 5,
	mana = 5,
	cant_steal = true,
	cooldown = function(self, t) return math.ceil(self:combatTalentLimit(t, 4, 20, 12)) end, -- Limit to > 4
	tactical = { DEFEND = 1, ATTACK=1 },
	getPower = function(self, t) return self:combatTalentSpellDamage(t, 20, 60) end,
	getSpeedBoost = function(self, t) return self:combatTalentScale(t, 10, 50) end,
	getDuration = function(self, t) return 7 end,
	action = function(self, t)
		if not self.alchemy_golem then return end
		local dur = t.getDuration(self, t)
		local speed = t.getSpeedBoost(self, t)
		local power = t.getPower(self, t)

		local mover, golem = getGolem(self)
		if not golem then
			game.logPlayer(self, "Your golem is currently inactive.")
			return
		end

		golem:setEffect(golem.EFF_SUPERCHARGE_GOLEM_NEW, dur, {speed = speed, power=power})

		game:playSoundNear(self, "talents/arcane")
		return true
	end,
	info = function(self, t)
        local dur = t.getDuration(self, t)
		local speed = t.getSpeedBoost(self, t)
		local power = t.getPower(self, t)
		return ([[You activate a special mode of your golem, boosting its speed by %d%% for %d turns.
		While supercharged, your golem is enraged and deals %d%% more damage.
		Damage boost scales with your spellpower.]]):
		tformat(speed, dur, power)
	end,
}

newTalent{
	name = "Golem Portal", short_name = "GOLEM_PORTAL_NEW",
	type = {"spell/new-advanced-golemancy",2},
	require = spells_req_high2,
	points = 5,
	mana = 30,
	cant_steal = true,
	getDuration = function(self, t) return math.floor(self:combatTalentLimit(t, 8, 2, 5)) end, -- Limit < 8
	cooldown = function(self, t) return math.ceil(self:combatTalentLimit(t, 8, 25, 15)) end, -- Limit to > 8
	action = function(self, t)
		local mover, golem = getGolem(self)
		if not golem then
			game.logPlayer(self, "Your golem is currently inactive.")
			return
		end

		local chance = math.min(100, self:getTalentLevel(t) * 15 + 25)
		local px, py = self.x, self.y
		local gx, gy = golem.x, golem.y

		self:move(gx, gy, true)
		golem:move(px, py, true)
		self:move(gx, gy, true)
		golem:move(px, py, true)
		game.level.map:particleEmitter(px, py, 1, "teleport")
		game.level.map:particleEmitter(gx, gy, 1, "teleport")

		for uid, e in pairs(game.level.entities) do
			if e.getTarget then
				local _, _, tgt = e:getTarget()
				if e:reactionToward(self) < 0 and tgt == self and rng.percent(chance) then
					e:setTarget(golem)
					golem:logCombat(e, "#Target# focuses on #Source#.")
				end
			end
		end

        self:setEffect(self.EFF_EVASION, t.getDuration(self, t), {chance = 50})
        golem:setEffect(golem.EFF_EVASION, t.getDuration(self, t), {chance = 50})
		return true
	end,
	info = function(self, t)
		return ([[Teleport to your golem, while your golem teleports to your location. Your foes will be confused, and those that were attacking you will have a %d%% chance to target your golem instead.
		After teleportation, you and your golem gain 50%% evasion for %d turns.]]):
		tformat(math.min(100, self:getTalentLevel(t) * 15 + 25), t.getDuration(self, t))
	end,
}

newTalent {
    name = "Disruption Rune",
    type = {"spell/new-advanced-golemancy", 3},
    require = spells_req_high3,
    points = 5,
    tactical = { DISABLE = 3 },
    mana = 30,
    cooldown = function(self, t) return math.ceil(self:combatTalentLimit(t, 10, 40, 20)) end, -- Limit to > 8
    radius = function(self, t) return math.floor(self:combatTalentScale(t, 1, 4)) end,
   	target = function(self, t)
   		return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), talent=t, selffire=false}
   	end,
    cant_steal = true,
    getConfuseDuration = function(self, t) return math.floor(self:combatTalentScale(t, 2, 6)) end,
    action = function(self, t)
        local mover, golem = getGolem(self)
        if not golem then
        	game.logPlayer(self, "Your golem is currently inactive.")
        	return
        end

        local tg = self:getTalentTarget(t)
        local proj_function = function(px, py)
            local target = game.level.map(px, py, Map.ACTOR)
        	if not target or self:reactionToward(target) >= 0 or not target:canBe("confusion") then return end
        	target:setEffect(target.EFF_DISRUPTED, t.getConfuseDuration(self, t), {apply_power = self:combatSpellpower(), fail = 50})
        end

        self:project(tg, self.x, self.y, proj_function)
        golem:project(tg, golem.x, golem.y, proj_function)
        return true
    end,
    info = function(self, t)
        return([[You activate the disruptive rune in your golem, foes in radius %d will be disrupted for %d turns, their talents have 50%% chance to fail.
        ]]):tformat(self:getTalentRadius(t), t.getConfuseDuration(self, t))
    end,
}

newTalent {
    name = "Golem's Fury",
    type = {"spell/new-advanced-golemancy", 4},
    require = spells_req_high4,
    points = 5,
    tactical = { BUFF = 3 },
    mana = 120,
    cooldown = 50,
    getDuration = function(self, t) return math.ceil(self:combatTalentScale(t, 5, 15)) end,
    getDamage = function(self, t) return self:combatTalentScale(t, 30, 150) end,
    getStatsBoost = function(self, t)
        local mover, golem = getGolem(self)
        if not golem then
        	return 0
        end
        return self:combatTalentSpellDamage(t, 0, 100, golem:combatSpellpower())
    end,
    getPower = function(self, t) return self:combatTalentScale(t, 20, 60) end,
    action = function(self, t)
        local mover, golem = getGolem(self)
        if not golem then
        	game.logPlayer(self, "Your golem is currently inactive.")
        	return
        end

        local stats = t.getStatsBoost(self, t)
        local power = 0
        if golem:hasEffect(golem.EFF_SUPERCHARGE_GOLEM_NEW) then
            power = stats
        end
        golem:setEffect(golem.EFF_ULTIMATE_POWER, t.getDuration(self, t), {stats = stats , power = power, dam = t.getDamage(self, t)})
        return true
    end,
    passives = function(self, t, p)
        if not self.alchemy_golem then return end -- Safety net
        self:talentTemporaryValue(p, "alchemy_golem", {combat_spellpower=t.getPower(self, t), combat_dam = t.getPower(self, t)})
    end,
    info = function(self, t)
        return([[Infuse your golem with #GOLD#ULTIMATE POWER#LAST#!
        In %d turns, your golem gains great fury, automatically dealing %0.2f elemental damage (fire/cold/lightning/acid, selected randomly) to foes in radius 6 at the start of each turn.
        While in fury state, your golem's stats are increased by %d, and if it is already supercharged, will gain %d%% additional damage boost.
        Also, learn this talent will grant your golem %d spellpower and physical power.
        The stat and damage boost scales with your golem's spellpower.
        ]]):tformat(t.getDuration(self, t), t.getDamage(self, t),  t.getStatsBoost(self, t), t.getStatsBoost(self, t), t.getPower(self, t))
    end,


}