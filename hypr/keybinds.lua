local mainMod = "ALT" -- primary modifier
local sub1Mod = "SUPER" -- secondary modifier
local sub2Mod = "CTRL" -- tertiary modifier

local menu = "rofi -show combi -combi-modes window,drun,run,filebrowser -modes combi"
local terminal = "kitty"
local browser = "firefox"
local filemanager = "thunar" -- dolphin, thunar

local function chord(mod, key)
	return mod .. " + " .. key
end

local function bind_mods(mods, key, dsp, opts)
	for _, mod in ipairs(mods) do
		hl.bind(chord(mod, key), dsp, opts)
	end
end

--- Focus an existing window by class (case-insensitive match), or launch command.
--- `match_class` is compared case-insensitively to client class;
--- `focus_class` is the Hyprland class selector used when focusing.
local function focus_or_raise(match_class, focus_class, command)
	local needle = string.lower(match_class)
	return function()
		for _, w in ipairs(hl.get_windows()) do
			if string.lower(w.class) == needle then
				hl.dispatch(hl.dsp.focus({ window = "class:" .. focus_class }))
				return
			end
		end
		hl.exec_cmd(command)
	end
end

-- Quit hyprland
hl.bind(
	chord(sub1Mod, "CTRL + Q"),
	hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'")
)

-- Application launchers
hl.bind(chord(mainMod, "SPACE"), hl.dsp.exec_cmd(menu))
hl.bind(chord(mainMod, "CTRL + E"), focus_or_raise("emacs", "[Ee]macs", "emacs"))
hl.bind(
	chord(mainMod, "CTRL + S"),
	focus_or_raise("org.localsend.localsend_app", "org.localsend.localsend_app", "localsend")
)
hl.bind(chord(mainMod, "CTRL + I"), focus_or_raise("emacs", "[Ee]macs", "igcemacs"))
hl.bind(chord(mainMod, "CTRL + K"), focus_or_raise(terminal, terminal, terminal))
hl.bind(chord(mainMod, "CTRL + T"), hl.dsp.exec_cmd(terminal))
hl.bind(chord(mainMod, "CTRL + F"), focus_or_raise(browser, browser, browser))
hl.bind(chord(mainMod, "CTRL + N"), focus_or_raise(filemanager, "[Tt]hunar", filemanager))
hl.bind(chord(mainMod, "SHIFT + T"), hl.dsp.exec_cmd(terminal .. " btop"))

-- Window management
hl.bind(chord(mainMod, "CTRL + C"), hl.dsp.window.close())
hl.bind(chord(sub1Mod, "S"), hl.dsp.window.float({ action = "toggle" }))
bind_mods({ sub2Mod, mainMod }, "SHIFT + F", hl.dsp.window.fullscreen())

-- Screenshot
hl.bind(chord(mainMod, "SHIFT + S"), hl.dsp.exec_cmd("hyprshot -m region --clipboard-only"))
hl.bind(chord(mainMod, "SHIFT + W"), hl.dsp.exec_cmd("hyprshot -m window"))
hl.bind(chord(mainMod, "CTRL + A"), hl.dsp.exec_cmd("flameshot gui"))

-- Clipboard (yay -S clipvault)
hl.bind(
	chord(mainMod, "V"),
	hl.dsp.exec_cmd("clipvault list | rofi -dmenu -display-columns 2 | clipvault get | wl-copy")
)

-- yay -S clipcat
-- hl.bind(chord(mainMod, "V"), hl.dsp.exec_cmd("clipcat-menu insert"))

-- Cycle workspaces / last window
hl.bind(chord(mainMod, "GRAVE"), hl.dsp.focus({ workspace = "e+1" }))
hl.bind(chord(mainMod, "TAB"), function()
	if #hl.get_workspaces() >= 3 then
		hl.dispatch(hl.dsp.focus({ last = true }))
	else
		hl.dispatch(hl.dsp.focus({ workspace = "e+1" }))
	end
end)

-- Cycle through windows in the current workspace
bind_mods({ mainMod, sub1Mod }, "J", hl.dsp.window.cycle_next())
hl.bind(chord(mainMod, "K"), hl.dsp.window.cycle_next({ next = false }))

-- Switch workspaces with mainMod + [0-9]
-- Move active window: SHIFT for 1-8, CTRL for 9-0
for i = 1, 10 do
	local key = i % 10 -- 10 maps to key 0
	hl.bind(chord(mainMod, key), hl.dsp.focus({ workspace = i }))

	local move_mod = i <= 8 and "SHIFT" or "CTRL"
	hl.bind(chord(mainMod, move_mod .. " + " .. key), hl.dsp.window.move({ workspace = i }))
end

-- Scroll / arrow through existing workspaces
hl.bind(chord(mainMod, "mouse_down"), hl.dsp.focus({ workspace = "e+1" }))
hl.bind(chord(mainMod, "mouse_up"), hl.dsp.focus({ workspace = "e-1" }))
hl.bind(chord(sub1Mod, "RIGHT"), hl.dsp.focus({ workspace = "e+1" }))
hl.bind(chord(sub1Mod, "LEFT"), hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with sub1Mod + LMB/RMB and dragging
hl.bind(chord(sub1Mod, "mouse:272"), hl.dsp.window.drag(), { mouse = true })
hl.bind(chord(sub1Mod, "mouse:273"), hl.dsp.window.resize(), { mouse = true })

-- swapwithmaster for master layout
bind_mods({ mainMod, sub1Mod }, "M", hl.dsp.layout("swapwithmaster master ignoremaster"))

-- Resize submap
bind_mods({ mainMod, sub2Mod }, "SHIFT + R", hl.dsp.submap("resize"))

hl.define_submap("resize", function()
	local deltas = {
		h = { -10, 0 },
		j = { 0, 10 },
		k = { 0, -10 },
		l = { 10, 0 },
	}
	for key, d in pairs(deltas) do
		hl.bind(key, hl.dsp.window.resize({ x = d[1], y = d[2], relative = true }), { repeating = true })
	end
	hl.bind("escape", hl.dsp.submap("reset"))
end)

-- Debug: dump client list
hl.bind(chord(mainMod, "CTRL + D"), hl.dsp.exec_cmd("hyprctl clients > " .. os.getenv("HOME") .. "/test/test.txt"))
