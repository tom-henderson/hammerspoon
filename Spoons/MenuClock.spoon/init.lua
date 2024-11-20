local obj = {}
obj.__index = obj

-- Metadata
obj.name = "MenuClock"
obj.version = "1.0"
obj.author = "Tom Henderson <tomhenderson@mac.com>"
obj.homepage = "https://tom-henderson.github.io"
obj.license = "MIT - https://opensource.org/licenses/MIT"


function obj:new(identifier, utc_offset)
    local instance = setmetatable({}, self)
    instance.identifier = identifier
    instance.utc_offset = utc_offset
    instance.time_format = "%I:%M %p"
    instance.date_format = "%A %d %B"
    instance.menu_item = hs.menubar.new()

    function instance:time_with_utc_offset(hours)
        return os.date("!" .. self.time_format, os.time() + hours * 3600)
    end

    function instance:date_with_utc_offset(hours)
        return os.date("!" .. self.date_format, os.time() + hours * 3600)
    end

    function instance:update_menu_title()
        local time = self:time_with_utc_offset(self.utc_offset)
        self.menu_item:setTitle(self.identifier .. ' ' .. time)
        self.menu_item:setMenu(
            {
                { title = self:date_with_utc_offset(self.utc_offset) },
                { title = "Update Now", fn = self.start_clock },
            }
        )
    end

    function instance:start_clock()
        local function update_menu_title() 
            self:update_menu_title() -- Update immediately
        end
        update_menu_title()
        local now = os.time()
        local nextMinute = now + 60 - os.date("*t", now).sec
        hs.timer.doAt(os.date("%H:%M", nextMinute), function()
            update_menu_title()
            self.clock_timer = hs.timer.doEvery(60, update_menu_title)
        end)
    end

    function instance:start()
        local function click_callback() 
            self:start_clock()
        end
        self:start_clock() -- Start the clock immediately
        return self
    end

    return instance
end

return obj