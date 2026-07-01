local obj = {}
obj.__index = obj

-- Metadata
obj.name = "Screen Saver"
obj.version = "1.0"
obj.author = "Tom Henderson <tomhenderson@mac.com>"
obj.homepage = "https://tom-henderson.github.io"
obj.license = "MIT - https://opensource.org/licenses/MIT"

local lockOnNextScreensaver = false

-- Lock as soon as the screensaver is confirmed running, so the session is
-- locked in the background while the screensaver remains visible.
local caffeWatcher = hs.caffeinate.watcher.new(function(event)
    if event == hs.caffeinate.watcher.screensaverDidStart and lockOnNextScreensaver then
        lockOnNextScreensaver = false
        hs.caffeinate.lockScreen()
    end
end)
caffeWatcher:start()

local function launchScreenSaver()
    lockOnNextScreensaver = true
    hs.caffeinate.startScreensaver()
end

-- Launch Screen Saver
hs.hotkey.bind({"ctrl", "alt"}, "Delete", launchScreenSaver)
hs.hotkey.bind({"ctrl", "alt"}, "ForwardDelete", launchScreenSaver)

return obj