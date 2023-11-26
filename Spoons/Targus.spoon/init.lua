local obj = {}
obj.__index = obj

-- Metadata
obj.name = "Targus"
obj.version = "1.0"
obj.author = "Tom Henderson <tomhenderson@mac.com>"
obj.homepage = "https://tom-henderson.github.io"
obj.license = "MIT - https://opensource.org/licenses/MIT"

-- USB Watcher
hs.usb.watcher.new(function (fn)

    -- print("[" .. fn.vendorID .. "] " .. fn.vendorName .. " [" .. fn.productID .. "] " .. fn.productName .. " was " .. fn.eventType)
  
    -- Targus Dock:
    if (fn.vendorName == "DisplayLink" and fn.productName == "Targus USB3 DV4K DOCK w PD60W") then

      local note = hs.notify.new({
        title="USB Event", 
        informativeText=fn.vendorName .. fn.productName .. " was " .. fn.eventType,
        setIdImage=hs.image.iconForFile("/Applications/DisplayLink Manager.app")
      }):send()

      if (fn.eventType == "added") then
        hs.application.open("DisplayLink Manager")
      else
        app = hs.application.get("DisplayLinkUserAgent")
        if app then
          app:kill()
        end
      end

    end
  
end):start()

return obj
