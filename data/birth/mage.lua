getBirthDescriptor("class", "Mage").descriptor_choices.subclass["New Alchemist"] = "allow"
newBirthDescriptor {
    type = "subclass",
    name = "New Alchemist",
    desc = {
        _t "An Alchemist is a manipulator of materials using magic.",
        _t "They do not use the forbidden arcane arts practised by the mages of old - such perverters of nature have been shunned or actively hunted down since the Spellblaze.",
        _t "Alchemists can transmute gems to bring forth elemental effects, turning them into balls of fire, torrents of acid, and other effects.  They can also reinforce armour with magical effects using gems, and channel arcane staffs to produce bolts of energy.",
        _t "Though normally physically weak, most alchemists are accompanied by magical golems which they construct and use as bodyguards.  These golems are enslaved to their master's will, and can grow in power as their master advances through the arts.",
        _t "Their most important stats are: Magic and Constitution",
        _t "#GOLD#Stat modifiers:",
        _t "#LIGHT_BLUE# * +0 Strength, +0 Dexterity, +3 Constitution",
        _t "#LIGHT_BLUE# * +5 Magic, +1 Willpower, +0 Cunning",
        _t "#GOLD#Life per level:#LIGHT_BLUE# -1",
    },
    power_source = { arcane = true },
    not_on_random_boss = true, -- many talents haven't write proper ai tactics yet
    stats = { mag = 5, con = 3, wil = 1, },
    birth_example_particles = {
        function(actor)
            actor:addShaderAura("body_of_fire", "awesomeaura", { time_factor = 3500, alpha = 1, flame_scale = 1.1 }, "particles_images/wings.png")
        end,
        function(actor)
            actor:addShaderAura("body_of_ice", "crystalineaura", {}, "particles_images/spikes.png")
        end,
    },
    talents_types = {
        ["spell/new-explosive"] = { true, 0.3 },
        ["spell/new-golemancy"] = { true, 0.3 },
        ["spell/gem-spell"] = { true, 0.3 },
        ["spell/alchemy-potion"] = { true, 0.3 },
        ["spell/alchemy-potions"] = { true, 0.3 },
        ["spell/explosion-control"] = { false, 0.3 },

        ["spell/new-advanced-golemancy"] = { false, 0.3 },
        ["spell/elemental-alchemy"] = { false, 0.3 },

        ["spell/stone-alchemy"] = { true, 0.3 },
        ["spell/staff-combat"] = { true, 0.3 },
        ["cunning/survival"] = { true, 0 },
        ["spell/divination"] = { false, 0 },
    },
    talents = {
        --[ActorTalents.T_GOLEM_POWER_NEW] = 1,
        [ActorTalents.T_THROW_BOMB_NEW] = 1,
        [ActorTalents.T_CHANNEL_STAFF] = 1,
    },
    copy = {
        max_life = 90,
        mage_equip_filters,
        resolvers.auto_equip_filters { QUIVER = { type = "gem" } },
        resolvers.equipbirth { id = true,
                               { type = "weapon", subtype = "staff", name = "elm staff", autoreq = true, ego_chance = -1000 },
                               { type = "armor", subtype = "cloth", name = "linen robe", autoreq = true, ego_chance = -1000 }
        },
        resolvers.generic(function(self)
            self:birth_create_alchemist_golem()
        end),
        innate_alchemy_golem = true,
        birth_create_alchemist_golem = function(self)
            local gem = game.zone:makeEntityByName(game.level, "object", "GEM_AGATE")
            if gem then
                self:addObject(self:getInven("QUIVER"), gem)
            end
            if not self.alchemy_golem then
                local t = self:getTalentFromId(self.T_REFIT_GOLEM_NEW)
                t.invoke_golem(self, t)
            end
        end,
    },
    copy_add = {
        life_rating = -1,
    },
    cosmetic_options = {
        golem = {
            { name = _t "Golem becomes a Drolem", on_actor = function(actor)
                actor.alchemist_golem_is_drolem = true
            end, unlock = "cosmetic_class_alchemist_drolem" },
        },
    },
}