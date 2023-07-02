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
    --"T_LUCK_POTION",
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
    return table.concatNice(tool_descs, "\n")
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
    no_npc_use = true,
    --on_pre_use_ai = alchemy_potions_npc_select, -- NPC's automatically pick a tool
    action = function(self, t)
        if self:talentDialog(require("mod.dialogs.talents.PrepareAlchemistPotion").new(self)) then
            return true
        end
        return nil
    end,
    passives = function(self, t)
        self:setTalentTypeMastery("spell/alchemy_potions", self:getTalentMastery(t))
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
        return ([[With some advanced preparation, you learn to create and equip %d of a number of useful potions (at #YELLOW#level %d#WHITE#).
You may throw your potion as far as you can throw bomb.
Preparing a potion sets its talent level and puts it on cooldown.
You cannot change your potions in combat. Potions have limited use and can be restored after combat.

%s
]]):tformat(t.getMaxCharges(self, t), self:getTalentLevelRaw(t), descs)
    end,
}

newTalent {
    name = "Reproduce", short_name = "MANAGE_POTION_2",
    type = { "spell/alchemy-potion", 2 },
    points = 5,
    require = spells_req2,
    cooldown = function(self, t)
        return 5
    end,
    sustain_mana = 10,
    mode = "sustained",
    no_npc_use = true,
    no_energy = true,
    getDuration = function(self, t)
        return math.ceil(15 - self:combatTalentLimit(t, 12, 3, 6))
    end,
    iconOverlay = function(self, t, p)
        if not p then
            return ""
        end
        return tostring("#RED##{bold}#" .. math.floor(p.dur or 0) .. "#LAST##{normal}#"), "buff_font_small"
    end,
    activate = function(self, t)
        return {
            dur = t.getDuration(self, t)
        }
    end,
    deactivate = function(self, t, p)
        return true
    end,
    callbackPriorities = { callbackOnHit = 100 },
    callbackOnHit = function(self, t, cb, src, death_note)
        local value = cb.value
        local res = self:checkHit(self:combatPhysicalResist(), value)
        res = res or self:checkHit(self:combatSpellResist(), value)
        if not res then
            game.logPlayer(self, "%s got disrupted by the incoming damage, stopped reproducing potions.", self:getName())
            local p = self:isTalentActive(t.id)
            p.dur = t.getDuration(self, t)
        end
    end,
    callbackOnActBase = function(self, t)
        local p = self:isTalentActive(t.id)
        if not p then
            return
        end
        p.dur = p.dur - 1
        if p.dur <= 0 then
            game.logPlayer(self, "%s reproduce all the potions.", self:getName())
            game:playSoundNear(self, "talents/spell_generic")
            self:restoreAllPotions()
            p.dur = t.getDuration(self, t)
            return
        end
    end,
    info = function(self, t)
        local p = self:isTalentActive(t.id)
        local desc = ""
        if p then
            desc = ([[Remaining turns: %d .]]):tformat(p.dur)
        end
        return ([[Enter the focused state of reproducing potions。 Every %d turns, you will recharge all your alchemy potions.
        Reproduing potions need focus, any incoming damage may break this state. Every time you are damaged, you must check your physical/spell save to preverse focus. If you fail to save, your reproduction will reset.
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
        Besides, learning this talent will make your potions cost %d%% less turn.
        ]]):tformat(100 - t.getSpeedUp(self, t))
    end,
}

newTalent {
    name = "Ingredient Recycle", short_name = "INGREDIENT_RECYCLE",
    type = { "spell/alchemy-potion", 4 },
    points = 5,
    require = spells_req4,
    mana = 10,
    no_npc_use = true,
    cooldown = 25,
    getPp = function(self, t)
        return math.ceil(self:combatTalentLimit(t, 200, 30, 100))
    end,
    on_pre_use = function(self, t)
        return (self._potion_pts or 0) > 0
    end,
    callbackOnPotion = function(self, t)
        self._potion_pts = (self._potion_pts or 0) + t.getPp(self, t)
        self._potion_pts_turns = 6
        self:setEffect(self.EFF_POTION_RECYCLE, 6, {})
    end,
    callbackOnActBase = function(self, t)
        if self._potion_pts_turns then
            self._potion_pts_turns = self._potion_pts_turns -1
            if self._potion_pts_turns <= 0 then
                self._potion_pts_turns = nil
                self._potion_pts = 0
                self:removeEffect(self.EFF_POTION_RECYCLE)
            else
                self._potion_pts = math.ceil(self._potion_pts * 0.9)
            end
        end
    end,
    is_heal = true,
    action = function(self, t)
        local pts = self._potion_pts
        self._potion_pts = nil
        self._potion_pts_turns = nil
        pts = self:spellCrit(pts)
        local nb = math.floor(pts / 100)
        local avail = {}
        for _, tid in pairs(alchemy_potion_tids) do
            if self:knowTalent(tid) then
                local talent = self:getTalentFromId(tid)
                if self:callTalent(tid, "charge") < self:callTalent(tid, "max_charge") then
                    local v = self:callTalent(tid, "max_charge") - self:callTalent(tid, "charge")
                    for i = 1, v do
                        avail[#avail + i] = tid
                        i = i + 1
                    end
                end
            end
            while #avail > 0 and nb > 0 do
                local potion = rng.tableRemove(avail)
                if potion then
                    self:callTalent(potion, "recharge", 1)
                end
                nb = nb - 1
            end
        end
        self:heal(pts)
        return true
    end,
    info = function(self, t)
        return ([[You know how to reuse the remain of your potions.
        Every time you consume a potion, you store %d power (current %d ).
        The stored power last 6 turns, and reduces by 10%% each turn not consumed.
        You may activate this talent to release the power as a heal, and every 100 point you heal (before healing mod), you'll regain a potion.
        The heal can crit.]]):tformat(t.getPp(self, t), self._potion_pts or 0)
    end,
}