-- Automatically reload config on changes
function reloadConfig(files)
    doReload = false
    for _,file in pairs(files) do
        if file:sub(-4) == ".lua" then
            doReload = true
        end
    end
    if doReload then
        hs.reload()
    end
end
local myWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()
hs.notify.new({title="Hammerspoon", informativeText="Config loaded"}):send()

-- Launch Screen Saver
hs.hotkey.bind({"ctrl", "alt"}, "Delete", function()
  hs.application.launchOrFocus("/System/Library/Frameworks/ScreenSaver.framework/Versions/A/Resources/ScreenSaverEngine.app")
end)

hs.hotkey.bind({"ctrl", "alt"}, "ForwardDelete", function()
  hs.application.launchOrFocus("/System/Library/Frameworks/ScreenSaver.framework/Versions/A/Resources/ScreenSaverEngine.app")
end)

hs.hotkey.bind({"shift", "cmd"}, ",", function()
    hs.application.launchOrFocus("System Preferences")
end)

-- Replace SizeUp
local sizeup = {}
sizeup.animationDuration = 0.0
sizeup.snapback_window_state = { }
sizeup.positions = {
    max = hs.layout.maximized,
    left = hs.layout.left50,
    right = hs.layout.right50,
    top = {x=0, y=0, w=1, h=0.5},
    bottom = {x=0, y=0.5, w=1, h=0.5}
}

function sizeup.set_window_location(position)
    local win =  hs.window.focusedWindow()
    local previous_state = sizeup.snapback_window_state[win:id()]

    if not previous_state then
        sizeup.snapback_window_state[win:id()] = win:frame()
    end

    return win:moveToUnit(position, sizeup.animationDuration)
end

function sizeup.snapback()
    local win = hs.window.focusedWindow()
    local previous_state = sizeup.snapback_window_state[win:id()]
    if previous_state then
        win:setFrame(previous_state, sizeup.animationDuration)
    end
    sizeup.snapback_window_state[win:id()] = nil
end

-- Maximize
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "M", function()
  sizeup.set_window_location(sizeup.positions.max)
end)

-- Left Half
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Left", function()
  sizeup.set_window_location(sizeup.positions.left)
end)

-- Right Half
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Right", function()
  sizeup.set_window_location(sizeup.positions.right)
end)

-- Top Half
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Up", function()
  sizeup.set_window_location(sizeup.positions.top)
end)

-- Bottom Half
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Down", function()
  sizeup.set_window_location(sizeup.positions.bottom)
end)

-- Next Screen
hs.hotkey.bind({"alt", "ctrl"}, "Right", function()
    local win = hs.window.focusedWindow()
    local nextScreen = win:screen():next()
    win:moveToScreen(nextScreen)
end)

-- Previous Screen
hs.hotkey.bind({"alt", "ctrl"}, "Left", function()
    local win = hs.window.focusedWindow()
    local nextScreen = win:screen():previous()
    win:moveToScreen(nextScreen)
end)

-- Snap Back
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "/", function()
  sizeup.snapback()
end)

-- Replace Caffiene
-- http://www.hammerspoon.org/docs/hs.caffeinate.html
-- local caffeine = hs.menubar.new()
-- function setCaffeineDisplay(state)
--     if state then
--         caffeine:setIcon("~/.hammerspoon/images/active.png", false)
--     else
--         caffeine:setIcon("~/.hammerspoon/images/inactive.png", false)
--     end
-- end

-- function caffeineClicked()
--     setCaffeineDisplay(hs.caffeinate.toggle("displayIdle"))
-- end

-- if caffeine then
--     caffeine:setClickCallback(caffeineClicked)
--     setCaffeineDisplay(hs.caffeinate.get("displayIdle"))
-- end
