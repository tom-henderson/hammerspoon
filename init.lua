logger = hs.logger.new('logging','debug')

hs.loadSpoon("ReloadConfig")

hs.loadSpoon("Caffiene")
hs.loadSpoon("SizeUp")
hs.loadSpoon("WiFi")
hs.loadSpoon("ScreenSaver")


if hs.host.localizedName() == "Tom’s MacBook Air" then
    -- logger.i('Air')
else
    local MenuClock = hs.loadSpoon("MenuClock")
    MenuClock:new("🏔️", -7):start()
    MenuClock:new("🇬🇧", 0):start()
    hs.loadSpoon("LastPass")
    hs.loadSpoon("Targus")
end

hs.hotkey.bind({"shift", "cmd"}, ",", function()
    hs.application.launchOrFocus("System Preferences")
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "p", function()
    hs.application.launchOrFocus("iPhone Mirroring")
end)

-- Added to support triggering Mission Control from XBox controller, which is mapped to send ctrl+alt+Tab for L1 bumper
hs.hotkey.bind({"alt", "ctrl"}, "Tab", function()
    hs.application.launchOrFocus("Mission Control.app")
end)