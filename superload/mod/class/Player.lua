local _M = loadPrevious(...)

local _runStopped = _M.runStopped
function _M:runStopped()
    local hostile = _M.spotHostiles(self)
    if #hostile >= 1 and self:getTalentLevel(self.T_DYNAMIC_RECHARGE_NEW) >= 6 then
        self:useTalent(self.T_DYNAMIC_RECHARGE_NEW)
    end
    return _runStopped(self)
end

local _restCheck = _M.restCheck

function _M:restCheck()
    local res, info = _restCheck(self)
    if not res then
        local potions = self:getAllPotions()
        for _, tid in pairs(potions) do
            if self:knowTalent(tid) then
                if self.alchemy_potions[tid] and self.alchemy_potions[tid].nb <= 0 then
                    self.resting.rest_fully = false
                    self.resting.cnt = 10
                    return true
                end
            end
        end
    end
    return res, info
end
return _M