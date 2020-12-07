local Particles = require "engine.Particles"
local Stats = require("engine.interface.ActorStats")
local DamageType = require("engine.DamageType")
newEffect{
	name = "DISRUPTED", image = "talents/mind_drones.png",
	desc = _t"Disrupted",
	long_desc = function(self, eff) return ("Talents fail chance %d%%."):tformat(eff.fail) end,
	type = "mental",
	subtype = {disrupt=true, confuse = true},
	status = "detrimental",
	parameters = {fail = 10},
	on_gain = function(self, eff) return _t"#Target# has been disrupted by the rune!", true end,
	on_lose = function(self, eff) return _t"#Target# is free from the disruption.", true end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "talent_fail_chance", eff.fail)
	end,
}

newEffect{
	name = "SUPERCHARGE_GOLEM_NEW", image = "talents/supercharge_golem_new.png",
	desc = _t"Supercharge Golem",
	long_desc = function(self, eff) return ("The target is supercharged, increasing speed by %d%% and damage done by %d%%."):tformat(eff.speed, eff.power) end,
	type = "magical",
	subtype = { arcane=true },
	status = "beneficial",
	parameters = { speed=10 },
	on_gain = function(self, eff) return _t"#Target# is overloaded with power.", _t"+Supercharge" end,
	on_lose = function(self, eff) return _t"#Target# seems less dangerous.", _t"-Supercharge" end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "inc_damage", {all=eff.power})
		self:effectTemporaryValue(eff, "global_speed_add", eff.speed*0.01)
		if core.shader.active(4) then
			eff.particle1 = self:addParticles(Particles.new("shader_shield", 1, {toback=true,  size_factor=1.5, y=-0.3, img="healarcane"}, {type="healing", time_factor=4000, noup=2.0, beamColor1={0x8e/255, 0x2f/255, 0xbb/255, 1}, beamColor2={0xe7/255, 0x39/255, 0xde/255, 1}, circleColor={0,0,0,0}, beamsCount=5}))
			eff.particle2 = self:addParticles(Particles.new("shader_shield", 1, {toback=false, size_factor=1.5, y=-0.3, img="healarcane"}, {type="healing", time_factor=4000, noup=1.0, beamColor1={0x8e/255, 0x2f/255, 0xbb/255, 1}, beamColor2={0xe7/255, 0x39/255, 0xde/255, 1}, circleColor={0,0,0,0}, beamsCount=5}))
		end
	end,
	deactivate = function(self, eff)
		self:removeParticles(eff.particle1)
		self:removeParticles(eff.particle2)
	end,
}

newEffect{
	name = "ULTIMATE_POWER", image = "talents/supercharge_golem_new.png",
	desc = _t"Ultimate power",
	long_desc = function(self, eff) return ("The target gains ultimate power, increasing stats by %d and damage done by %d%%, and dealing %0.2f elemental damage in radius 6 each turn."):tformat(eff.stats, eff.power, eff.dam) end,
	type = "magical",
	subtype = { arcane=true },
	status = "beneficial",
	parameters = { speed=10 },
	on_gain = function(self, eff) return _t"#Target# is overloaded with power.", _t"+Ultimate power" end,
	on_lose = function(self, eff) return _t"#Target# seems less dangerous.", _t"-Ultimate power" end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "inc_damage", {all=eff.power})
		self:effectTemporaryValue(eff, "inc_stats", {
		            [Stats.STAT_STR] = math.floor(eff.stats or 1),
        			[Stats.STAT_DEX] = math.floor(eff.stats or 1),
        			[Stats.STAT_MAG] = math.floor(eff.stats or 1),
        			[Stats.STAT_WIL] = math.floor(eff.stats or 1),
        			[Stats.STAT_CUN] = math.floor(eff.stats or 1),
        			[Stats.STAT_CON] = math.floor(eff.stats or 1),
        		})
		if core.shader.active(4) then
			eff.particle1 = self:addParticles(Particles.new("shader_shield", 1, {toback=true,  size_factor=1.5, y=-0.3, img="healarcane"}, {type="healing", time_factor=4000, noup=2.0, beamColor1={0x8e/255, 0x2f/255, 0xbb/255, 1}, beamColor2={0xe7/255, 0x39/255, 0xde/255, 1}, circleColor={0,0,0,0}, beamsCount=5}))
			eff.particle2 = self:addParticles(Particles.new("shader_shield", 1, {toback=false, size_factor=1.5, y=-0.3, img="healarcane"}, {type="healing", time_factor=4000, noup=1.0, beamColor1={0x8e/255, 0x2f/255, 0xbb/255, 1}, beamColor2={0xe7/255, 0x39/255, 0xde/255, 1}, circleColor={0,0,0,0}, beamsCount=5}))
		end
	end,
	deactivate = function(self, eff)
		self:removeParticles(eff.particle1)
		self:removeParticles(eff.particle2)
	end,
	on_timeout = function(self, eff)
        local tg = {type="ball", x=self.x, y=self.y, radius=6, friendlyfire=false}
        local dam = eff.dam or 1
        local damtype = rng.tableRemove({DamageType.FIRE, DamageType.COLD, DamageType.LIGHTNING, DamageType.ACID})
        self:project(tg, self.x, self.y, damtype, self:spellCrit(dam))

        if core.shader.active() then game.level.map:particleEmitter(self.x, self.y, tg.radius, "ball_lightning_beam", {radius=tg.radius}, {type="lightning"})
        else game.level.map:particleEmitter(self.x, self.y, tg.radius, "ball_lightning_beam", {radius=tg.radius}) end

        game:playSoundNear(self, "talents/lightning")
    end,
}

newEffect {
	name = "FIRE_BURNT", image = "talents/flame.png",
	desc = _t"Fire Burnt",
	long_desc = function(self, eff)
		return ("The target is burnt by the fiery fire, reducing damage dealt by %d%%"):tformat(eff.reduce)
	end,
	type = "physical",
	subtype = { fire=true }, no_ct_effect = true,
	status = "detrimental",
	parameters = { reduce = 1 },
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "numbed", eff.reduce)
	end,
}

newEffect {
	name = "FROST_SHIELD", image = "talents/frost_shield.png",
	desc = _t"Frost Shield",
	long_desc = function(self, eff)
		return ("The target is protected by the frost, reducing all damage except fire by %d%%, and reducing critical damage received by %d%%."):tformat(eff.power, eff.critdown or 0)
	end,
	type = "magical",
	subtype = { ice = true },
	status = "beneficial",
	parameters = {},
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "ignore_direct_crits", eff.critdown or 0)
	end,
	callbackOnTakeDamage = function(self, eff, src, x, y, type, dam, state)
		if type == DamageType.FIRE then return end
		local d_color = DamageType:get(type).text_color or "#ORCHID#"
		local reduce = dam * util.bound(eff.power, 0, 1)
		if reduce > 0 then
			game:delayedLogDamage(src, self, 0, ("%s(%d frost reduce#LAST#%s)#LAST#"):tformat(d_color, reduce, d_color), false)
		else
			reduce = 0
		end
		return {dam = dam - reduce}
	end,

}