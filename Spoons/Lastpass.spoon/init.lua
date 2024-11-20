local obj = {}
obj.__index = obj

-- Metadata
obj.name = "LastPass"
obj.version = "1.0"
obj.author = "Tom Henderson <tomhenderson@mac.com>"
obj.homepage = "https://tom-henderson.github.io"
obj.license = "MIT - https://opensource.org/licenses/MIT"

obj.lpass = "/opt/homebrew/bin/lpass"
obj.password_length = 50
obj.show_notifications = true
obj.chooser_width = 30
obj.chooser_rows = 8

-- Internal function used to find our location, so we know where to load files from
local function script_path()
    local str = debug.getinfo(2, "S").source:sub(2)
    return str:match("(.*/)")
end
obj.spoonPath = script_path()

local function lastpass_is_installed()
    return (hs.fs.attributes(obj.lpass, "mode") ~= nil)
end

local function notify(message)
    if not obj.show_notifications then return end
    local title = "Lastpass"
    local image = hs.image.imageFromPath(obj.spoonPath.."lastpass-icon.png")
    local notification = hs.notify.new({title=title, informativeText=message, contentImage=image}):send()
end

if (not lastpass_is_installed()) then
    notify("LastPass not found. Is it installed?")
    return obj 
end

local function parse_lpass_output(task, stdOut, stdErr)
    if (stdErr:find("Perhaps you need to login")) then
        notify("Failed to load vault. Are you logged in?")
        obj.chooser:placeholderText('LastPass Locked')
        return false
    end

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

    obj.chooser:placeholderText('Search LastPass...')
    return not (task == nil)
end

function obj.copy_password(item)
    if not item then return end
    hs.task.new(obj.lpass, function(exitCode, stdOut, stdErr)
        if (stdErr:find("Perhaps you need to login")) then
            notify("Failed to copy password. Are you logged in?")
        end
    end, {"show", "--clip", "--password", item.id}):start():waitUntilExit() -- blocking!
    notify("Password copied")
end

function obj.reload()
    notify("Loading items.")
    obj.chooser:placeholderText('Loading Items')
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
    obj.chooser:placeholderText('LastPass Locked')
    hs.task.new(obj.lpass, notify("Vault locked."), {"logout", "--force"}):start()
end

obj.choices = {}
obj.chooser = hs.chooser.new(obj.copy_password)
obj.chooser:width(obj.chooser_width)
obj.chooser:rows(obj.chooser_rows)
obj.chooser:searchSubText(true)

obj.chooser:showCallback(function()
    if (#obj.choices == 0) then
        obj.reload()
    end
    return obj.chooser
end)

obj.menu = hs.menubar.new()
obj.menu:setIcon(obj.spoonPath.."/lastpass-menu.png", true) 
obj.menu:setMenu(
    {
        { title = "Quick Search", fn = function(mods, item) obj.chooser:show() end },
        { title = "Generate Password", fn = obj.generate_password },
        { title = "-" },
        { title = "Refresh", fn = obj.reload },
        { title = "Lock LastPass", fn = obj.lock },
    }
)

function obj:bindHotkeys(mapping)
  local def = {
    quick_search = function() obj.chooser:show() end,
    type_clipboard = function() hs.eventtap.keyStrokes(hs.pasteboard.readString()) end,
  }
  hs.spoons.bindHotkeysToSpec(def, mapping)
  return self
end

-- Set default hotkeys
obj:bindHotkeys({
    quick_search = {{"cmd", "ctrl"}, "L"},
    type_clipboard = {{"cmd", "ctrl"}, "V"},
})

return obj
