local core = require "core"
local command = require "core.command"
local common = require "core.common"

command.add(nil, {
  ["theme-chooser:choose-theme"] = function()
    core.command_view:enter("Set Theme To", function(text)
      local file = loadfile(text)

      if file ~= nil then
        file()
        core.log("Changed theme to \"%s\"", text)
        core.redraw = true
      else
        core.log("Error loading theme \"%s\"", text)
      end
    end, function(text)
      return common.path_suggest("data/colors/" .. text)
    end)
  end
})

