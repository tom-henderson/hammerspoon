local obj = {}
obj.__index = obj

-- Metadata
obj.name = "LastPass"
obj.version = "1.0"
obj.author = "Tom Henderson <tomhenderson@mac.com>"
obj.homepage = "https://tom-henderson.github.io"
obj.license = "MIT - https://opensource.org/licenses/MIT"

-- Internal function used to find our location, so we know where to load files from
local function script_path()
    local str = debug.getinfo(2, "S").source:sub(2)
    return str:match("(.*/)")
end
obj.spoonPath = script_path()

obj.choices = {}
obj.chooser = hs.chooser.new(function(choice)
    if not choice then return end
    print(choice["text"])
    hs.task.new("/usr/local/bin/lpass", function() return true end, {"show", "--clip", "--password", choice["id"]}):start()
end)

obj.chooser:width(30)
obj.chooser:rows(8)

hs.hotkey.bind({"ctrl"}, "Space", function() obj.chooser:show() end)

function obj.parse_lpass(task, stdOut, stdErr)
    -- print("Lodader finished " .. exitCode)
    if (task == nil) then
        return true
    else
        -- Folder name/Item name blah blah [id: 12345789]
        for line in stdOut:gmatch("[^\r\n]+") do

            local parts = {}
            for item in line:gmatch("[^|]+") do
                table.insert(parts, item)
            end

            if (parts[1] and parts[2] and string.char) then
                if ((string.byte(parts[2], -1)) ~= "/" ) then
                    table.insert(obj.choices,
                        {
                            text=parts[2],
                            id=parts[1]
                        }
                    )
                    obj.chooser:choices(obj.choices)
                end
            end

        end
    end
    return true
end

function obj.load_complete(exitCode, stdOut, stdErr)
    print(exitCode)
    hs.notify.new({title="Hammerspoon", informativeText="Lastpass Loaded"}):send()
end

function obj.reload()
    print("Reloading items")
    hs.task.new("/usr/local/bin/lpass", obj.load_complete, obj.parse_lpass, {"ls", "--color", "never", "--format", "%ai|%/as%/ag%an"}):start()
end

obj.menu = hs.menubar.new()
obj.menu:setIcon(obj.spoonPath.."/lastpass.tiff", true) 
obj.menu:setMenu(
    {
        { title = "Refresh", fn = obj.reload },
    }
)

return obj