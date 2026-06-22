-- https://wiki.hypr.land/Configuring/Basics/Monitors/

-- -- 中间 4k 主屏幕
-- hl.monitor({
--   output = "DP-4",
--   mode = "3840x2160@160",
--   position = "2560x0",
--   scale = 1,
-- })


local main_window = "DP-2"

for i = 1, 9 do
    hl.workspace_rule({
        workspace = tostring(i),
        monitor = main_window,
        default = (i == 1),
    })
end

require("execs")
require("env")
require("general")
require("rules")
require("keybinds")
