newTalent {
    name = "Resilience", short_name = "GOLEM_RESILIENCE", image = "talents/strong.png",
    type = { "golem/energy", 1 },
    require = spells_req1,
    points = 5,
    mode = "passive",
    getLife = function(self, t)
        return self:combatTalentScale(t, 50, 330)
    end,
    getRegen = function(self, t)
        return self:combatTalentScale(t, 4, 16)
    end,
    passives = function(self, t, tmptable)
        self:talentTemporaryValue(tmptable, "max_life", t.getLife(self, t))
        self:talentTemporaryValue(tmptable, "life_regen", t.getRegen(self, t))
    end,
    info = function(self, t)
        return ([[Your golem gains %d maximum life and %d life regeneration.
		]]):tformat(t.getLife(self, t), t.getRegen(self, t))
    end,
}

newTalent {
    name = "Shield", short_name = "GOLEM_SHIELD", image = "talents/barrier.png",
    type = { "golem/energy", 2 },
    require = spells_req2,
    points = 5,
    cooldown = 10,
    mana = 10,
    no_energy = true,
    tactical = { DEFEND = 2 },
    getAbsorb = function(self, t)
        return self:combatTalentSpellDamageBase(t, 0, 250) + 50
    end,
    getDuration = function(self, t)
        return 3
    end,
    getRegen = function(self, t)
        return self:combatTalentScale(t, 1, 4)
    end,
    passives = function(self, t, p)
        self:talentTemporaryValue(p, "life_regen", t.getRegen(self, t))
    end,
    action = function(self, t)
        if self:hasEffect(self.EFF_DAMAGE_SHIELD) then
            local shield = self:hasEffect(self.EFF_DAMAGE_SHIELD)
            local shield_power = t.getAbsorb(self, t)

            shield.power = shield.power + shield_power
            self.damage_shield_absorb = self.damage_shield_absorb + shield_power
            self.damage_shield_absorb_max = self.damage_shield_absorb_max + shield_power
            shield.dur = math.max(t.getDuration(self, t), shield.dur)
        else
            self:setEffect(self.EFF_DAMAGE_SHIELD, t.getDuration(self, t), { power = t.getAbsorb(self, t) })
        end
    end,
    info = function(self, t)
        return ([[A protective shield surrounds your golem, absorbing %d damage in %d turns.
        If your golem already has a damage shield, will instead increase its power by same amount.
 		The total damage the shield can absorb will increase with your Spellpower and can crit.
 		This talent grants your golem %d life regeneration.
		]]):tformat(t.getAbsorb(self, t), t.getDuration(self, t))
    end,
}

newTalent {
    name = "Power", short_name = "GOLEM_POWER", image = "talents/poewr.png",
    type = { "golem/energy", 3 },
    require = spells_req3,
    points = 5,
    mode = "passive",
    getPower = function(self, t)
        return self:combatTalentScale(t, 5, 40)
    end,
    getRegen = function(self, t)
        return self:combatTalentScale(t, 1, 4)
    end,
    passives = function(self, t, tmptable)
        self:talentTemporaryValue(tmptable, "combat_dam", t.getPower(self, t))
        self:talentTemporaryValue(tmptable, "combat_spellpower", t.getPower(self, t))
        self:talentTemporaryValue(tmptable, "combat_mindpower", t.getPower(self, t))
        self:talentTemporaryValue(tmptable, "life_regen", t.getRegen(self, t))
    end,
    info = function(self, t)
        return ([[Your golem gains %d physical、spell and mind power and %d life regeneration.
		]]):tformat(t.getPower(self, t), t.getRegen(self, t))
    end,

}