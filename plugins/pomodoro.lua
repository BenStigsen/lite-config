-- mod-version:1 -- lite-xl 1.16
local core = require "core"
local config = require "core.config"
local command = require "core.command"
local StatusView = require "core.statusview"

-- Pomodoro states (60 * minutes)
local states = {
  {"Work (%s)",  60 * 30},
  {"Break (%s)", 60 * 05},
  {"Work (%s)",  60 * 30},
  {"Break (%s)", 60 * 05},
  {"Work (%s)",  60 * 30},
  {"Break (%s)", 60 * 15} -- Big Break
}

local state = 1

local duration = states[1][2]
local time = os.time()
local time_current = 0

local get_items = StatusView.get_items
function StatusView:get_items()
  local left, right = get_items(self)
  
  if state > 0 then
    local t = {
      self.separator,
      (states[state][1]):format(os.date('!%M:%S', time_current))
    }

    for _, item in ipairs(t) do
      table.insert(right, item)
    end
  end
  
  if state == -1 then
    table.insert(right, self.separator)
    table.insert(right, ("Paused (%s)"):format(os.date('!%M:%S', time_current)))
  end

  return left, right
end


-- Update time, duration and state
core.add_thread(function()
  while true do
    if state > 0 then
      local t = os.time()
      
      time_current = duration - (t - time)
      
      if time_current <= 0 then
        time = t
        state = (state < #states) and state + 1 or 1
        duration = states[state][2]
        time_current = duration - (t - time)
      end
    
    end
    coroutine.yield(config.project_scan_rate)
  end
end)

command.add(nil, {
  ["pomodoro:start"] = function()
    state = 1
    time = os.time()
    duration = states[1][1]
  end
})

command.add(nil, {
  ["pomodoro:stop"] = function()
    state = 0
  end
})

command.add(nil, {
  ["pomodoro:set"] = function()
    core.command_view:enter("Set Pomodoro To", function(text)   
      text = text .. "/"
      
      local times = {}
      for k in text:gmatch("(%d-)/") do
        table.insert(times, tonumber(k))
      end
      
      states = {}
      for i = 1, #times do
        if i % 2 == 0 then
          states[i] = {"Break: (%s)", 60 * times[i]}
        else
          states[i] = {"Work: (%s)", 60 * times[i]}
        end
      end
      
      time = os.time()
      duration = states[1][2]
    end, function(text)
      return {
        "Standard: 30/5/30/5/30/15",
        "Stream: 40/5/40/5/40/10",
        "Chill: 25/10/25/10/25/10"
      }
    end)
  end
})

