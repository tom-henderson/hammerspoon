local obj = {}
obj.__index = obj

-- Metadata
obj.name = "WiFi"
obj.version = "1.0"
obj.author = "Tom Henderson <tomhenderson@mac.com>"
obj.homepage = "https://tom-henderson.github.io"
obj.license = "MIT - https://opensource.org/licenses/MIT"

-- WiFi Watcher
hs.wifi.watcher.new(function ()
    local currentWifi = hs.wifi.currentNetwork()
    -- logger:i(currentWifi)
    -- short-circuit if disconnecting
    if not currentWifi then return end
  
    local note = hs.notify.new({
      title="Connected to WiFi", 
      informativeText="Now connected to " .. currentWifi,
      setIdImage=hs.image.iconForFile("/Applications/Utilities/AirPort Utility.app")
    }):send()
  
    --Dismiss notification in 3 seconds
    --Notification does not auto-withdraw if Hammerspoon is set to use "Alerts"
    --in System Preferences > Notifications
    -- hs.timer.doAfter(3, function ()
    --   note:withdraw()
    --   note = nil
    -- end)
end):start()

return obj