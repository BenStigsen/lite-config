local os = require "os"
local core = require "core"
local command = require "core.command"

local file = nil
local extension = nil

local builds = {
  [".html"] = function() os.execute(("start %s"):format(file)) end,
  [".lua"] = function() os.execute(("lua %s && cmd /k"):format(file)) end,
  [".py"] = function() os.execute(("python %s && cmd /k"):format(file)) end,
}

command.add(nil, {
  ["buildsystem:build-file"] = function()
    file = core.active_view.doc.filename
    extension = file:match("%.%w-$")

    if builds[extension] ~= nil then
      builds[extension]()
    end
  end,
})


