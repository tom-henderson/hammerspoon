local obj = {}
obj.__index = obj

-- Metadata
obj.name = "Home Assistant"
obj.version = "1.0"
obj.author = "Tom Henderson <tomhenderson@mac.com>"
obj.homepage = "https://tom-henderson.github.io"
obj.license = "MIT - https://opensource.org/licenses/MIT"

obj.window = hs.webview.new({x=100, y=100, w=400, h=800})
obj.window:url("https://home.thx.nz")
obj.window:allowTextEntry(true)

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

    obj.window:frame({x=x, y=30, w=400, h=800})

    if obj.window:isVisible() then
        obj.window:hide()
    else
        obj.window:show()
            :windowCallback(function(action, webview, hasFocus)
                if action == "focusChange" and not hasFocus then
                    obj.window:hide()
                end
            end)
            :bringToFront(true)
    end
end)

return obj