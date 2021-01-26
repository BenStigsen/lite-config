local core = require "core"
local command = require "core.command"

command.add(nil, {
  ["themechooser:choose-theme"] = function()
    core.command_view:enter("Set Theme To", function(text)
      local theme = text:match("^%s*(.-)%s*$")
      local file = loadfile(("%s/data/user/colors/%s.lua"):format(EXEDIR, theme))

      if file ~= nil then
        file()
        core.log("Changed theme to \"%s\"", theme)
        core.redraw = true
      else
        core.log("Error loading theme \"%s\"", theme)
      end
    end)
  end,
})

