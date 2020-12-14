local _M = loadPrevious(...)

local _addObject = _M.addObject

function _M:addObject(inven_id, o, no_unstack, force_item)
    local inven = self:getInven(inven_id)
    local inven2 = self:getInven("QUIVER")
    if o and o.type == "gem" and inven and inven == inven2 then
        --quick fix: gems cannot stack in quiver
        --need find a more delegate solution
        return _addObject(self, inven_id, o, true, force_item)
    end
    return _addObject(self, inven_id, o, no_unstack, force_item)
end

return _M