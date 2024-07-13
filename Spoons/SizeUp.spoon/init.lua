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
    center_full_height = {x=0.25, y=0, w=0.5, h=1},
    center_full_width = {x=0, y=0.25, w=1, h=0.5},
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
hs.hints.fontSize = 16
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "return", function() hs.hints.windowHints() end)
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "pad*", function() hs.hints.windowHints() end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "M",    function() obj.set_window_location(obj.positions.max) end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "I",    function() obj.set_window_location(obj.positions.center_full_height) end)
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "-",    function() obj.set_window_location(obj.positions.center_full_width) end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Up",   function() obj.set_window_location(obj.positions.top) end)
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Down", function() obj.set_window_location(obj.positions.bottom) end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "pad1", function() obj.set_window_location(obj.positions.bottom_left) end)
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "pad2", function() obj.set_window_location(obj.positions.bottom) end)
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "pad3", function() obj.set_window_location(obj.positions.bottom_right) end)
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "pad4", function() obj.set_window_location(obj.positions.left) end)
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "pad5", function() obj.set_window_location(obj.positions.center) end)
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "pad6", function() obj.set_window_location(obj.positions.right) end)
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "pad7", function() obj.set_window_location(obj.positions.top_left) end)
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "pad8", function() obj.set_window_location(obj.positions.top) end)
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "pad9", function() obj.set_window_location(obj.positions.top_right) end)


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

-- TODO: When we enter a modal, all other modals should be exited
function position_hotkey(mods, key, positions, timeout)
    local this = {}
    this._timeout = timeout or 3
    this._counter = 1
    this._timer = nil
    this.modal =  hs.hotkey.modal.new(mods, key)
    hs.window.filter.default:subscribe(hs.window.filter.windowFocused, function() this.modal:exit() end)

    function this.move_window(positions)
        local win =  hs.window.focusedWindow()
        win:moveToUnit(positions[this._counter], obj.animationDuration)
        this._counter = this._counter + 1
        if this._counter > #positions then
            this._counter = 1
        end
    end

    this.modal:bind(mods, key, function()
        this._timer:setDelay(this._timeout)
        this.move_window(positions)
    end)

    function this.modal:entered()
        local win =  hs.window.focusedWindow()
        if not obj.snapback_window_state[win:id()] then
            obj.snapback_window_state[win:id()] = win:frame()
        end
        this._timer = hs.timer.delayed.new(this._timeout, function() this.modal:exit() end):start()
        this.move_window(positions)
    end

    function this.modal:exited()
        this._counter = 1
    end

    return this
end

function obj.center_position(w, h)
    return {x=(0.5 - w/2), y=(0.5 - h/2), w=w, h=h}
end

obj.center = position_hotkey({"cmd", "alt", "ctrl"}, "C", {
    obj.center_position(0.5, 0.75),
    obj.center_position(0.6, 0.85),
    obj.center_position(0.7, 0.95),
    obj.center_position(0.8, 0.95),
})
obj.left = position_hotkey({"cmd", "alt", "ctrl"}, "Left", {
    hs.layout.left50,
    hs.layout.left30,
    hs.layout.left25,
    hs.layout.left70,
})
obj.right = position_hotkey({"cmd", "alt", "ctrl"}, "Right", {
    hs.layout.right50,
    hs.layout.right30,
    hs.layout.right25,
    hs.layout.right70,
})

return obj
