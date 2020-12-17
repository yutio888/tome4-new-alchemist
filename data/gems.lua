artifact_gems = {}

artifact_gems["/data/general/objects/boss-artifacts-maj-eyal.lua"] = {
    ["Petrified Wood"] = {
        alchemist_power = 65,
        alchemist_bomb = {
            splash = { type = "FIREBURN", dam = 24, desc = ("Deals %d%% extra fireburn damage"):tformat(24)
            }
        }
    },
    ["Crystal Focus"] = {
        alchemist_power = 35,
        alchemist_bomb = {
            power = 15
        }
    },
    ["Crystal Heart"] = {
        alchemist_power = 70,
        alchemist_bomb = {
            power = 20
        }
    },
}

artifact_gems["/data/general/objects/brotherhood-artifacts.lua"] = {
    ["Lifebinding Emerald"] = {
        alchemist_power = 65,
        alchemist_bomb = {
            splash = {
                desc = ("Heals %d"):tformat(200)
            },
            special_area = function(self)
                self:heal(200)
            end
        }
    }
}

artifact_gems["/data/general/objects/world-artifacts-far-east.lua"] = {
    ["Goedalath Rock"] = {
alchemist_power = 70,
alchemist_bomb = {
            splash = {
                type = "SHADOWFLAME",
                dam = 50,
                desc = ("Deals %d%% extra shadow flame damage and stuns for 3 turns"):tformat(55)
            },
            special = function(self, gem, target, dam)
                if target:canBe("stun") then
                    target:setEffect(target.EFF_STUNNED, 3, {})
                end
            end
        }
    }
}

artifact_gems["/data/general/objects/world-artifacts-maj-eyal.lua"] = {
    ["Telos's Staff Crystal"] = {
        alchemist_power = 70,
        alchemist_bomb = {
            splash = { type = "LITE", dam = 100, desc = _t "Lights terrain (power 100)" }
        }
    }
}

artifact_gems["/data/general/objects/world-artifacts.lua"] = {
    ["Windborne Azurite"] = {
        alchemist_power = 65,
        alchemist_bomb = {
            splash = { desc = _t "Gain one free move in 2 turns (stacks for 3 times)" }, special_area = function(self, gem, grids)
                self:setEffect(self.EFF_DIAMOND_SPEED, 2, { stack = 1 })
            end
        }
    },
    ["Burning Star"] = {
        alchemist_power = 50,
        alchemist_bomb = {
            splash = { type = "LITE", dam = 100, desc = _t "Lights terrain (power 100)" }
        }
    },
    ["Prothotipe's Prismatic Eye"] = {
        alchemist_power = 35,
        alchemist_bomb = {
            power = 15,
        }
    },
}

artifact_gems["/data/zones/briagh-lair/objects.lua"] = {
    ["Resonating Diamond"] = {
        alchemist_power = 70,
        alchemist_bomb = {
            power = 20,
        }
    },
}

artifact_gems["/data/zones/golem-gravetard/objects.lua"] = {
    ["Atamathon's Ruby Eye"] = {
        alchemist_power = 70,
        alchemist_bomb = {
            splash = { type = "FIRE", dam = 50, desc = ("Deals %d%% extra fire damage"):tformat(50) }
        }
    },
}

artifact_gems["/data/zones/reknor/objects.lua"] = {
    ["Resonating Diamond"] = {
        alchemist_power = 70,
        alchemist_bomb = {
            power = 20,
        }
    },
}

artifact_gems["/data/zones/sandworm-lair/objects.lua"] = {
    ["Atamathon's Lost Ruby Eye"] = {
        alchemist_power = 70,
        alchemist_bomb = {
            splash = { type = "FIREBURN", dam = 30, desc = ("Deals %d%% extra fireburn damage"):tformat(30) }
        }
    },
}


artifact_gems["/data/zones/tannen-tower/objects.lua"] = {
    ["Resonating Diamond"] = {
        alchemist_power = 70,
        alchemist_bomb = {
            power = 20,
        }
    },
}

artifact_gems["/data-orcs/general/objects/boss-artifacts.lua"] = {
    ["Ureslak's Focus"] = {
        alchemist_power = 70,
        alchemist_bomb = {
            splash = { type = "DARKNESS", dam = 20, desc = ("Deals %d%% extra darkness damage and stuns for 3 turns"):tformat(20) },
            special = function(self, gem, target, dam)
                if target:canBe("stun") then
                    target:setEffect(target.EFF_STUNNED, 3, { })
                end
            end
        }
    },
}

artifact_gems["/data-cults/general/objects/world-artifacts.lua"] = {
    ["Glowing Core"] = {
        alchemist_power = 65,
        alchemist_bomb = {
            splash = { type = "LIGHT", dam = 30, desc = ("Deals %d%% extra light damage and blinds for 3 turns"):tformat(30) },
            special = function(self, gem, target, dam)
                if target:canBe("blind") then
                    target:setEffect(target.EFF_BLINDED, 3, { })
                end
            end
        }
    },
}