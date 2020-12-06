newTalentType{ allow_random=true, no_silence=true, is_spell=true, mana_regen=true, type="spell/new-explosive", name = _t"explosive admixtures", description = _t"Manipulate gems to turn them into explosive magical bombs." }
newTalentType{ allow_random=true, no_silence=true, is_spell=true, mana_regen=true, type="spell/new-golemancy", name = _t"golemancy", description = _t"Learn to craft and upgrade your golem." }
newTalentType{ allow_random=true, no_silence=true, is_spell=true, mana_regen=true, type="spell/new-advanced-golemancy", name = _t"advanced-golemancy", min_lev = 10, description = _t"Advanced golem operations." }
newTalentType{ allow_random=true, no_silence=true, is_spell=true, mana_regen=true, type="spell/elemental-alchemy", name = _t"elemental alchemy", min_lev = 10, description = _t"Alchemical spells designed to wage war." }

newTalentType{ allow_random=true, no_silence=true, is_spell=true, mana_regen=true, type="spell/new-golemancy-base", name = _t"golemancy", hide = true, description = _t"Learn to craft and upgrade your golem." }
damDesc = Talents.main_env.damDesc
spells_req1 = Talents.main_env.spells_req1
spells_req2 = Talents.main_env.spells_req2
spells_req3 = Talents.main_env.spells_req3
spells_req4 = Talents.main_env.spells_req4
spells_req5 = Talents.main_env.spells_req5

spells_high_req1 = Talents.main_env.spells_high_req1
spells_high_req2 = Talents.main_env.spells_high_req2
spells_high_req3 = Talents.main_env.spells_high_req3
spells_high_req4 = Talents.main_env.spells_high_req4
spells_high_req5 = Talents.main_env.spells_high_req5
load("/data-new-alchemist/talents/spell/elemental-infusion.lua")
load("/data-new-alchemist/talents/spell/new-explosive.lua")
load("/data-new-alchemist/talents/spell/new-golemancy.lua")