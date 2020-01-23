-- Dark Mode
local obj = {}
obj.__index = obj

-- Metadata
obj.name = "Dark Mode"
obj.version = "1.0"
obj.author = "Tom Henderson <tomhenderson@mac.com>"
obj.homepage = "https://tom-henderson.github.io"
obj.license = "MIT - https://opensource.org/licenses/MIT"

obj.menu = hs.menubar.new()

-- Internal function used to find our location, so we know where to load files from
local function script_path()
    local str = debug.getinfo(2, "S").source:sub(2)
    return str:match("(.*/)")
end
obj.spoonPath = script_path()

function obj.set(state)
  hs.preferencesDarkMode(state)
  hs.console.darkMode(state)
  hs.console.consoleCommandColor{ white = (state and 1) or 0}
  hs.osascript.javascript(
    string.format(
      "Application('System Events').appearancePreferences.darkMode.set(%s)",
      state
    )
  )
  darkmode.updateTitle()
end

function obj.isOn()
  local _, darkModeState = hs.osascript.javascript(
    'Application("System Events").appearancePreferences.darkMode()'
  )
  return darkModeState
end

function obj.updateTitle()
    obj.menu:setIcon(obj.spoonPath.."/dark_mode@2x.png", true)
    if obj.isOn() then
        -- obj.menu:setTitle("☀︎")
        obj.menu:setTooltip("Dark mode is active.")
    else
        -- obj.menu:setTitle("☽")
        obj.menu:setTooltip("Dark mode is not active.")
    end
end

function obj.on()
  obj.set(true)
end

function obj.off()
  obj.set(false)
end

function obj.toggle()
  obj.set(not obj.isOn())
end

obj.updateTitle()
obj.menu:setClickCallback(obj.toggle)

return obj