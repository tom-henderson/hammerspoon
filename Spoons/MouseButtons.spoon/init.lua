local obj = {}
obj.__index = obj

-- Metadata
obj.name = "Mouse Buttons"
obj.version = "1.0"
obj.author = "Tom Henderson <tomhenderson@mac.com>"
obj.homepage = "https://tom-henderson.github.io"
obj.license = "MIT - https://opensource.org/licenses/MIT"


obj.events = {
    hs.eventtap.event.types.middleMouseDown,
    hs.eventtap.event.types.middleMouseUp
}

obj.tap = hs.eventtap.new(obj.events, function(event)

    button = event:getProperty(hs.eventtap.event.properties.mouseEventButtonNumber)

    -- logger:i("Button", button, action)

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

-- Logitec MX Master II
hs.hotkey.bind({"alt", "ctrl"}, "Tab", function()
    hs.application.launchOrFocus("Mission Control.app")
end)

return obj