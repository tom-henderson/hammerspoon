local obj = {}
obj.__index = obj

-- Metadata
obj.name = "Colour Picker"
obj.version = "1.0"
obj.author = "Tom Henderson <tomhenderson@mac.com>"
obj.homepage = "https://tom-henderson.github.io"
obj.license = "MIT - https://opensource.org/licenses/MIT"

hs.hotkey.bind({"ctrl", "alt"}, "c", function()
    hs.osascript.applescript("choose color")
end)

return obj