-- ToME - Tales of Maj'Eyal
-- Copyright (C) 2009 - 2019 Nicolas Casalini
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.
--
-- Nicolas Casalini "DarkGod"
-- darkgod@te4.org
function getAlchemistPower(self)
    if self and self.type == "gem" then
        local tier = self.material_level or 1
        return tier * 20
    end
    return 0
end
newTalent{
	name = "Throw Bomb", short_name = "THROW_BOMB_NEW", image = "talents/throw_bomb.png",
	type = {"spell/new-explosive", 1},
	require = spells_req1,
	points = 5,
	mana = 5,
	cooldown = 4,
	range = function(self, t) return math.floor(self:combatTalentLimit(t, 15, 5.1, 9.1)) end,
	radius = function(self, t) return self:callTalent(self.T_EXPLOSION_EXPERT_NEW, "getRadius") end,
	direct_hit = true,
	requires_target = true,
	target = function(self, t)
		local ammo = self:hasAlchemistWeapon()
		if not ammo then return end
		return {type="ball", range=self:getTalentRange(t)+(ammo and ammo.alchemist_bomb and ammo.alchemist_bomb.range or 0), radius=self:getTalentRadius(t), talent=t}
	end,
	tactical = { ATTACKAREA = function(self, t, target)
		if self:knowTalent(self.T_ELEMENTAL_INFUSION) then
		    local type = self.elemental_infusion
		    if type == "fire" then return { FIRE = 2 }
		    elseif type == "acid" then return { ACID = 2 }
		    elseif type == "cold" then return { COLD = 2 }
		    elseif type == "lightning" then return { LIGHTNING = 2}
		    else return { PHYSICAL = 2}
		    end
		else return { PHYSICAL = 2 }
		end
	end },
	computeDamage = function(self, t, ammo)
		local inc_dam = 0
		local damtype = DamageType.PHYSICAL
		local particle = "ball_physical"
		if self:knowTalent(self.T_ELEMENTAL_INFUSION) then
        	local type = self.elemental_infusion
        	if type == "fire" then damtype = DamageType.FIRE; particle = "fireflash"
        	elseif type == "acid" then damtype = DamageType.ACID; particle = "ball_acid"
        	elseif type == "cold" then damtype = DamageType.COLD; particle = "ball_ice"
        	elseif type == "lightning" then damtype = DamageType.LIGHTNING; particle = "ball_lightning_beam"
        	end
        end
		inc_dam = inc_dam + (ammo.alchemist_bomb and ammo.alchemist_bomb.power or 0) / 100
		local dam = self:combatTalentSpellDamage(t, 40, 200, (getAlchemistPower(ammo) + self:combatSpellpower()) / 2)
		dam = dam * (1 + inc_dam)
		return dam, damtype, particle
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

		if not ammo then return end

		local dam, damtype, particle = t.computeDamage(self, t, ammo)
		dam = self:spellCrit(dam)
		local golem
		if self.alchemy_golem then
			golem = game.level:hasEntity(self.alchemy_golem) and self.alchemy_golem or nil
		end
		local dam_done = 0

		local nb = 0
		local grids = self:project(tg, x, y, function(tx, ty) end)
		if grids then
			for px, ys in pairs(grids or {}) do
			    for py, _ in pairs(ys) do
			        nb = nb + 1
		         end
	        end
		end
		-- Compare theorical AOE zone with actual zone and adjust damage accordingly
        if self:knowTalent(self.T_EXPLOSION_EXPERT_NEW) then
			if nb > 0 then
				dam = dam + dam * self:callTalent(self.T_EXPLOSION_EXPERT_NEW, "minmax", nb)
			end
		end

		local tmp = {}
		local tgts = table.values(self:projectCollect(tg, x, y, Map.ACTOR))
        table.sort(tgts, "dist")
        for _, l in ipairs(tgts) do
            local target = l.target
            if target:reactionToward(self) < 0 then
                dam_done = dam_done + DamageType:get(damtype).projector(self, target.x, target.y, damtype, dam)
                if ammo.alchemist_bomb and ammo.alchemist_bomb.splash then
				    DamageType:get(DamageType[ammo.alchemist_bomb.splash.type]).projector(self, target.x, target.y, DamageType[ammo.alchemist_bomb.splash.type], ammo.alchemist_bomb.splash.dam)
                end

                if ammo.alchemist_bomb and ammo.alchemist_bomb.stun and rng.percent(ammo.alchemist_bomb.stun.chance) and target:canBe("stun") then
            	    target:setEffect(target.EFF_STUNNED, ammo.alchemist_bomb.stun.dur, {apply_power=self:combatSpellpower()})
                end
                if ammo.alchemist_bomb and ammo.alchemist_bomb.daze and rng.percent(ammo.alchemist_bomb.daze.chance) and target:canBe("stun") then
            	    target:setEffect(target.EFF_DAZED, ammo.alchemist_bomb.daze.dur, {apply_power=self:combatSpellpower()})
                end
            end
		end

		self:fireTalentCheck("callbackOnAlchemistBomb", tgts)

		if ammo.alchemist_bomb and ammo.alchemist_bomb.leech then self:heal(math.min(self.max_life * ammo.alchemist_bomb.leech / 100, dam_done), ammo) end

		local _ _, x, y = self:canProject(tg, x, y)
		game.level.map:particleEmitter(x, y, tg.radius, particle, {radius=tg.radius, tx=x, ty=y})

		if ammo.alchemist_bomb and ammo.alchemist_bomb.mana then self:incMana(ammo.alchemist_bomb.mana) end

		game:playSoundNear(self, "talents/arcane")
		return true
	end,
	info = function(self, t)
		local ammo = self:hasAlchemistWeapon()
		local dam, damtype = 1, DamageType.PHYSICAL
		if ammo then dam, damtype = t.computeDamage(self, t, ammo) end
		dam = damDesc(self, damtype, dam)
		return ([[Imbue an alchemist gem with an explosive charge of mana and throw it.
		The gem will explode for %0.1f %s damage.
		Each kind of gem will also provide a specific effect.
		The damage will improve with better gems and with your Spellpower.]]):tformat(dam, DamageType:get(damtype).name)
	end,
}

