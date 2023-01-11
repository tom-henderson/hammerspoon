local obj = {}
obj.__index = obj

-- Metadata
obj.name = "Screen Saver"
obj.version = "1.0"
obj.author = "Tom Henderson <tomhenderson@mac.com>"
obj.homepage = "https://tom-henderson.github.io"
obj.license = "MIT - https://opensource.org/licenses/MIT"

-- Launch Screen Saver
hs.hotkey.bind({"ctrl", "alt"}, "Delete", function()
    hs.caffeinate.startScreensaver()
end)

hs.hotkey.bind({"ctrl", "alt"}, "ForwardDelete", function()
    hs.caffeinate.startScreensaver()
end)

return obj