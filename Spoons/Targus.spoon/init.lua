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

    print("[" .. fn.vendorID .. "] " .. fn.vendorName .. " [" .. fn.productID .. "] " .. fn.productName .. " was " .. fn.eventType)
  
    -- Targus Dock:
    -- product Id: 0x6004
    -- vendor ID: 0x17e9 = 6121 decimal
    if (fn.vendorID == 6121 and fn.productID == 6004) then

      local note = hs.notify.new({
        title="USB Event", 
        informativeText=fn.vendorName .. fn.productName .. " was " .. fn.eventType
      }):send()

      if (fn.eventType == "added") then
        hs.application.open("DisplayLink Manager")
      else
        hs.application.get("DisplayLinkUserAgent"):kill()
      end

    end
  
end):start()

return obj
