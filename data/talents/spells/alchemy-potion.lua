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
}
Talents.alchemy_potion_tids = alchemy_potion_tids

function alchemy_potions_setup(self, t)
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

function alchemy_potions_adjust_pre_use(self, t, silent)
    if self == game.player and self.in_combat then
        if not silent then
            game.logPlayer(self, "You can only prepare your potions outside of combat.")
        end
        return false
    end
    return true
end

--- generate a textual list of available artifice tools
function alchemy_potions_get_descs(self, t)
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
function alchemy_potions_npc_select(self, t, silent, fake)
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
    name = "Alchemy Potion", short_name = "MANAGE_POTION_1",
    type = { "spell/alchemy-potion", 1 },
    points = 5,
    require = spells_req1,
    cooldown = 15,
    no_unlearn_last = true,
    on_pre_use = alchemy_potions_adjust_pre_use,
    tactical = { BUFF = 2 },
    on_pre_use_ai = alchemy_potions_npc_select, -- NPC's automatically pick a tool
    action = function(self, t)
        local chat = Chat.new("prepare-alchemy-potions", self, self, { player = self, slot = 1, chat_tid = t.id, tool_ids = alchemy_potion_tids })
        local d = chat:invoke()
        d.key:addBinds { EXIT = function()
            game:unregisterDialog(d)
        end }
        local tool_id = self:talentDialog(d)
        alchemy_potions_setup(self, t)
        --self:updateModdableTile()
        return tool_id ~= nil -- only use energy/cooldown if a tool was prepared
    end,
    info = function(self, t)
        local descs = alchemy_potions_get_descs(self, t)
        return ([[With some advanced preparation, you learn to create and equip one of a number of useful potions (at #YELLOW#level %d#WHITE#):

%s
Preparing a tool sets its talent level and puts it on cooldown.
You cannot change your potions in combat. Potions have limited use and can be restored after combat.
]]):tformat(self:getTalentLevelRaw(t), descs)
    end,
}

newTalent {
    name = "Elixir Potion", short_name = "MANAGE_POTION_2",
    type = { "spell/alchemy-potion", 2 },
    points = 5,
    require = spells_req2,
    cooldown = 15,
    no_unlearn_last = true,
    on_pre_use = alchemy_potions_adjust_pre_use,
    tactical = { BUFF = 2 },
    on_pre_use_ai = alchemy_potions_npc_select, -- NPC's automatically pick a tool
    action = function(self, t)
        local chat = Chat.new("prepare-alchemy-potions", self, self, { player = self, slot = 1, chat_tid = t.id, tool_ids = alchemy_potion_tids })
        local d = chat:invoke()
        d.key:addBinds { EXIT = function()
            game:unregisterDialog(d)
        end }
        local tool_id = self:talentDialog(d)
        alchemy_potions_setup(self, t)
        --self:updateModdableTile()
        return tool_id ~= nil -- only use energy/cooldown if a tool was prepared
    end,
    info = function(self, t)
        local descs = alchemy_potions_get_descs(self, t)
        return ([[With some advanced preparation, you learn to create and equip one of a number of useful potions (at #YELLOW#level %d#WHITE#):

%s
Preparing a tool sets its talent level and puts it on cooldown.
You cannot change your potions in combat. Potions have limited use and can be restored after combat.
]]):tformat(self:getTalentLevelRaw(t), descs)
    end,
}

newTalent {
    name = "Magical Potion", short_name = "MANAGE_POTION_3",
    type = { "spell/alchemy-potion", 3 },
    points = 5,
    require = spells_req3,
    cooldown = 15,
    no_unlearn_last = true,
    on_pre_use = alchemy_potions_adjust_pre_use,
    tactical = { BUFF = 2 },
    on_pre_use_ai = alchemy_potions_npc_select, -- NPC's automatically pick a tool
    action = function(self, t)
        local chat = Chat.new("prepare-alchemy-potions", self, self, { player = self, slot = 1, chat_tid = t.id, tool_ids = alchemy_potion_tids })
        local d = chat:invoke()
        d.key:addBinds { EXIT = function()
            game:unregisterDialog(d)
        end }
        local tool_id = self:talentDialog(d)
        alchemy_potions_setup(self, t)
        --self:updateModdableTile()
        return tool_id ~= nil -- only use energy/cooldown if a tool was prepared
    end,
    info = function(self, t)
        local descs = alchemy_potions_get_descs(self, t)
        return ([[With some advanced preparation, you learn to create and equip one of a number of useful potions (at #YELLOW#level %d#WHITE#):

%s
Preparing a tool sets its talent level and puts it on cooldown.
You cannot change your potions in combat. Potions have limited use and can be restored after combat.
]]):tformat(self:getTalentLevelRaw(t), descs)
    end,
}

newTalent {
    name = "Ingredient Recycle",
    type = { "spell/alchemy-potion", 4 },
    points = 5,
    require = spells_req4,
    mode = "passive",
    getChance = function(self, t)
        return self:combatTalentScale(t, 10, 25)
    end,
    callbackOnAlchemistBomb = function(self, t)
        local chance = t.getChance(self, t)
        if rng.percent(chance) then
            local avail = {}
            for _, tid in pairs(alchemy_potion_tids) do
                if self:knowTalent(tid) then
                    if self:callTalent(tid, "charge") < self:callTalent(tid, "max_charge") then
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
        end
    end,
    info = function(self, t)
        return ([[You know how to reuse the remain of your potions.
        After throwing bomb, you have %d%% chance to reproduce a random potion.]]):tformat(t.getChance(self, t))
    end,

}