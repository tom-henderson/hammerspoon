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
obj.snapback_window_state = {}
obj.positions = {
    max = hs.layout.maximized,
    left = hs.layout.left50,
    right = hs.layout.right50,
    top = {x=0, y=0, w=1, h=0.5},
    bottom = {x=0, y=0.5, w=1, h=0.5},
    center = {x=0.25, y=0.125, w=0.5, h=0.75},
    top_left = {x=0, y=0, w=0.5, h=0.5},
    top_right = {x=0.5, y=0, w=0.5, h=0.5},
    bottom_left = {x=0, y=0.5, w=0.5, h=0.5},
    bottom_right = {x=0.5, y=0.5, w=0.5, h=0.5},
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

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "/",    obj.snapback)
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "pad/", obj.snapback)

hs.hints.style = "vimperator"
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "pad*", function() hs.hints.windowHints() end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "M",    function() obj.set_window_location(obj.positions.max) end)
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "C",    function() obj.set_window_location(obj.positions.center) end)
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "pad5", function() obj.set_window_location(obj.positions.center) end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Left", function() obj.set_window_location(obj.positions.left) end)
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "pad4", function() obj.set_window_location(obj.positions.left) end)
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Right",function() obj.set_window_location(obj.positions.right) end)
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "pad6", function() obj.set_window_location(obj.positions.right) end)
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Up",   function() obj.set_window_location(obj.positions.top) end)
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "pad8", function() obj.set_window_location(obj.positions.top) end)
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Down", function() obj.set_window_location(obj.positions.bottom) end)
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "pad2", function() obj.set_window_location(obj.positions.bottom) end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "pad7", function() obj.set_window_location(obj.positions.top_left) end)
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "pad9", function() obj.set_window_location(obj.positions.top_right) end)
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "pad1", function() obj.set_window_location(obj.positions.bottom_left) end)
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "pad3", function() obj.set_window_location(obj.positions.bottom_right) end)


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

return obj