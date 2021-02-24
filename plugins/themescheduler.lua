local core = require "core"
local config = require "core.config"
local command = require "core.command"

-- add themes here (24 hour format)
local schedule = {
  ["07:00"] = "summer",
  ["20:46"] = "winter",
}

-- get theme based on time
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
  local prev = ""
  local themes = {}

  -- load themes
  for k, v in pairs(schedule) do
    themes[v] = loadfile(("%s/data/colors/%s.lua"):format(EXEDIR, v))
    if themes[v] == nil then
      core.log("Error loading \"%s/data/colors/%s.lua\"", EXEDIR, v)
    end
  end

  -- get current theme on load
  local time = os.date("*t")
  local theme = get_current_theme(("%02d:%02d"):format(time.hour, time.min))
  
  core.add_thread(function()
    while true do
      time = os.date("*t")
      theme = get_current_theme(("%02d:%02d"):format(time.hour, time.min))
      
      if prev ~= theme and themes[theme] ~= nil then
        prev = theme
        themes[theme]()
      end

      coroutine.yield(config.project_scan_rate)
    end
  end)
end

