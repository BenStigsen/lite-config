local core = require "core"
local config = require "core.config"
local command = require "core.command"
local StatusView = require "core.statusview"

-- Pomodoro states (60 * minutes)
local states = {
  {"Work (%s)",  60 * 25},
  {"Break (%s)", 60 * 08},
  {"Work (%s)",  60 * 25},
  {"Break (%s)", 60 * 08},
  {"Work (%s)",  60 * 25},
  {"Break (%s)", 60 * 30} -- Big Break
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
  end
})

command.add(nil, {
  ["pomodoro:stop"] = function()
    state = 0
  end
})

