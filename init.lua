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
    MenuClock:new('🏔️', -7):start()
    MenuClock:new('🇬🇧', 0):start()
    hs.loadSpoon("LastPass")
    hs.loadSpoon("Targus")
end

hs.hotkey.bind({"shift", "cmd"}, ",", function()
    hs.application.launchOrFocus("System Preferences")
end)
