logger = hs.logger.new('logging','debug')

hs.loadSpoon("ReloadConfig")

-- hs.loadSpoon("DarkMode")
hs.loadSpoon("Caffiene")
hs.loadSpoon("SizeUp")
hs.loadSpoon("WiFi")
hs.loadSpoon("ScreenSaver")
hs.loadSpoon("LastPass")
hs.loadSpoon("HomeAssistant")
hs.loadSpoon("Targus")

hs.hotkey.bind({"shift", "cmd"}, ",", function()
    hs.application.launchOrFocus("System Preferences")
end)

