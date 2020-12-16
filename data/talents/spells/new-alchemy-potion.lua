local DamageType = require "engine.DamageType"
local Object = require "engine.Object"
local Map = require "engine.Map"
local Chat = require "engine.Chat"
local Talents = require "engine.interface.ActorTalents"

-- equipable artifice tool talents and associated mastery talents
-- to add a new tool, define a tool talent and a mastery talent and update this table
alchemy_potion_tids = {
    "T_SMOKE_POTION",
    "T_HEALING_POTION",
    "T_ACID_POTION",
    "T_FIRE_POTION",
    "T_FROST_POTION",
    "T_LIGHTNING_POTION",
    "T_STONE_POTION",
    "T_ARCANE_POTION",
    "T_LUCK_POTION",
    "T_SPEED_POTION",
}
Talents.alchemy_potion_tids = alchemy_potion_tids

local function alchemy_potions_setup(self, t)
    self.alchemy_potions = self.alchemy_potions or {}
    self:setTalentTypeMastery("spell/alchemy_potions", self:getTalentMastery(t))
    for _, tid in pairs(alchemy_potion_tids) do
        if self:knowTalent(tid) then
            local slot
            for slot_id, tool_id in pairs(self.alchemy_potions) do
                if tool_id == tid then
                    slot = slot_id
                    break
                end
            end
            if not slot then
                self:unlearnTalentFull(tid)
            end
        end
    end
    return true
end

local function alchemy_potions_adjust_pre_use(self, t, silent)
    if self == game.player and self.in_combat then
        if not silent then
            game.logPlayer(self, "You can only prepare your potions outside of combat.")
        end
        return false
    end
    return true
end

