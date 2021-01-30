local os = require "os"
local core = require "core"
local keymap = require "core.keymap"
local command = require "core.command"

local file = nil
local extension = nil

local builds = {
  [".html"] = function() os.execute(("start %s"):format(file)) end,
  [".lua"] = function() os.execute(("lua %s && cmd /k"):format(file)) end,
  [".py"] = function() os.execute(("python %s && cmd /k"):format(file)) end,
}

local function build()
  file = core.active_view.doc.filename
  extension = file:match("%..-$")

  if builds[extension] ~= nil then
    core.log("Building %s", file)
    builds[extension]()
  end
end

command.add(nil, {
  ["buildsystem:build-file"] = function() build() end,
})

keymap.add {["ctrl+b"] = "buildsystem:build-file"}

