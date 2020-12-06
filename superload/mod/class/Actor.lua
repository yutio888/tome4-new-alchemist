local _M = loadPrevious(...)
_M.sustainCallbackCheck.callbackOnAlchemistBomb = "talents_on_alchemist_bomb"
local _getObjectOffslot = _M.getObjectOffslot
function _M:getObjectOffslot(o)
    if o.type == "gem" and o.alchemist_bomb and
     (self:knowTalent(self.T_THROW_BOMB_NEW) or self:knowTalent(self.T_REFIT_GOLEM) or self:knowTalent(self.T_GEM_PORTAL_NEW))
    then return "QUIVER" end
    return _getObjectOffslot(self, o)
end


return _M