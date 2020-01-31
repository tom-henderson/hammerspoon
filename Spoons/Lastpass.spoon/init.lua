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
                    -- TODO: Would be good to include the username so it's searchable
                    table.insert(obj.choices,
                        {
                            text=parts[2],
                            id=parts[1],
                            subText=parts[3]
                        }
                    )
                    obj.chooser:choices(obj.choices)
                end
            end

        end
    end
    return true
end

function obj.copy_password(item)
    if not item then return end
    print(item["text"])
    hs.task.new("/usr/local/bin/lpass", function() return true end, {"show", "--clip", "--password", item["id"]}):start()
end

function obj.reload()
    print("Reloading items")
    hs.task.new("/usr/local/bin/lpass", function()
        hs.notify.new({title="Lastpass", informativeText="Vault loaded."}):send()
    end, obj.parse_lpass, {"ls", "--color", "never", "--format", "%ai|%/as%/ag%an|%au"}):start()
end

function obj.generate_password()
    return true
end

function obj.lock()
    obj.choices = {}
    obj.chooser:choices(obj.choices)
    hs.task.new("/usr/local/bin/lpass", function() 
        hs.notify.new({title="Lastpass", informativeText="Vault locked."}):send()
    end, {"logout", "--force"}):start()
end

-- Chooser
obj.choices = {}
obj.chooser = hs.chooser.new(obj.copy_password)
obj.chooser:width(30)
obj.chooser:rows(8)
obj.chooser:searchSubText(true)

obj.chooser:showCallback(function()
    if (#obj.choices == 0) then
        obj.reload()
    end
    return obj.chooser
end)

-- Menu
obj.menu = hs.menubar.new()
obj.menu:setIcon(obj.spoonPath.."/lastpass.tiff", true) 
obj.menu:setMenu(
    {
        { title = "Quick Search", fn = obj.chooser.show },
        { title = "Generate Password", fn = obj.generate_password },
        { title = "-" },
        { title = "Refresh", fn = obj.reload },
        { title = "Lock Lastpass", fn = obj.lock },
    }
)

hs.hotkey.bind({"ctrl"}, "Space", function() obj.chooser:show() end)

return obj
