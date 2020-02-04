# HammerSpoon LastPass Integration

## Installation

Install the LastPass CLI with `brew install lastpass-cli`

Optionally set the following environment variables (see `man lpass` for additional configuration):

* `LPASS_DISABLE_PINENTRY=1` allows HammerSpoon to detect if lastpass is logged out.
* `LPASS_AGENT_TIMEOUT=60` Set this to the number of seconds to remain logged in, or zero to stay running. (Default 60)

Log in to lastpass with `lpass login <email address>`

Copy `LastPass.spoon` to `~/.hammerspoon/Spoons`.

Add to your HammerSpoon config (`~/.hammerspoon/init.lua):

```
hs.loadSpoon("LastPass")

-- Optional configuration:
spoon.LastPass.lpass = "/usr/local/bin/lpass"
spoon.LastPass.password_length = 50
spoon.LastPass.show_notifications = true
spoon.LastPass.chooser_width = 30
spoon.LastPass.chooser_rows = 8
spoon.LastPass:bindHotkeys({
    quick_search = {{"cmd", "shift"}, "L"},
    type_clipboard = {{"cmd", "shift"}, "V"},
})
```

## Usage

Type the `quick_search` shortcut (defaults to `Cmd+Shift+L`) to bring up the chooser. Entries will be loaded automatically the first time the chooser is displayed (to refresh the list pick `Refresh` from the LastPass menu). Type to search (title and username fields are searched) and press Enter (or `Cmd-number`) to copy the password to the clipboard.

HammerSpoon calls `lpass show --clip --password [ID]` to tell LastPass CLI to copy the password directly to the clipboard, so the password is not returned to HammerSpoon.