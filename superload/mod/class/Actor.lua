local _M = loadPrevious(...)
local Talents = require "engine.interface.ActorTalents"
_M.sustainCallbackCheck.callbackOnAlchemistBomb = "talents_on_alchemist_bomb"
local _getObjectOffslot = _M.getObjectOffslot
function _M:getObjectOffslot(o)
    if o.type == "gem" then
        return "GEM"
    end
    return _getObjectOffslot(self, o)
end

function _M:checkCanWearGem()
    local tl = { self.T_THROW_BOMB_NEW, self.T_REFIT_GOLEM_NEW, self.T_GEM_BLAST, self.T_GEM_S_RADIENCE, self.T_FLICKERING_GEM, self.T_ONE_WITH_GEM, self.T_GEM_PORTAL
    , self.T_GEM_GOLEM_NEW }
    for i = 1, #tl do
        if self:knowTalent(tl[i]) then
            if not self:attr("gem related talents") then
                self:attr("gem related talents", 1)
                return
            end
            return
        end
    end
    if self:attr("gem related talents") then
        self:attr("gem related talents", -1)
    end
end

function _M:getAllPotions()
    return Talents.alchemy_potion_tids
end

function _M:getPotionInfo(t)
    local tid = t
    if type(tid) == "table" then
        tid = t.id
    end
    local potions = self.alchemy_potions
    if not potions then
        self.alchemy_potions = {}
        potions = self.alchemy_potions
    end
    local potion = potions[tid]
    if not potion then
        potions[tid] = { nb = 0, turn = 0, max = 0 }
        potion = potions[tid]
    end
    return potion
end

function _M:getPreparedPotionCharges(t)
    local potion = self:getPotionInfo(t)
    return potion.max or 0
end

function _M:getMaxPreparedPotions()
    if self:knowTalent(self.T_MANAGE_POTION_1) then
        return self:callTalent(self.T_MANAGE_POTION_1, "getMaxCharges") or 0
    end
    return 0
end

function _M:getAllPreparedPotionCharges()
    local potions = self.alchemy_potions
    if not potions then
        return 0
    end
    local nb = 0
    local potion_tids = self:getAllPotions()
    for _, tid in ipairs(potion_tids) do
        local potion = potions[tid] or { nb = 0, turn = 0, max = 0 }
        nb = nb + (potion.max or 0)
    end
    return nb
end

function _M:restoreAllPotions(t)
    local potions = self.alchemy_potions or {}
    for tid, info in pairs(potions) do
        info.nb = info.max or 0
    end
end

function _M:unprepareAlchemyPotion(t)
    local tid = t
    if type(tid) == "table" then
        tid = t.id
    end
    local potions = self.alchemy_potions
    if not potions then
        self.alchemy_potions = {}
        potions = self.alchemy_potions
    end
    local potion = potions[tid]
    if not potion then
        return nil
    end
    potion.max = (potion.max or 0) - 1
    if potion.max <= 0 then
        potions[tid] = nil
        self:unlearnTalentFull(tid)
        return true
    end
    potion.nb = util.bound(potion.nb, 0, potion.max)
    return true
end

function _M:prepareAlchemyPotion(t)
    local max = self:getMaxPreparedPotions()
    local cur = self:getAllPreparedPotionCharges()
    if cur >= max then return end
    local tid = t
    if type(t) == "table" then tid = t.id end
    if not self:callTalent(t, "allowUse") then
        return nil
    end
    local potion = self:getPotionInfo(t)
    if (potion.max or 0) <= 0 then
        potion.max = 1
    else
        local talent = self:getTalentFromId(tid)
        if talent.isSpecialPotion and (potion.max or 0) >= 1 then
            potion.max = 1
            game.logPlayer(self, "You cannot prepare more than one bottle of special potions")
        else
            potion.max = (potion.max or 0) + 1
        end
    end
    potion.nb = util.bound((potion.nb or 0) + 1, 0, potion.max)
    if not self:knowTalent(t) then
        self:learnTalent(t, true, self:getTalentLevelRaw(self.T_MANAGE_POTION_1), { no_unlearn = true })
    end
    return true
end
return _M