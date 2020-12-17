newTalent {
    name = "Eye Beam", short_name = "GOLEM_BEAM_NEW", image = "talents/golem_beam.png",
    type = { "golem/new-arcane", 1 },
    require = spells_req1,
    points = 5,
    cooldown = 2,
    range = 7,
    mana = 10,
    requires_target = true,
    target = function(self, t)
        return { type = "beam", range = self:getTalentRange(t), force_max_range = true, talent = t, friendlyfire = false }
    end,
    getDamage = function(self, t)
        return self:combatTalentSpellDamage(t, 35, 280)
    end,
    tactical = { ATTACK = { FIRE = 1, COLD = 1, LIGHTNING = 1 } },
    action = function(self, t)
        local tg = self:getTalentTarget(t)
        local x, y = self:getTarget(tg)
        if not x or not y then
            return nil
        end
        if self.x == x and self.y == y then
            return nil
        end

        -- We will always project the beam as far as possible
        local typ = rng.range(1, 3)

        if typ == 1 then
            self:project(tg, x, y, DamageType.FIRE, self:spellCrit(t.getDamage(self, t)))
            local _
            _, x, y = self:canProject(tg, x, y)
            game.level.map:particleEmitter(self.x, self.y, tg.radius, "flamebeam", { tx = x - self.x, ty = y - self.y })
        elseif typ == 2 then
            self:project(tg, x, y, DamageType.LIGHTNING, self:spellCrit(t.getDamage(self, t)))
            local _
            _, x, y = self:canProject(tg, x, y)
            game.level.map:particleEmitter(self.x, self.y, math.max(math.abs(x - self.x), math.abs(y - self.y)), "lightning", { tx = x - self.x, ty = y - self.y })
        else
            self:project(tg, x, y, DamageType.COLD, self:spellCrit(t.getDamage(self, t)))
            local _
            _, x, y = self:canProject(tg, x, y)
            game.level.map:particleEmitter(self.x, self.y, tg.radius, "icebeam", { tx = x - self.x, ty = y - self.y })
        end

        game:playSoundNear(self, "talents/spell_generic")
        return true
    end,
    getSpellpower = function(self, t)
        return self:combatTalentScale(t, 3, 12)
    end,
    passives = function(self, t, p)
        self:talentTemporaryValue(p, "combat_spellpower", t.getSpellpower(self, t))
    end,
    info = function(self, t)
        local damage = t.getDamage(self, t)
        return ([[Your golem fires a beam from his eyes, doing %0.2f fire damage, %0.2f cold damage or %0.2f lightning damage.
		The beam will always be the maximun range it can be and will not harm friendly creatures.
		The damage will increase with your golem's Spellpower.
		This talent grants your golem %d Spellpower.]]):
        tformat(damDesc(self, DamageType.FIRE, damage), damDesc(self, DamageType.COLD, damage), damDesc(self, DamageType.LIGHTNING, damage), t.getSpellpower(self, t))
    end,
}

newTalent {
    name = "Reflective Skin", short_name = "GOLEM_REFLECTIVE_SKIN_NEW", image = "talents/golem_reflective_skin.png",
    type = { "golem/new-arcane", 2 },
    require = spells_req2,
    points = 5,
    mode = "sustained",
    cooldown = 70,
    range = 10,
    sustain_mana = 30,
    requires_target = true,
    tactical = { SELF = { DEFEND = 1, BUFF = 1 }, SURROUNDED = 3 },
    getReflect = function(self, t)
        return self:combatLimit(self:combatTalentSpellDamage(t, 12, 40), 100, 20, 0, 46.5, 26.5)
    end,
    activate = function(self, t)
        game:playSoundNear(self, "talents/spell_generic2")
        self:addShaderAura("reflective_skin", "awesomeaura", { time_factor = 5500, alpha = 0.6, flame_scale = 0.6 }, "particles_images/arcaneshockwave.png")
        local ret = {
            tmpid = self:addTemporaryValue("reflect_damage", (t.getReflect(self, t)))
        }
        return ret
    end,
    deactivate = function(self, t, p)
        self:removeShaderAura("reflective_skin")
        self:removeTemporaryValue("reflect_damage", p.tmpid)
        return true
    end,

    getSpellpower = function(self, t)
        return self:combatTalentScale(t, 3, 12)
    end,
    passives = function(self, t, p)
        self:talentTemporaryValue(p, "combat_spellpower", t.getSpellpower(self, t))
    end,
    info = function(self, t)
        return ([[Your golem's skin shimmers with eldritch energies.
		Any damage it takes is partly reflected (%d%%) to the attacker.
		The golem still takes full damage.
		Damage returned will increase with your golem's Spellpower.
		This talent grants your golem %d Spellpower.]]):
        tformat(t.getReflect(self, t), t.getSpellpower(self, t))
    end,
}

