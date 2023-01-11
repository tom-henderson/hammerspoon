logger = hs.logger.new('logging','debug')

hs.loadSpoon("ReloadConfig")

hs.loadSpoon("DarkMode")
hs.loadSpoon("Caffiene")
hs.loadSpoon("SizeUp")
hs.loadSpoon("WiFi")
hs.loadSpoon("ScreenSaver")
-- hs.loadSpoon("ColourPicker")
hs.loadSpoon("LastPass")

hs.hotkey.bind({"shift", "cmd"}, ",", function()
    hs.application.launchOrFocus("System Preferences")
end)

hs.hotkey.bind({"ctrl", "alt"}, "c", function()
    hs.dialog.color.show()
end)

-- menu = hs.menubar.new()
-- function updateMenuTitle(code, body, headers)
--     json_response = hs.json.decode(body)
--     temperature = json_response["data"]["result"][1]["value"][2]
--     menu:setTitle(tostring(temperature).."℃")
-- end

-- function getTemperature()
--     hs.http.doAsyncRequest('http://10.0.0.5:9090/api/v1/query?query='..query, 'GET', nil, nil, updateMenuTitle)
-- end

-- query = hs.http.encodeForQuery('temperature{room="office"}')
-- getTemperature()
-- menu:setClickCallback(getTemperature)
