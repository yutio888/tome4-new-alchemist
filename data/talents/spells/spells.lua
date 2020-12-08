newTalentType{ allow_random=true, no_silence=true, is_spell=true, mana_regen=true, type="spell/new-explosive", name = _t"explosive admixtures", description = _t"Manipulate gems to turn them into explosive magical bombs." }
newTalentType{ allow_random=true, no_silence=true, is_spell=true, mana_regen=true, type="spell/new-golemancy", name = _t"golemancy",speed = "standard", description = _t"Learn to craft and upgrade your golem." }
newTalentType{ allow_random=true, no_silence=true, is_spell=true, mana_regen=true, type="spell/new-advanced-golemancy", name = _t"advanced-golemancy", min_lev = 10, speed = "standard", description = _t"Advanced golem operations." }
newTalentType{ allow_random=true, no_silence=true, is_spell=true, mana_regen=true, type="spell/elemental-alchemy", name = _t"elemental alchemy", min_lev = 10, description = _t"Alchemical spells designed to wage war." }
newTalentType{ allow_random=true, no_silence=true, is_spell=true, mana_regen=true, type="spell/new-golemancy-base", name = _t"golemancy", speed = "standard", hide = true, description = _t"Learn to craft and upgrade your golem." }
newTalentType{ allow_random=true, is_spell=true, type="spell/gem-spell", name=_t"gem spell", description=_t"invoke your gem power."}
newTalentType{ allow_random=true, is_spell=true, type="spell/alchemy-potion", name=_t"alchemy potions", description=_t"prepare some alchemy potions."}
newTalentType{ allow_random=true, is_spell=true, type="spell/alchemy-potions", name=_t"alchemy potions", description=_t"some useful alchemy potions."}

damDesc = Talents.main_env.damDesc
spells_req1 = Talents.main_env.spells_req1
spells_req2 = Talents.main_env.spells_req2
spells_req3 = Talents.main_env.spells_req3
spells_req4 = Talents.main_env.spells_req4
spells_req5 = Talents.main_env.spells_req5

spells_req_high1 = Talents.main_env.spells_req_high1
spells_req_high2 = Talents.main_env.spells_req_high2
spells_req_high3 = Talents.main_env.spells_req_high3
spells_req_high4 = Talents.main_env.spells_req_high4
spells_req_high5 = Talents.main_env.spells_req_high5
load("/data-new-alchemist/talents/spells/elemental-infusion.lua")
load("/data-new-alchemist/talents/spells/new-explosive.lua")
load("/data-new-alchemist/talents/spells/new-golemancy.lua")
load("/data-new-alchemist/talents/spells/new-advanced-golemancy.lua")
load("/data-new-alchemist/talents/spells/gem-spell.lua")
load("/data-new-alchemist/talents/spells/alchemy-potions.lua")
load("/data-new-alchemist/talents/spells/alchemy-potion.lua")