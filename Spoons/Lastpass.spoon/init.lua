local obj = {}
obj.__index = obj

-- Metadata
obj.name = "LastPass"
obj.version = "1.0"
obj.author = "Tom Henderson <tomhenderson@mac.com>"
obj.homepage = "https://tom-henderson.github.io"
obj.license = "MIT - https://opensource.org/licenses/MIT"

obj.lpass = "/usr/local/bin/lpass"
obj.password_length = 50
obj.show_notifications = true
obj.notification_duration = 3
obj.chooser_width = 30
obj.chooser_rows = 8

-- Internal function used to find our location, so we know where to load files from
local function script_path()
    local str = debug.getinfo(2, "S").source:sub(2)
    return str:match("(.*/)")
end
obj.spoonPath = script_path()

local function notify(message)
    if not obj.show_notifications then return end
    local title = "Lastpass"
    local image = hs.image.imageFromPath(obj.spoonPath.."lastpass-icon.png")
    local notification = hs.notify.new({title=title, informativeText=message, setIdImage=image}):send()
    if (obj.notification_duration > 0) then
        hs.timer.doAfter(obj.notification_duration, function ()
            notification:withdraw()
            notification = nil
        end)
    end
end

local function parse_lpass_output(task, stdOut, stdErr)
    for line in stdOut:gmatch("[^\r\n]+") do
        -- Filter out folders and entries that do not have a username
        _, _, id, title, username = line:find("(.+[^/]?)|(.+)|(.+)")

        if (title) then
            table.insert(obj.choices,
                {
                    text=title,
                    id=id,
                    subText=username
                }
            )
            obj.chooser:choices(obj.choices)
        end
    end

    if (task == nil) then
        -- FIXME: Sometimes this doesn't fire...
        notify("Vault loaded.")
    end

    return not (task == nil)
end

function obj.copy_password(item)
    if not item then return end
    hs.task.new(obj.lpass, function() return true end, {"show", "--clip", "--password", item["id"]}):start()
end

function obj.reload()
    print("Reloading items")
    obj.choices = {}
    obj.chooser:choices(obj.choices)
    -- Specify pipe delimited output here so we can parse the output.
    hs.task.new(obj.lpass, nil, parse_lpass_output, {"ls", "--color", "never", "--format", "%ai|%/as%/ag%an|%au"}):start()
end

function obj.generate_password()
    local index, pw, rnd = 0, ""
    local length = obj.password_length
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
    hs.task.new(obj.lpass, notify("Vault locked."), {"logout", "--force"}):start()
end

-- Chooser
obj.choices = {}
obj.chooser = hs.chooser.new(obj.copy_password)
obj.chooser:width(obj.chooser_width)
obj.chooser:rows(obj.chooser_rows)
obj.chooser:searchSubText(true)

obj.chooser:showCallback(function()
    if (#obj.choices == 0) then
        notify("Loading items.")
        obj.reload()
    end
    return obj.chooser
end)

-- Menu
obj.menu = hs.menubar.new()
obj.menu:setIcon(obj.spoonPath.."/lastpass-menu.png", true) 
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
