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

local function notify(message)
    local title = "Lastpass"
    local image = hs.image.imageFromPath(obj.spoonPath.."lastpass.png")
    hs.notify.new({title=title, informativeText=message, setIdImage=image}):send()
end

function obj.parse_lpass(task, stdOut, stdErr)
    for line in stdOut:gmatch("[^\r\n]+") do
        local parts = {}

        for item in line:gmatch("[^|]+") do
            table.insert(parts, item)
        end

        if (parts[1] and parts[2]) then
            if (string.char(string.byte(parts[2], -1)) ~= "/" ) then
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

    if (task == nil) then
        notify("Vault loaded.")
    end

    return not (task == nil)
end

function obj.copy_password(item)
    if not item then return end
    -- print("Fetching password for "..item["text"])
    hs.task.new("/usr/local/bin/lpass", function() return true end, {"show", "--clip", "--password", item["id"]}):start()
end

function obj.reload()
    print("Reloading items")
    obj.choices = {}
    obj.chooser:choices(obj.choices)
    -- Specify pipe delimited output here so we can parse the output.
    hs.task.new("/usr/local/bin/lpass", nil, obj.parse_lpass, {"ls", "--color", "never", "--format", "%ai|%/as%/ag%an|%au"}):start()
end

function obj.generate_password()
    local index, pw, rnd = 0, ""
    local length = 50
    local chars = {
        "ABCDEFGHIJKLMNOPQRSTUVWXYZ",
        "abcdefghijklmnopqrstuvwxyz",
        "0123456789",
        "!\"#$%&'()*+,-./:;<=>?@[]^_{|}~"
    }
    repeat
        index = index + 1
        rnd = math.random(chars[index]:len())
        if math.random(2) == 1 then
            pw = pw .. chars[index]:sub(rnd, rnd)
        else
            pw = chars[index]:sub(rnd, rnd) .. pw
        end
        index = index % #chars
    until pw:len() >= length
    hs.pasteboard.setContents(pw)
    notify("New password copied to clipboard.")
end

function obj.lock()
    obj.choices = {}
    obj.chooser:choices(obj.choices)
    hs.task.new("/usr/local/bin/lpass", notify("Vault locked."), {"logout", "--force"}):start()
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
        { title = "Quick Search", fn = function(mods, item) obj.chooser:show() end },
        { title = "Generate Password", fn = obj.generate_password },
        { title = "-" },
        { title = "Refresh", fn = obj.reload },
        { title = "Lock Lastpass", fn = obj.lock },
    }
)

hs.hotkey.bind({"ctrl"}, "Space", function() obj.chooser:show() end)

return obj
