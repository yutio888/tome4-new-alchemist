local Talents = require "engine.interface.ActorTalents"
local Map = require "engine.Map"
local _M = loadPrevious(...)

local gem_portal = Talents.talents_def['T_GEM_PORTAL']
if gem_portal then
    gem_portal.action = function(self, t)
        local ammo = self:hasAlchemistWeapon()
        if not ammo then
            game.logPlayer(self, "You need to ready 5 alchemist gems in your quiver.")
            return
        end

        local tg = { type = "bolt", range = self:getTalentRange(t), nolock = true, talent = t, simple_dir_request = true }
        local x, y = self:getTarget(tg)
        if not x or not y then
            return nil
        end
        local _
        _, x, y = self:canProject(tg, x, y)

        local ox, oy = self.x, self.y
        local l = line.new(self.x, self.y, x, y)
        local nextx, nexty = l()
        if not nextx or not game.level.map:checkEntity(nextx, nexty, Map.TERRAIN, "block_move", self) then
            return
        end

        self:probabilityTravel(x, y, t.getRange(self, t))
        self:setProc("trigger_gem", true, 5)

        if ox == self.x and oy == self.y then
            return
        end

        game:playSoundNear(self, "talents/arcane")
        return true
    end
    gem_portal.info = function(self, t)
        local range = t.getRange(self, t)
        return ([[Invoke your gem to mark impassable terrain next to you. You immediately enter it and appear on the other side of the obstacle, up to %d grids away.
        Using this talent may disable One with Gem for 5 turns.]]):
        tformat(range)
    end
end
return _M