local _M = loadPrevious(...)
_M.sustainCallbackCheck.callbackOnAlchemistBomb = "talents_on_alchemist_bomb"
local _getObjectOffslot = _M.getObjectOffslot
function _M:getObjectOffslot(o)
    if o.type == "gem" then return "GEM" end
    return _getObjectOffslot(self, o)
end


return _M