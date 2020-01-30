-- Replace SizeUp
local obj = {}
obj.__index = obj

-- Metadata
obj.name = "SizeUp"
obj.version = "1.0"
obj.author = "Tom Henderson <tomhenderson@mac.com>"
obj.homepage = "https://tom-henderson.github.io"
obj.license = "MIT - https://opensource.org/licenses/MIT"

obj.animationDuration = 0.1
obj.snapback_window_state = { }
obj.positions = {
    max = hs.layout.maximized,
    left = hs.layout.left50,
    right = hs.layout.right50,
    top = {x=0, y=0, w=1, h=0.5},
    bottom = {x=0, y=0.5, w=1, h=0.5},
    center = {x=0.25, y=0.125, w=0.5, h=0.75}
}

function obj.set_window_location(position)
    local win =  hs.window.focusedWindow()
    local previous_state = obj.snapback_window_state[win:id()]

    if not previous_state then
        obj.snapback_window_state[win:id()] = win:frame()
    end

    return win:moveToUnit(position, obj.animationDuration)
end

function obj.snapback()
    local win = hs.window.focusedWindow()
    local previous_state = obj.snapback_window_state[win:id()]
    if previous_state then
        win:setFrame(previous_state, obj.animationDuration)
    end
    obj.snapback_window_state[win:id()] = nil
end

-- Maximize
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "M", function()
  obj.set_window_location(obj.positions.max)
end)

-- Center
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "C", function()
  obj.set_window_location(obj.positions.center)
end)

-- Left Half
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Left", function()
  obj.set_window_location(obj.positions.left)
end)

-- Right Half
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Right", function()
  obj.set_window_location(obj.positions.right)
end)

-- Top Half
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Up", function()
  obj.set_window_location(obj.positions.top)
end)

-- Bottom Half
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Down", function()
  obj.set_window_location(obj.positions.bottom)
end)

-- Next Screen
hs.hotkey.bind({"cmd", "ctrl"}, "Right", function()
    local win = hs.window.focusedWindow()
    win:moveOneScreenEast(false, true, obj.animationDuration)
end)

-- Previous Screen
hs.hotkey.bind({"cmd", "ctrl"}, "Left", function()
    local win = hs.window.focusedWindow()
    win:moveOneScreenWest(false, true, obj.animationDuration)
end)

-- All to Next Screen
hs.hotkey.bind({"alt", "ctrl", "shift", "cmd"}, "Right", function()
    local win = hs.window.focusedWindow()
    local otherWins = win:otherWindowsSameScreen()

    for i, w in ipairs(otherWins) do
        w:moveOneScreenEast(false, true, obj.animationDuration)
    end

    win:moveOneScreenEast(false, true, obj.animationDuration)
end)

-- All to Previous Screen
hs.hotkey.bind({"alt", "ctrl", "shift", "cmd"}, "Left", function()
    local win = hs.window.focusedWindow()
    local otherWins = win:otherWindowsSameScreen()

    for i, w in ipairs(otherWins) do
        w:moveOneScreenWest(false, true, obj.animationDuration)
    end

    win:moveOneScreenWest(false, true, obj.animationDuration)
end)

-- Snap Back
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "/", function()
  obj.snapback()
end)

-- function obj:bindHotkeys(mapping)
--   local def = {
--     max = obj.set_window_location(obj.positions.max),
--     left = obj.set_window_location(obj.positions.left),
--     right = obj.set_window_location(obj.positions.right),
--     top = obj.set_window_location(obj.positions.top),
--     bottom = obj.set_window_location(obj.positions.bottom),
--     center = obj.set_window_location(obj.positions.center),
--     snapback = obj.snapback(),
--   }
--   hs.spoons.bindHotkeysToSpec(def, mapping)
-- end

return obj