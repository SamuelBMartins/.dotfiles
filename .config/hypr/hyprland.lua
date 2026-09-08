-- Learn how to configure Hyprland: https://wiki.hypr.land/Configuring/Start/

-- Omarchy's bootstrap keeps path setup out of this user config.
dofile((os.getenv("OMARCHY_PATH") or "/usr/share/omarchy") .. "/default/hypr/bootstrap.lua")

-- Disable all Omarchy default bindings. Add your own in hypr/bindings.lua.
-- omarchy_default_bindings = false
--
-- Or disable only bindings for Omarchy's preinstalled apps/web apps while
-- keeping core window-manager bindings:
-- omarchy_preinstalled_bindings = false

-- Load Omarchy defaults.
require("default.hypr.omarchy")

-- Put your personal overrides in these files. They're loaded after Omarchy's
-- defaults so package updates can improve the defaults without rewriting your
-- ~/.config/hypr files.
require("hypr.monitors")
require("hypr.input")
require("hypr.bindings")
require("hypr.looknfeel")
require("hypr.autostart")

-- Toggle config flags dynamically.
require("default.hypr.toggles")

-- Add any other personal Hyprland configuration below.
-- o.window("qemu", { workspace = "5" })

-- Make Omarchy's standard floating windows larger than the packaged 875x600 default.
o.window({ tag = "floating-window" }, { size = { 1100, 750 } })

-- Spotify always floats at 75% of the screen, centered.
o.window(
  { class = "^org\\.quickshell$", title = "^Omarchy Spotify$" },
  { float = true, size = { "monitor_w * 0.75", "monitor_h * 0.75" }, center = true }
)

-- Keep browser windows whose titles include "- YouTube" fully opaque.
o.window({ title = "^(.*- YouTube.*)$" }, { opacity = "1 override" })

-- Keep browser windows whose titles include "- Twitch" fully opaque.
o.window({ title = "^(.*- Twitch.*)$" }, { opacity = "1 override" })

-- Keep Kick.com windows in Brave Origin fully opaque.
o.window({ title = "^.*Kick - Brave Origin$" }, { opacity = "1 override" })

-- Controller input does not always reset the compositor idle timer. Keep the
-- session awake while a Steam/Proton game window has focus.
o.window({ class = "^steam_app_.*$" }, { idle_inhibit = "focus" })

-- Added by hyprmoncfg: its generated monitor rules load last, so nothing before this can override the applied layout.
do local path = os.getenv("HOME") .. "/.config/hypr/hyprmoncfg-monitors.lua"; local file = io.open(path, "r"); if file then file:close(); dofile(path) end end
