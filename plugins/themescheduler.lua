local core = require "core"
local config = require "core.config"
local command = require "core.command"

-- add themes here (24 hour format)
local schedule = {
  ["07:00"] = "summer",
  ["20:00"] = "winter",
}

-- get theme on load
local function get_current_theme(target)
  local min = "00:00"
  local max = "23:59"

  for k, v in pairs(schedule) do
    if k == target then 
      return v 
    end
    
    if k < target and k > min then 
      min = k 
    end
    
    if k > target and k < max then 
      max = k
    end
  end
  
  -- return current theme
  if target > max then
    return schedule[max]
  else
    return schedule[min]
  end
end

-- scheduler
if next(schedule) ~= nil then
  local themes = {}

  -- load themes
  for k, v in pairs(schedule) do
    themes[v] = loadfile(("%s/data/colors/%s.lua"):format(EXEDIR, v))
    if themes[v] == nil then
      core.log("Error loading \"%s/data/colors/%s.lua\"", EXEDIR, v)
    end
  end
  
  -- apply theme on load
  local time = os.date("*t")
  local theme = get_current_theme(("%02d:%02d"):format(time.hour, time.min))
  
  themes[theme]()
  
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
          core.log("NEW THEME")
          theme = schedule[str]

          if themes[theme] ~= nil then
            themes[theme]()

            core.log("Changed theme \"colors.%s\"", theme)
            core.redraw = true
          end
        end
      end

      coroutine.yield(config.project_scan_rate)
    end
  end)
end