newTalent{
	name = "Alchemist Protection", short_name = "NEW_ALCHEMIST_PROTECTION", image = "talents/alchemist_protection.png",
	type = {"spell/new-explosive", 2},
	require = spells_req2,
	mode = "passive",
	points = 5,
	getResists = function(self, t) return self:combatTalentSpellDamageBase(t, 10, 30) + 5 end,
	passives = function(self, t, ret)
	    self:talentTemporaryValue(ret, "resists", {[DamageType.FIRE] = t.getResists(self, t),
	    [DamageType.COLD] = t.getResists(self, t),
	    [DamageType.LIGHTNING] = t.getResists(self, t),
	    [DamageType.ACID] = t.getResists(self, t),
	    })
	end,
	info = function(self, t)
		return ([[Grants protection against external elemental damage (fire, cold, lightning and acid) by %d%%.]]):
		tformat(t.getResists(self, t))
	end,
}

local theoretical_nbs = { 9, 21, 37, 69, 97, 137, 177, 225, 293, 349, 421, 489, 577, 665, 749, 861, 973, 1085, 1201, 1313 }
newTalent{
	name = "Explosion Expert", short_name = "EXPLOSION_EXPERT_NEW", image = "talents/explosion_expert.png",
	type = {"spell/new-explosive", 3},
	require = spells_req3,
	mode = "passive",
	points = 5,
	getRadius = function(self, t) return math.max(2, math.floor(self:combatTalentLimit(t, 20, 2.5, 6.6))) end,
	mingrids = function(self, t) return self:combatTalentScale(t, 1, 3) end,
	minmax = function(self, t, grids)
		local theoretical_nb = theoretical_nbs[t.getRadius(self, t)]
		if grids then
			local lostgrids = math.max(theoretical_nb - grids, t.mingrids(self, t))
			local mult = math.max(0, math.log10(lostgrids)) / (6 - math.min(self:getTalentLevel(self.T_EXPLOSION_EXPERT_NEW)/1.3, 5))
			mult = mult / 2
			print("Adjusting explosion damage to account for ", lostgrids, " lost tiles => ", mult * 100)
			return mult
		else
			local min = (math.log10(t.mingrids(self, t)) / (6 - math.min(self:getTalentLevel(t)/1.3, 5))) / 2
			local max = (math.log10(theoretical_nb) / (6 - math.min(self:getTalentLevel(t)/1.3, 5))) / 2
			return min, max
		end
	end,
	info = function(self, t)
		local min, max = t.minmax(self, t)
		return ([[Your alchemist bombs now affect a radius of %d around them.
		Explosion damage may increase by %d%% (if the explosion is not contained) to %d%% if the area of effect is confined.]]):
		tformat(t.getRadius(self, t), min*100, max*100) --I5
	end,
}

newTalent {
    name = "Chain Blasting", image = "talents/shockwave_bomb.png",
    type = {"spell/new-explosive", 4},
  	require = spells_req4,
    mode = "passive",
    points = 5,
    getChance = function(self, t)
        local ammo = self:hasAlchemistWeapon()
        local power = getAlchemistPower(ammo)
        return self:combatTalentLimit(t, 35, 5, 25) * (1 + power * 0.01)
    end,
    info = function(self, t)
        return ([[Your alchemist bombs now have %d%% chance to not go on cooldown.
        Chances increases with your gem tier.]])
        :tformat(t.getChance(self, t))
    end,
}