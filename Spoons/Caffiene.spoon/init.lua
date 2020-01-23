-- Replace Caffiene
-- http://www.hammerspoon.org/docs/hs.caffeinate.html
local obj = {}
obj.__index = obj

-- Metadata
obj.name = "Caffiene"
obj.version = "1.0"
obj.author = "Tom Henderson <tomhenderson@mac.com>"
obj.homepage = "https://tom-henderson.github.io"
obj.license = "MIT - https://opensource.org/licenses/MIT"

obj.menu = hs.menubar.new()

-- Internal function used to find our location, so we know where to load files from
local function script_path()
    local str = debug.getinfo(2, "S").source:sub(2)
    return str:match("(.*/)")
end
obj.spoonPath = script_path()

function obj.setCaffeineDisplay(state)
    if state then
        obj.menu:setIcon(obj.spoonPath.."/active@2x.png", true)
    else
        obj.menu:setIcon(obj.spoonPath.."/inactive@2x.png", true)
    end
end

function obj.caffeineClicked()
    obj.setCaffeineDisplay(hs.caffeinate.toggle("displayIdle"))
end

if caffeine then
    obj.menu:setClickCallback(obj.caffeineClicked)
    obj.setCaffeineDisplay(hs.caffeinate.get("displayIdle"))
end

return obj