local _M = loadPrevious(...)

local _refit = Talents.talents_def['T_REFIT_GOLEM']
local invoke = _refit.invoke_golem
_refit.invoke_golem = function(self, t)
    invoke(self, t)
    self.alchemy_golem:attr("gem related talents", 1)
end
local _action = _refit.action
_refit.action = function(self, t)
    if self.alchemy_golem and not self.alchemy_golem:attr("gem related talents") then
        self.alchemy_golem:attr("gem related talents", 1)
    end
    _action(self, t)
end
local onLearn = _refit.on_learn
_refit.on_learn = function(self, t)
    if self.alchemy_golem and not self.alchemy_golem:attr("gem related talents") then
        self.alchemy_golem:attr("gem related talents", 1)
    end
    onLearn(self, t)
end
return _M