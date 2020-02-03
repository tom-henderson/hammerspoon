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

-- Type Clipboard Contents
hs.hotkey.bind({"alt", "ctrl"}, "V", function()
    local text = hs.pasteboard.readString()
    hs.eventtap.keyStrokes(text)
end)


-- mouse events
-- local clicker = {}
-- clicker.events = {
--     hs.eventtap.event.types.middleMouseDown,
--     hs.eventtap.event.types.middleMouseUp
-- }
-- clicker.tap = hs.eventtap.new(clicker.events, function(event)

--     button = event:getProperty(hs.eventtap.event.properties.mouseEventButtonNumber)

--     -- logger:i("Button", button, action)

--     if (event:getType() == hs.eventtap.event.types.middleMouseDown) then
--         action = "down"
--     else
--         action = "up"
--     end

--     current_app = hs.application.frontmostApplication()
--     google_chrome = hs.application.find("Google Chrome")

--     if (button == 2) then
--         -- logger:i("Middle button", action)
--     end

--     if (current_app == google_chrome) then
--         if (button == 3) then
--             -- logger:i("Back button", action)
--             if (action == "up") then
--                 hs.eventtap.keyStroke({"cmd"}, "[")
--             end
--         end

--         if (button == 4) then
--             -- logger:i("Forward button", action)
--             if (action == "up") then
--                 hs.eventtap.keyStroke({"cmd"}, "]")
--             end
--         end
--     end
-- end):start()

-- hs.hotkey.bind({"alt", "ctrl"}, "Tab", function()
--     hs.application.launchOrFocus("Mission Control.app")
-- end)

