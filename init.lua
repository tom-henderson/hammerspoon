logger = hs.logger.new('logging','debug')

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
    hs.caffeinate.startScreensaver()
end)

hs.hotkey.bind({"ctrl", "alt"}, "ForwardDelete", function()
    hs.caffeinate.startScreensaver()
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
    bottom = {x=0, y=0.5, w=1, h=0.5},
    center = {x=0.25, y=0.125, w=0.5, h=0.75}
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

-- Center
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "C", function()
  sizeup.set_window_location(sizeup.positions.center)
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
hs.hotkey.bind({"cmd", "ctrl"}, "Right", function()
    local win = hs.window.focusedWindow()
    win:moveOneScreenEast(false, true, sizeup.animationDuration)
end)

-- Previous Screen
hs.hotkey.bind({"cmd", "ctrl"}, "Left", function()
    local win = hs.window.focusedWindow()
    win:moveOneScreenWest(false, true, sizeup.animationDuration)
end)

-- -- All to Next Screen
-- hs.hotkey.bind({"alt", "ctrl", "shift", "cmd"}, "Right", function()
--     local win = hs.window.focusedWindow()
--     local otherWins = win:otherWindowsSameScreen()
--     for w in otherWins do
--         w:moveOneScreenEast(false, true, sizeup.animationDuration)
--     end
--     win:moveOneScreenEast(false, true, sizeup.animationDuration)
-- end)

-- -- All to Previous Screen
-- hs.hotkey.bind({"alt", "ctrl", "shift", "cmd"}, "Left", function()
--     local win = hs.window.focusedWindow()
--     local otherWins = win:otherWindowsSameScreen()
--     for w in otherWins do
--         w:moveOneScreenWest(false, true, sizeup.animationDuration)
--     end
--     win:moveOneScreenWest(false, true, sizeup.animationDuration)
-- end)

-- Snap Back
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "/", function()
  sizeup.snapback()
end)

-- Replace Caffiene
-- http://www.hammerspoon.org/docs/hs.caffeinate.html
local caffeine = {}
caffeine.menu = hs.menubar.new()

function caffeine.setCaffeineDisplay(state)
    if state then
        caffeine.menu:setIcon("~/.hammerspoon/images/active@2x.png", true)
    else
        caffeine.menu:setIcon("~/.hammerspoon/images/inactive@2x.png", true)
    end
end

function caffeine.caffeineClicked()
    caffeine.setCaffeineDisplay(hs.caffeinate.toggle("displayIdle"))
end

if caffeine then
    caffeine.menu:setClickCallback(caffeine.caffeineClicked)
    caffeine.setCaffeineDisplay(hs.caffeinate.get("displayIdle"))
end

-- local pushpay_status = {}
-- pushpay_status.menu = hs.menubar.new()

-- function pushpay_status.menuClicked()
--     hs.http.asyncGet('https://api.pushpay.com/v1/healthcheck', nil, function()
--         body_json = hs.json.decode(body)
--         hs.notify.new({title=body, informativeText=body}):send()
--     end)
-- end

-- if pushpay_status then
--     pushpay_status.menu:setClickCallback(pushpay_status.menuClicked)
--     pushpay_status.menu:setIcon("~/.hammerspoon/images/pushpay_logo.png", false)
--     pushpay_status.menu:setMenu( {
--        { title = "CheckgatewayMinionConnectivity" },
--        { title = "FastbillBackgroundPaymentsEnabled" },
--        { title = "MinionPing" },
--        { title = "NeverbeastPing" },
--        { title = "ScheduledPaymentsEngineEnabled" },
--        { title = "SmtpMinionConnectivity" },
--        { title = "SpreedlyConnectivity" },
--    })
-- end

-- Type Clipboard Contents
hs.hotkey.bind({"alt", "ctrl"}, "V", function()
    local text = hs.pasteboard.readString()
    hs.eventtap.keyStrokes(text)
end)

-- WiFi Watcher
hs.wifi.watcher.new(function ()
    local currentWifi = wifi.currentNetwork()
    -- short-circuit if disconnecting
    if not currentWifi then return end
  
    local note = hs.notify.new({
      title="Connected to WiFi", 
      informativeText="Now connected to " .. currentWifi
    }):send()
  
    --Dismiss notification in 3 seconds
    --Notification does not auto-withdraw if Hammerspoon is set to use "Alerts"
    --in System Preferences > Notifications
    -- hs.timer.doAfter(3, function ()
    --   note:withdraw()
    --   note = nil
    -- end)
end):start()

-- mouse events
local clicker = {}
clicker.events = {
    hs.eventtap.event.types.middleMouseDown,
    hs.eventtap.event.types.middleMouseUp
}
clicker.tap = hs.eventtap.new(clicker.events, function(event)

    button = event:getProperty(hs.eventtap.event.properties.mouseEventButtonNumber)

    if (event:getType() == hs.eventtap.event.types.middleMouseDown) then
        action = "down"
    else
        action = "up"
    end

    current_app = hs.application.frontmostApplication()
    google_chrome = hs.application.find("Google Chrome")

    if (button == 2) then
        -- logger:i("Middle button", action)
    end

    if (current_app == google_chrome) then
        if (button == 3) then
            -- logger:i("Back button", action)
            if (action == "up") then
                hs.eventtap.keyStroke({"cmd"}, "[")
            end
        end

        if (button == 4) then
            -- logger:i("Forward button", action)
            if (action == "up") then
                hs.eventtap.keyStroke({"cmd"}, "]")
            end
        end
    end
end):start()

hs.hotkey.bind({"alt", "ctrl"}, "Tab", function()
    -- logger:i("thumb button pressed")
    hs.application.launchOrFocus("Mission Control.app")
end)
