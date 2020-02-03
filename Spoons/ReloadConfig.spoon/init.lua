local obj = {}
obj.__index = obj

-- Metadata
obj.name = "ReloadConfig"
obj.version = "1.0"
obj.author = "Tom Henderson <tomhenderson@mac.com>"
obj.homepage = "https://tom-henderson.github.io"
obj.license = "MIT - https://opensource.org/licenses/MIT"


-- Automatically reload config on changes
local function reloadConfig(files)
    doReload = false
    for _,file in pairs(files) do
        if file:sub(-4) == ".lua" then
            doReload = true
        end
    end
    if doReload then
        hs.reload()
    end
end

local myWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()
local notification = hs.notify.new({title="Hammerspoon", informativeText="Config loaded"}):send()

hs.timer.doAfter(3, function ()
    notification:withdraw()
    notification = nil
end)

return obj