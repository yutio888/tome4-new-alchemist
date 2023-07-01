-- ToME - Tales of Maj'Eyal
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


newChat { id = "welcome",
          text = ([[Choose which element?]]):tformat(),
          answers = {
              { _t "Fire.",
                action = function(self, player)
                    player.elemental_infusion = "fire"
                    player:updateTalentPassives(player.T_ELEMENTAL_INFUSION)
                end,
              },
              { _t "Cold.",
                action = function(self, player)
                    player.elemental_infusion = "cold"
                    player:updateTalentPassives(player.T_ELEMENTAL_INFUSION)
                end,
              },
              { _t "Acid.",
                action = function(self, player)
                    player.elemental_infusion = "acid"
                    player:updateTalentPassives(player.T_ELEMENTAL_INFUSION)
                end,
              },
              { _t "Lightning.",
                action = function(self, player)
                    player.elemental_infusion = "lightning"
                    player:updateTalentPassives(player.T_ELEMENTAL_INFUSION)
                end,
              },
              { _t "Physical.",
                action = function(self, player)
                    player.elemental_infusion = "physical"
                    player:updateTalentPassives(player.T_ELEMENTAL_INFUSION)
                end,
              },
              { _t "Light.",
                action = function(self, player)
                    player.elemental_infusion = "light"
                    player:updateTalentPassives(player.T_ELEMENTAL_INFUSION)
                end,
              },
              { _t "Darkness.",
                action = function(self, player)
                    player.elemental_infusion = "darkness"
                    player:updateTalentPassives(player.T_ELEMENTAL_INFUSION)
                end,
              },
              { _t "Arcane.",
                action = function(self, player)
                    player.elemental_infusion = "arcane"
                    player:updateTalentPassives(player.T_ELEMENTAL_INFUSION)
                end,
              },
              { _t "[Leave]" },
          },
}

return "welcome"
