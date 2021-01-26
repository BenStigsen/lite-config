local core = require "core"
local config = require "core.config"
local command = require "core.command"

local schedule = {
  ["07:00"] = "summer",
  ["20:00"] = "fall",
}

if next(schedule) ~= nil then
  local themes = {}

  -- load themes
  for k, v in pairs(schedule) do
    themes[v] = loadfile(("%s/data/user/colors/%s.lua"):format(EXEDIR, v))
    if themes[v] == nil then
      core.log("Error loading \"%s/data/user/colors/%s.lua\"", EXEDIR, v)
    end
  end

  core.add_thread(function()
    local changed = {hour = nil, min = nil}
    local theme = nil

    while true do
      local time = os.date("*t")

      if time.hour ~= changed.hour or time.min ~= changed.min then
        changed.hour = time.hour
        changed.min = time.min

        local str = ("%02d:%02d"):format(time.hour, time.min)

        if schedule[str] ~= nil and schedule[str] ~= theme then
          theme = schedule[str]

          if themes[theme] ~= nil then
            themes[theme]()

            core.log("Changed theme \"user.colors.%s\"", theme)
            core.redraw = true
          end
        end
      end

      coroutine.yield(config.project_scan_rate)
    end
  end)
end

