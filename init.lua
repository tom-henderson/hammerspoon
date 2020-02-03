logger = hs.logger.new('logging','debug')

hs.loadSpoon("ReloadConfig")

hs.loadSpoon("DarkMode")
hs.loadSpoon("Caffiene")
hs.loadSpoon("SizeUp")
hs.loadSpoon("WiFi")
hs.loadSpoon("ScreenSaver")
hs.loadSpoon("ColourPicker")
hs.loadSpoon("LastPass")

-- spoon.SizeUp:bindHotkeys({
--     max={{"cmd", "alt", "ctrl"}, "M"},
--     left={{"cmd", "alt", "ctrl"}, "Left"},
--     right={{"cmd", "alt", "ctrl"}, "Right"},
--     top={{"cmd", "alt", "ctrl"}, "Up"},
--     bottom={{"cmd", "alt", "ctrl"}, "Down"},
--     center={{"cmd", "alt", "ctrl"}, "C"},
--     snapback={{"cmd", "alt", "ctrl"}, "/"},
-- })
