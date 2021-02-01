local core = require "core"
local keymap = require "core.keymap"
local command = require "core.command"

local file = nil
local extension = nil

local function run(cmd) io.popen(("%s && cmd /k"):format(cmd)) end

local builds = {
  [".html"] = function() run(("start %s"):format(file)) end,
  [".lua"] = function() run(("lua %s"):format(file)) end,
  [".py"] = function() run(("python %s"):format(file)) end
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

