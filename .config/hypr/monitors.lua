-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- List current monitors and supported resolutions with: hyprctl monitors all

local omarchy_gdk_scale = 1
local omarchy_monitor_scale = 1

hl.env("GDK_SCALE", tostring(omarchy_gdk_scale))
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = omarchy_monitor_scale })

hl.monitor({
  output = "desc:Samsung Electric Company Odyssey G5 HNMY400400",
  mode = "2560x1440@179.95",
  position = "0x0",
  scale = 1,
  sdr_min_luminance = 0.2,
  sdr_max_luminance = 80,
})

hl.monitor({
  output = "desc:Samsung Electric Company S24C300 0x30333138",
  mode = "1920x1080@60.00",
  position = "-1920x93",
  scale = 1,
  sdr_min_luminance = 0.2,
  sdr_max_luminance = 80,
})

