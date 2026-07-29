hl.on("hyprland.start", function()
	-- restart xdg-desktop-portal-hyprland
	hl.exec_cmd("systemctl --user restart xdg-desktop-portal-hyprland.service")

	-- checkupdates
	-- hl.exec_cmd("~/.config/scripts/checkupdates.sh")

	-- wallpaper, Bar
	-- hl.exec_cmd("~/.config/hypr/scripts/background-video.sh")
	hl.exec_cmd("hyprpaper")
	hl.exec_cmd("waybar")

	-- Input method
	hl.exec_cmd("fcitx5 --replace -d")

	-- Clipboard (use clipvault)
	hl.exec_cmd("wl-paste --watch clipvault store")

	-- Clipboard (use clipcatd)
	-- hl.exec_cmd("clipcatd")

	-- Bluetooth, network management, caffeine indicator
	-- hl.exec_cmd("blueman-tray")
	hl.exec_cmd("blueman-applet")
	hl.exec_cmd("nm-applet")
	hl.exec_cmd("caffeine-indicator")

	-- swaync notification center
	hl.exec_cmd("swaync")

	-- udiskie Automounter for removable media
	hl.exec_cmd("udiskie")

	-- flameshot screen shotter
	hl.exec_cmd("flameshot")

	-- deskflow share keyboard and mouse
	hl.exec_cmd("deskflow")

	-- syncthing between local network devices
	hl.exec_cmd("syncthing")

	-- hl.exec_cmd("browserpass")
end)
