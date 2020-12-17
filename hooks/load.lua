local class = require"engine.class"
local Birther = require "engine.Birther"
local ActorTalents = require "engine.interface.ActorTalents"
local ActorTemporaryEffects = require "engine.interface.ActorTemporaryEffects"
local Entity = require "engine.Entity"

local Addon = require "mod.class.AddonAlchemist"
class:bindHook("ToME:load", Addon.hookLoad)

class:bindHook("Actor:startTalentCooldown", Addon.hookStartTalentCooldown)

class:bindHook("UISet:Minimalist:Resources", Addon.hookMinimalistResources)

class:bindHook("UISet:Classic:Resources", Addon.hookClassicResources)

class:bindHook("Entity:loadList", function(self, data)
	if data.file:find("artifact") or data.file:find("zones") then
		for _, item in ipairs(data.res) do
			_M.fetchArtifactTranslation(item)
		end
	end
end)