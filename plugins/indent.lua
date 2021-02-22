local core = require "core"
local config = require "core.config"
local command = require "core.command"
local Doc = require "core.doc"

-- Disable "detect indent" plugin if exists
config.detectindent = false

command.add(nil, {
  ["indent:set-indentation-level"] = function()
    core.command_view:enter("Indent Size", function(text)
      config.indent_size = tonumber(text)

      core.log("Set indentation level to %s", text)
    end)
  end
})

command.add(nil, {
  ["indent:set-indentation-type"] = function()
    core.command_view:enter("Indent Type", function(text)
      if text == "space" then
        config.tab_type = "soft"
      else
        config.tab_type = "hard"
      end

      core.log("Set indentation type to %s", config.tab_type)
    end, function(text)
      return {"space", "tab"}
    end)
  end
})