--- generate a textual list of available artifice tools
local function alchemy_potions_get_descs(self, t)
    if not self.alchemy_potions then
        alchemy_potions_setup(self, t)
    end
    local tool_descs = {}
    for _, tool_id in pairs(alchemy_potion_tids) do
        local tool, desc = self:getTalentFromId(tool_id)
        if tool.allowUse(self, tool) then
            local prepped = self.alchemy_potions[t.id] == tool_id
            if prepped then
                desc = ("#YELLOW#%s (prepared, level %s)#LAST#:\n"):tformat(tool.name, self:getTalentLevelRaw(tool))
            else
                desc = tool.name .. ":\n"
            end
            if tool.short_info then
                desc = desc .. tool.short_info(self, tool, t) .. "\n"
            else
                desc = desc .. _t "#GREY#(see talent description)#LAST#\n"
            end
            tool_descs[#tool_descs + 1] = desc
        end
    end
    return table.concatNice(tool_descs, "\n\t")
end

--- NPC's automatically pick a tool for each tool slot if needed
-- used as the talent on_pre_use_ai function
-- this causes newly spawned NPC's to prepare their tools the first time they check for usable talents
local function alchemy_potions_npc_select(self, t, silent, fake)
    if not self.alchemy_potions[t.id] then
        -- slot is empty: pick a tool
        local tool_ids = table.keys(alchemy_potion_tids)
        local tid = rng.tableRemove(tool_ids)
        while tid do
            if not self:knowTalent(tid) then
                -- select the tool
                self:learnTalent(tid, true, self:getTalentLevelRaw(t), { no_unlearn = true })
                self.alchemy_potions[t.id] = tid
                if game.party:hasMember(self) then
                    -- cooldowns for party members
                    self:startTalentCooldown(t)
                    self:startTalentCooldown(tid)
                    self:useEnergy()
                end
                game.logSeen(self, "#GREY#You notice %s has prepared: %s.", self:getName():capitalize(), self:getTalentFromId(tid).name)
                break
            end
            tid = rng.tableRemove(tool_ids)
        end
    end
    return false -- npc's don't need to actually use the tool slot talents
end

newTalent {
    name = "Potion Mastery", short_name = "MANAGE_POTION_1",
    type = { "spell/alchemy-potion", 1 },
    points = 5,
    require = spells_req1,
    cooldown = 15,
    no_unlearn_last = true,
    on_pre_use = alchemy_potions_adjust_pre_use,
    getMaxCharges = function(self, t)
        return math.floor(self:combatTalentLimit(t, 7, 1, 4))
    end,
    --on_pre_use_ai = alchemy_potions_npc_select, -- NPC's automatically pick a tool
    action = function(self, t)
        if self:talentDialog(require("mod.dialogs.talents.PrepareAlchemistPotion").new(self)) then
            return true
        end
        return nil
    end,
    on_learn = function(self, t)
        self:setTalentTypeMastery("spell/alchemy_potions", self:getTalentMastery(t))
        for _, tid in ipairs(alchemy_potion_tids) do
            if self:knowTalent(tid) then
                local tl = self:getTalentLevelRaw(tid)
                if tl ~= self:getTalentLevelRaw(t) then
                    self:learnTalent(tid, true, self:getTalentLevelRaw(t) - tl)
                end
            end
        end
    end,
    on_unlearn = function(self, t)
        for _, tid in ipairs(alchemy_potion_tids) do
            if self:knowTalent(tid) then
                self:unlearnTalentFull(tid)
                if self:getTalentLevelRaw(t) > 0 then
                    self:learnTalent(tid, true, self:getTalentLevelRaw(t))
                end
            end
        end
    end,
    info = function(self, t)
        local descs = alchemy_potions_get_descs(self, t)
        return ([[With some advanced preparation, you learn to create and equip %d of a number of useful potions (at #YELLOW#level %d#WHITE#):

%s
Preparing a potion sets its talent level and puts it on cooldown.
You cannot change your potions in combat. Potions have limited use and can be restored after combat.
]]):tformat(t.getMaxCharges(self, t), self:getTalentLevelRaw(t), descs)
    end,
}

newTalent {
    name = "Reproduce", short_name = "MANAGE_POTION_2",
    type = { "spell/alchemy-potion", 2 },
    points = 5,
    require = spells_req2,
    cooldown = function(self, t)
        return self:combatTalentScale(self:getTalentLevelRaw(t) * self:getTalentMastery(t), 20, 10, "log")
    end,
    mode = "sustained",
    no_npc_use = true,
    getDuration = function(self, t)
        return math.ceil(15 - util.bound(self:combatTalentScale(self:getTalentLevelRaw(t) * self:getTalentMastery(t), 0, 5, "log"), 0, 10))
    end,
    iconOverlay = function(self, t, p)
        if not p then
            return ""
        end
        return tostring("#RED##{bold}#" .. math.floor(p.dur or 1) .. "#LAST##{normal}#"), "buff_font_small"
    end,
    activate = function(self, t)
        return {
            dur = t.getDuration(self, t)
        }
    end,
    deactivate = function(self, t, p)
        if p.dur <= 0 then
            self:restoreAllPotions()
        end
        return true
    end,
    callbackPriorities = { callbackOnHit = 100 },
    callbackOnHit = function(self, t, cb, src, death_note)
        local value = cb.value
        local save = math.max(self:combatMentalResist(), self:combatPhysicalResist())
        local res = self:checkHit(save, value)
        if not res then
            game.logPlayer(self, "%s got disrupted by the incoming damage, stopped reproducing potions.", self:getName())
            self:forceUseTalent(self.T_MANAGE_POTION_2, { ignore_energy = true })
        end
    end,
    callbackOnActBase = function(self, t)
        local p = self:isTalentActive(t.id)
        if not p then
            return
        end
        p.dur = p.dur - 1
        if p.dur <= 0 then
            self:forceUseTalent(t.id, { ignore_energy = true })
            return
        end
    end,
    info = function(self, t)
        local p = self:isTalentActive(t.id)
        local desc = ""
        if p then
            desc = ([[Remaining turns: %d .]]):tformat(p.dur)
        end
        return ([[Enter the focused state of reproducing potions for %d turns, after which you will recharge all your alchemy potions.
        Reproduing potions need focus, any incoming damage may break this state. Every time you are damaged, you must check your physical or mental save to preverse focus. If you fail to do so, this talent will automatically deactivate.
        %s]]):tformat(t.getDuration(self, t), desc)
    end,
}

newTalent {
    name = "Potion Sprayer", short_name = "MANAGE_POTION_3",
    type = { "spell/alchemy-potion", 3 },
    points = 5,
    require = spells_req3,
    cooldown = 20,
    range = function(self, t)
        return self:combatTalentScale(self:getTalentLevelRaw(t) * self:getTalentMastery(t), 3, 7)
    end,
    mode = "sustained",
    no_npc_use = true,
    getSpeedUp = function(self, t)
        return 100 - math.min(50, 15 + self:combatTalentScale(t, 5, 15))
    end,
    activate = function(self, t)
        return {}
    end,
    deactivate = function(self, t, p)
        return true
    end,
    info = function(self, t)
        return ([[You may spray your potion in cone instead of throw onto a single target.
        However, this will make your potion less effective, your spellpower is considered as half when spraying potions.
        Besides, your potions cost %d%% less turn in this way.
        ]]):tformat(100 - t.getSpeedUp(self, t))
    end,
}

newTalent {
    name = "Ingredient Recycle",
    type = { "spell/alchemy-potion", 4 },
    points = 5,
    require = spells_req4,
    mode = "sustained",
    sustain_mana = 80,
    no_npc_use = true,
    getTime = function(self, t)
        return 10 - math.floor(self:combatTalentLimit(self:getTalentLevelRaw(t) * self:getTalentMastery(t), 10, 0, 6.9))
    end,
    iconOverlay = function(self, t, p)
        if not p then
            return ""
        end
        if not p.time then
            return ""
        end
        if p.time <= 0 then
            return ""
        end
        local str = tostring("#RED##{bold}#" .. math.floor(p.time or 1) .. "#LAST##{normal}#")
        return str, "buff_font_small"
    end,
    activate = function(self, t)
        return {
            time = 0
        }
    end,
    deactivate = function(self, t, p)
        return true
    end,
    callbackOnAlchemistBomb = function(self, t)
        if not self.in_combat then
            return
        end
        local p = self:isTalentActive(t.id)
        if not p then
            return
        end
        p.time = p.time - 1
        if p.time <= 0 then
            p.time = t.getTime(self, t)
            local avail = {}
            for _, tid in pairs(alchemy_potion_tids) do
                if self:knowTalent(tid) then
                    local talent = self:getTalentFromId(tid)
                    if not talent.isSpecialPotion and self:callTalent(tid, "charge") < self:callTalent(tid, "max_charge") then
                        avail[#avail + 1] = tid
                    end
                end
            end
            if #avail > 0 then
                local potion = rng.tableRemove(avail)
                if potion then
                    self:callTalent(potion, "recharge", 1)
                end
            end
            return
        end
    end,
    callbackOnCombat = function(self, t, state)
        local p = self:isTalentActive(t.id)
        if not p then
            return
        end
        if state then
            p.time = t.getTime(self, t)
        else
            p.time = 0
        end
    end,
    info = function(self, t)
        local p = self:isTalentActive(t.id)
        local desc = ""
        if p and p.time > 0 then
            desc = ([[Remaining explosions: %d .]]):tformat(p.time)
        end
        return ([[You know how to reuse the remain of your potions.
        You may restore one bottle of random potion after your bomb explodes %d times in combat.
        Some special potions cannot be restored in this way.
        %s]]):tformat(t.getTime(self, t), desc)
    end,
}