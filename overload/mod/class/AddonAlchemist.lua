local class = require "class"
local Birther = require "engine.Birther"
local ActorTalents = require "engine.interface.ActorTalents"
local ActorTemporaryEffects = require "engine.interface.ActorTemporaryEffects"
local Entity = require "engine.Entity"

module(..., package.seeall, class.make)
function hookLoad()
    ActorTemporaryEffects:loadDefinition("/data-new-alchemist/timed_effects.lua")
    ActorTalents:loadDefinition("/data-new-alchemist/talents.lua")
    Birther:loadDefinition("/data-new-alchemist/birth/mage.lua")
end

function hookStartTalentCooldown(self, data)
    local t = data.t
    if t.id == self.T_THROW_BOMB_NEW and self:knowTalent(self.T_CHAIN_BLASTING) then
        local chance = self:callTalent(self.T_CHAIN_BLASTING, "getChance")
        if rng.percent(chance) then
            data.cd = 0
            return true
        end
    end
end

function hookMinimalistResources(self, data)
    local player = data.player
    local potions = player.alchemy_potions
    if not potions then
        return data
    end

    local x = data.x
    local y = data.y
    local width, height = 64, 64
    local showed
    for tid, info in pairs(potions) do
        if player:knowTalent(tid) then
            local talent = player:getTalentFromId(tid)
            local nb = info.nb or 0
            while nb > 0 do
                showed = true
                local image = Entity.new { image = talent.icon }
                image:toScreen(nil, x, y, width, height)
                x = x + 32
                nb = nb - 1
            end
        end
    end
    if showed then
        data.y = y + height + 5
    end
    return data
end
function hookClassicResources(self, data)
    local player = data.player
    local potions = player.alchemy_potions
    if not potions then
        return data
    end

    local x = data.x
    local h = data.h
    local showed
    for tid, info in pairs(potions) do
        if player:knowTalent(tid) then
            local talent = player:getTalentFromId(tid)
            local nb = info.nb or 0
            local max = info.max or 0
            if max > 0 then
                showed = true
                self:mouseTooltip("This are your prepared alchemy potions",
                        self:makeTexture(("#ANTIQUE_WHITE#%s: #ffffff#%d / %d"):tformat(talent.name, nb, max),
                                0, h, 255, 255, 255))
                h = h + self.font_h
            end
        end
    end
    if showed then
        data.h = h
    end
    return data
end

dofile("data-new-alchemist/gems.lua")
function hookEntityLoadList(self, data)
    if type(game) ~= "table" or not game.state then
        return
    end
    local file = data.file
    local info = artifact_gems[file]
    if not info then
        return
    end
    for _, item in ipairs(data.res) do
        local name = item.name
        if name and info[name] then
            local t = info[name]
            for k, v in pairs(t) do
                if not item[k] then
                    item[k] = v
                end
            end
        end
    end
end