-- Extra autostart processes.
-- o.launch_on_start("my-service")

-- omarchy-launch-webapp already wraps itself in uwsm-app, so don't use launch_on_start.
o.exec_on_start(o.launch_webapp("https://discord.com/channels/@me"))
