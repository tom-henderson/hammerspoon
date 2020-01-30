local obj = {}
obj.__index = obj

-- Metadata
obj.name = "LastPass"
obj.version = "1.0"
obj.author = "Tom Henderson <tomhenderson@mac.com>"
obj.homepage = "https://tom-henderson.github.io"
obj.license = "MIT - https://opensource.org/licenses/MIT"

obj.choices = {}
obj.chooser = hs.chooser.new(function(choice)
    if not choice then return end
    print(choice["text"])
    hs.task.new("/usr/local/bin/lpass", function() return true end, {"show", "--clip", "--password", choice["id"]}):start()
end)

obj.chooser:width(30)
obj.chooser:rows(5)

hs.hotkey.bind({"ctrl"}, "Space", function() obj.chooser:show() end)

function obj.parse_lpass(task, stdOut, stdErr)
    print("Got some items")
    if (task == nil) then
        print("All items loaded")
    else
        -- Folder name/Item name blah blah [id: 12345789]
        for line in stdOut:gmatch("[^\r\n]+") do
            local t = line:match("(.*)%[")
            local i = line:match("%[id: (.*)%]$")
            if (t and i) then
                table.insert(obj.choices,
                    {
                        text=t,
                        id=i
                    }
                )
                obj.chooser:choices(obj.choices)
            end
        end
    end
    return true
end

obj.loader = hs.task.new("/usr/local/bin/lpass", nil, obj.parse_lpass, {"ls", "--color", "never"}):start()

return obj