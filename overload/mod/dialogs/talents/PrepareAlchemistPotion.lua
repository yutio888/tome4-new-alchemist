-- TE4 - T-Engine 4
-- Copyright (C) 2009 - 2019 Nicolas Casalini
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.
--
-- Nicolas Casalini "DarkGod"
-- darkgod@te4.org

require "engine.class"
local Dialog = require "engine.ui.Dialog"
local ListColumns = require "engine.ui.ListColumns"
local Textzone = require "engine.ui.Textzone"
local TextzoneList = require "engine.ui.TextzoneList"
local Separator = require "engine.ui.Separator"

local Talents = require "engine.interface.ActorTalents"

--- Show Inventory
-- @classmod engine.dialogs.ShowInventory
module(..., package.seeall, class.inherit(Dialog))

function _M:init(actor)
    self.actor = actor
    Dialog.init(self, _t "Managed readied tools", math.max(800, game.w * 0.6), math.max(600, game.h * 0.4))

    self.c_tools = ListColumns.new { width = math.floor(self.iw / 2 - 10), height = (self.font_h + 6) * 5, scrollbar = true, columns = {
        { name = _t "", width = { 26, "fixed" }, display_prop = "char", sort = "id" },
        { name = _t "", width = { 24, "fixed" }, display_prop = "object", sort = "sortname", direct_draw = function(item, x, y)
            item.object:toScreen(nil, x + 4, y, 16, 16)
        end },
        { name = _t "Readied tools", width = 100, display_prop = "name", sort = "sortname" },
    }, list = {}, fct = function(item)
        self:unreadyItem(item)
    end, select = function(item, sel)
        self:select(item)
    end }

    self.c_list = ListColumns.new { width = math.floor(self.iw / 2 - 10), height = self.ih - 10, sortable = true, scrollbar = true, columns = {
        { name = _t "", width = { 26, "fixed" }, display_prop = "char", sort = "id" },
        { name = _t "", width = { 24, "fixed" }, display_prop = "object", sort = "sortname", direct_draw = function(item, x, y)
            item.object:toScreen(nil, x + 4, y, 16, 16)
        end },
        { name = _t "Inventory", width = 100, display_prop = "name", sort = "sortname" },
    }, list = {}, fct = function(item)
        self:readyItem(item)
    end, select = function(item, sel)
        self:select(item)
    end }

    self.c_desc = TextzoneList.new { width = math.floor(self.iw / 2 - 10), height = self.ih - self.c_tools.h, no_color_bleed = true }

    local hsep = Separator.new { dir = "vertical", size = self.iw / 2 - 10 }

    self:generateList()

    self:loadUI {
        { left = 0, top = 0, ui = self.c_list },
        { right = 0, top = 0, ui = self.c_tools },
        { right = 0, top = self.c_tools, ui = hsep },
        { right = 0, top = hsep, ui = self.c_desc },
        { hcenter = 0, top = 5, ui = Separator.new { dir = "horizontal", size = self.ih - 10 } },
    }
    self:setFocus(self.c_list)
    self:setupUI()

    self.key:addCommands {
        __TEXTINPUT = function(c)
            if self.list and self.list.chars[c] then
                self:readyItem(self.list[self.list.chars[c]])
            end
        end,
    }
    self.key:addBinds {
        EXIT = function()
            game:unregisterDialog(self)
        end,
    }
end

function _M:on_register()
    game:onTickEnd(function()
        self.key:unicodeInput(true)
    end)
end

function _M:select(item)
    if item then
        local talent = self.actor:getTalentFromId(item.tid)
        local desc = talent and talent.info and talent.info(self.actor, talent) or "No desc"
        self.c_desc:switchItem(item, desc or "No desc")
    end
end

function _M:unreadyItem(item)
    if item and item.tid and item.name then
        self.actor:unprepareAlchemyPotion(item.tid)
    end
    self:generateList()
    self:select(self.c_list.list[self.c_list.sel])
    self:select(self.c_tools.list[self.c_tools.sel])
    self.actor:talentDialogReturn(true)
end

function _M:readyItem(item)
    if item and item.tid and item.name then
        self.actor:prepareAlchemyPotion(item.tid)
    end
    self:generateList()
    self:select(self.c_list.list[self.c_list.sel])
    self:select(self.c_tools.list[self.c_tools.sel])
    self.actor:talentDialogReturn(true)
end

function _M:generateList()
    -- Makes up the list
    local list = {}
    list.chars = {}
    local i = 1
    for t, item in ipairs(Talents.alchemy_potion_tids or {}) do
        local talent = self.actor:getTalentFromId(item)
        if talent and talent.allowUse and talent.allowUse(self.actor, talent) then
            local char = self:makeKeyChar(i)

            list[#list + 1] = { id = i, char = char, name = talent.name, sortname = talent.name, object = talent.display_entity,
                                tid = item }
            list.chars[char] = #list
            i = i + 1
        end
    end
    self.list = list
    self.c_list:setList(list)

    -- Makes up the list
    local list = {}
    list.chars = {}
    local i = 1
    for item, info in pairs(self.actor.alchemy_potions or {}) do
        if info.max or 0 >= 1 then
            local nb = info.max
            local talent = self.actor:getTalentFromId(item)
            if talent and talent.allowUse and talent.allowUse(self.actor, talent) then
                while nb > 0 do
                    local char = self:makeKeyChar(i)

                    list[#list + 1] = { id = i, char = char, name = talent.name, sortname = talent.name, object = talent.display_entity,
                                        tid = item }
                    list.chars[char] = #list
                    i = i + 1
                    nb = nb - 1
                end
            end
        end
    end
    self.list = list
    self.c_tools:setList(list)
end