newTalent {
    name = "Arcane Pull", short_name = "GOLEM_ARCANE_PULL_NEW", image = "talents/golem_arcane_pull.png",
    type = { "golem/new-arcane", 3 },
    require = spells_req3,
    points = 5,
    cooldown = 10,
    range = 0,
    radius = function(self, t)
        return math.floor(self:combatTalentScale(t, 4, 7))
    end,
    mana = 20,
    requires_target = true,
    target = function(self, t)
        return { type = "ball", range = self:getTalentRange(t), friendlyfire = false, selffire = false, radius = self:getTalentRadius(t), talent = t }
    end,
    tactical = { ATTACKAREA = { ARCANE = 1.5 }, CLOSEIN = { knockback = 1 } },
    getDamage = function(self, t)
        return self:combatTalentSpellDamage(t, 12, 120)
    end,
    action = function(self, t)
        local tg = self:getTalentTarget(t)
        local tgts = {}
        self:project(tg, self.x, self.y, function(px, py, tg, self)
            local target = game.level.map(px, py, Map.ACTOR)
            if target then
                tgts[#tgts + 1] = { actor = target, sqdist = core.fov.distance(self.x, self.y, px, py) }
            end
        end)
        table.sort(tgts, "sqdist")
        for i, target in ipairs(tgts) do
            if target.actor:canBe("knockback") then
                target.actor:pull(self.x, self.y, tg.radius)
                self:logCombat(target.actor, "#Target# is pulled toward #Source#!")
            end
            DamageType:get(DamageType.ARCANE).projector(self, target.actor.x, target.actor.y, DamageType.ARCANE, t.getDamage(self, t))
        end
        return true
    end,

    getSpellpower = function(self, t)
        return self:combatTalentScale(t, 3, 12)
    end,
    passives = function(self, t, p)
        self:talentTemporaryValue(p, "combat_spellpower", t.getSpellpower(self, t))
    end,
    info = function(self, t)
        local rad = self:getTalentRadius(t)
        local dam = t.getDamage(self, t)
        return ([[Your golem pulls all foes within radius %d toward itself while dealing %0.2f arcane damage.
        This talent grants your golem %d Spellpower.]]):
        tformat(rad, dam, t.getSpellpower(self, t))
    end,
}

newTalent {
    name = "Molten Skin", short_name = "GOLEM_MOLTEN_SKIN_NEW", image = "talents/golem_molten_skin.png",
    type = { "golem/new-arcane", 4 },
    require = spells_req4,
    points = 5,
    mana = 30,
    cooldown = 15,
    range = 0,
    radius = 3,
    target = function(self, t)
        return { type = "ball", range = self:getTalentRange(t), friendlyfire = false, radius = self:getTalentRadius(t) }
    end,
    tactical = { ATTACKAREA = { FIRE = 2 } },
    action = function(self, t)
        local duration = 5 + self:getTalentLevel(t)
        local dam = self:spellCrit(self:combatTalentSpellDamage(t, 20, 120))
        -- Add a lasting map effect
        game.level.map:addEffect(self,
                self.x, self.y, duration,
                DamageType.GOLEM_FIREBURN, dam,
                self:getTalentRadius(t),
                5, nil,
                MapEffect.new { zdepth = 6, alpha = 85, color_br = 200, color_bg = 60, color_bb = 30, effect_shader = "shader_images/fire_effect.png" },
                function(e)
                    e.x = e.src.x
                    e.y = e.src.y
                    return true
                end,
                false
        )
        self:setEffect(self.EFF_MOLTEN_SKIN, duration, { power = 30 + self:combatTalentSpellDamage(t, 12, 60) })
        game:playSoundNear(self, "talents/fire")
        return true
    end,

    getSpellpower = function(self, t)
        return self:combatTalentScale(t, 3, 12)
    end,
    passives = function(self, t, p)
        self:talentTemporaryValue(p, "combat_spellpower", t.getSpellpower(self, t))
    end,
    info = function(self, t)
        return ([[Turns the golem's skin into molten rock. The heat generated sets ablaze everything inside a radius of 3, doing %0.2f fire damage in 3 turns for %d turns.
		Burning is cumulative; the longer they stay within range, they higher the fire damage they take.
		In addition the golem gains %d%% fire resistance.
		Molten Skin damage will not affect friendly creatures.
		The damage and resistance will increase with your Spellpower.
		This talent grants your golem %d Spellpower.]])
                :tformat(damDesc(self, DamageType.FIRE, self:combatTalentSpellDamage(t, 12, 120)),
                5 + self:getTalentLevel(t),
                30 + self:combatTalentSpellDamage(t, 12, 60),
                t.getSpellpower(self, t)
        )
    end,
}