# lite-config
This repository contains plugins and other stuff (if added) that matches my config for the 
**[lite-xl](https://github.com/franko/lite-xl)** text editor.

---

**Increase scrollbar size:**
- core/view.lua **L67**
  - from `return x >= sx - sw * 3 and x < sx + sw and y >= sy and y < sy + sh`
  - to `return x >= sx - sw * 0.2 and x < sx + sw and y >= sy and y < sy + sh`
- core/style.lua **L6**
  - from `style.scrollbar_size = common.round(2 * SCALE)`
  - to `style.scrollbar_size = common.round(15 * SCALE)`
  
---

These are my own plugins:

Plugin | Description
-------|-----------------------------------------
[`themescheduler`](plugins/themescheduler.lua?raw=1) | Schedules themes to
certain times (save your eyes)
[`themechooser`](plugins/themechooser.lua?raw=1) | An easy way to change or preview themes on the go
[`pomodoro`](plugins/pomodoro.lua?raw=1) | Simple Pomodoro timer

---

These are the plugins I've customized:

Plugin | Description
-------|-----------------------------------------
[`scale`](plugins/scale.lua?raw=1) | Provides support for dynamically adjusting the scale of the code

