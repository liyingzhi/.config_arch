-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

-- Example window rules that are useful

local suppressMaximizeRule = hl.window_rule({
    -- Ignore maximize requests from all apps. You'll probably like this.
    name  = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize",
})
-- suppressMaximizeRule:set_enabled(false)

hl.window_rule({
    -- Fix some dragging issues with XWayland
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})

-- Smart gaps / no gaps when only
hl.workspace_rule({ workspace = "w[tv1]s[false]", gaps_out = 0, gaps_in = 0 })
hl.workspace_rule({ workspace = "f[1]s[false]", gaps_out = 0, gaps_in = 0 })
hl.window_rule({ match = { float = false, workspace = "w[tv1]s[false]" }, border_size = 0 })
hl.window_rule({ match = { float = false, workspace = "w[tv1]s[false]" }, rounding = 0 })
hl.window_rule({ match = { float = false, workspace = "f[1]s[false]" }, border_size = 0 })
hl.window_rule({ match = { float = false, workspace = "f[1]s[false]" }, rounding = 0 })

-- Any floating window show at workspace's center
hl.window_rule({
    name  = "floating-windows",
    match = {float = true},
    center =true,
    size   = "(monitor_w*0.5) (monitor_h*0.6)",
})

-- Layer rules also return a handle.
-- local overlayLayerRule = hl.layer_rule({
--     name  = "no-anim-overlay",
--     match = { namespace = "^my-overlay$" },
--     no_anim = true,
-- })
-- overlayLayerRule:set_enabled(false)

-- Hyprland-run windowrule
hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },

    move  = "20 monitor_h-120",
    float = true,
})

-- Emacs: workspace 1, fullscreen
hl.window_rule({
    name  = "emacs",
    match = { title = ".*Emacs.*" },

    workspace  = "1",
    focus_on_activate = true,
    fullscreen = true,
})

-- Firefox: workspace 4
hl.window_rule({
    name  = "firefox",
    match = { class = "firefox" },

    focus_on_activate = true,
    workspace = "4",
})

-- Zotero: workspace 5
hl.window_rule({
    name  = "Zotero",
    match = { title = ".*Zotero.*" },

    focus_on_activate = true,
    workspace = "5",
})

-- deskflow: workspace 6
hl.window_rule({
    name  = "deskflow",
    match = { title = ".*Deskflow.*" },

    workspace = "6",
})

-- LocalSend: workspace 7
hl.window_rule({
    name  = "localsend",
    match = { title = "LocalSend" },

    focus_on_activate = true,
    workspace = "7",
})

-- Discord: workspace 8
hl.window_rule({
    name  = "discord",
    match = { title = ".*Discord" },

    focus_on_activate = true,
    workspace = "8",
})

-- QQ: workspace 8
hl.window_rule({
    name  = "qq",
    match = { title = ".*QQ.*" },

    focus_on_activate = true,
    workspace = "8",
})

-- Wechat: workspace 8
hl.window_rule({
    name  = "wechat",
    match = { title = ".*Weixin.*" },

    focus_on_activate = true,
    workspace = "8",
})

-- AudioRelay: workspace 9
hl.window_rule({
    name  = "audiorelay",
    match = { title = "AudioRelay" },

    focus_on_activate = true,
    workspace = "9",
})

-- Volume Control: float, center, 50% size
hl.window_rule({
    name  = "volume-control",
    match = { title = ".*Volume Control.*" },

    float  = true,
    center = true,
    size   = "(monitor_w*0.5) (monitor_h*0.5)",
})

-- flameshot
hl.window_rule({
    match       = { class = "flameshot" },
    no_anim     = true,
    pin         = true,
    float       = true,
    decorate    = false,
    no_blur     = true,
    no_shadow   = true,
})
hl.window_rule({
    match   = { class = "flameshot", title = "flameshot" },
    move    = { 0, 0 },
})
hl.window_rule({
    match = { class = "flameshot", title = "flameshot-pin" },
    move  = { "cursor_x-(window_w*0.5)", "cursor_y-(window_h*0.5)" },
})
