local obj = {}
obj.__index = obj

-- Metadata
obj.name = "Home Assistant"
obj.version = "1.0"
obj.author = "Tom Henderson <tomhenderson@mac.com>"
obj.homepage = "https://tom-henderson.github.io"
obj.license = "MIT - https://opensource.org/licenses/MIT"

obj.window = hs.webview.new({x=1810, y=30, w=400, h=800})
obj.window:url("https://home.thx.nz")
obj.window:allowTextEntry(true)
-- obj.window:windowCallback(function(closing, message)
--     print(message)
--     print(obj.window:isVisible())
--     if message == "focusChange" and not obj.window:isVisible() then
--         return
--     else
--         obj.window:hide()
--     end
-- end)

-- Internal function used to find our location, so we know where to load files from
local function script_path()
    local str = debug.getinfo(2, "S").source:sub(2)
    return str:match("(.*/)")
end
obj.spoonPath = script_path()

obj.menu = hs.menubar.new()
-- obj.menu:setTitle("Home") 
obj.menu:setIcon(obj.spoonPath.."/house.png", true)

obj.menu:setClickCallback(function()
    local menuframe = obj.menu:frame()
    local windowframe = obj.window:frame()

    local x = menuframe.x - (windowframe.w / 2) + (menuframe.w / 2)
    local y = windowframe.y
    local w = windowframe.w
    local h = windowframe.h

    obj.window:frame({x=x, y=y, w=w, h=h})

    if obj.window:isVisible() then
        obj.window:hide()
    else
        obj.window:show()
        obj.window:bringToFront(true)
    end
end)

return obj