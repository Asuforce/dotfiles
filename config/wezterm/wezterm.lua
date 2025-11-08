-- WezTerm configuration file

local wezterm = require('wezterm')
local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- ========================================
-- Appearance settings
-- ========================================

-- Window transparency settings
config.window_background_opacity = 0.75

-- macOS blur effect
config.macos_window_background_blur = 0

-- Fullscreen settings (does not create a separate desktop)
config.native_macos_fullscreen_mode = false

-- Color scheme
config.color_scheme = 'OneDark (gogh)'

-- Font settings
config.font = wezterm.font_with_fallback({
  'HackGen35 Console',
  'HackGen35',
  'Monaco',
  'Menlo',
})
config.font_size = 14.0
config.use_ime = true

-- Font rendering settings (display text sharply)
config.freetype_load_target = 'Normal'
config.front_end = 'WebGpu'

-- Optimize font shaping with harfbuzz features
config.harfbuzz_features = { 'kern', 'liga' }

-- Window settings
config.window_decorations = 'RESIZE'
config.window_padding = {
  left = 5,
  right = 5,
  top = 5,
  bottom = 5,
}

-- Display tab bar at the top
config.tab_bar_at_bottom = false
config.use_fancy_tab_bar = false  -- Simple tab bar
config.show_tabs_in_tab_bar = true  -- Show tabs
config.hide_tab_bar_if_only_one_tab = false  -- Show bar even with one tab
config.tab_max_width = 32  -- Maximum tab width
config.show_new_tab_button_in_tab_bar = false  -- Hide the "+" button

-- Tab bar color settings
config.colors = {
  tab_bar = {
    background = '#1a1b26',  -- Tab bar background color
    active_tab = {
      bg_color = '#7aa2f7',  -- Active tab background color
      fg_color = '#1a1b26',  -- Active tab foreground color
      intensity = 'Bold',
    },
    inactive_tab = {
      bg_color = '#292e42',  -- Inactive tab background color
      fg_color = '#565f89',  -- Inactive tab foreground color
    },
    inactive_tab_hover = {
      bg_color = '#3b4261',  -- Hover background color
      fg_color = '#c0caf5',  -- Hover foreground color
    },
  },
}

-- ========================================
-- Key bindings settings
-- ========================================

-- Leader key: Ctrl+g
config.leader = { key = 'g', mods = 'CTRL', timeout_milliseconds = 1000 }

config.keys = {
  -- Leader + r: Reload configuration
  {
    key = 'r',
    mods = 'LEADER',
    action = wezterm.action.ReloadConfiguration,
  },

  -- Pane splitting
  {
    key = '5',
    mods = 'LEADER',
    action = wezterm.action.SplitHorizontal({ domain = 'CurrentPaneDomain' }),
  },
  {
    key = "'",
    mods = 'LEADER',
    action = wezterm.action.SplitVertical({ domain = 'CurrentPaneDomain' }),
  },

  -- Pane navigation (Vim-style: h,j,k,l)
  {
    key = 'h',
    mods = 'LEADER',
    action = wezterm.action.ActivatePaneDirection('Left'),
  },
  {
    key = 'j',
    mods = 'LEADER',
    action = wezterm.action.ActivatePaneDirection('Down'),
  },
  {
    key = 'k',
    mods = 'LEADER',
    action = wezterm.action.ActivatePaneDirection('Up'),
  },
  {
    key = 'l',
    mods = 'LEADER',
    action = wezterm.action.ActivatePaneDirection('Right'),
  },

  -- Pane resize (Ctrl+h,j,k,l)
  {
    key = 'h',
    mods = 'LEADER|CTRL',
    action = wezterm.action.AdjustPaneSize({ 'Left', 5 }),
  },
  {
    key = 'j',
    mods = 'LEADER|CTRL',
    action = wezterm.action.AdjustPaneSize({ 'Down', 5 }),
  },
  {
    key = 'k',
    mods = 'LEADER|CTRL',
    action = wezterm.action.AdjustPaneSize({ 'Up', 5 }),
  },
  {
    key = 'l',
    mods = 'LEADER|CTRL',
    action = wezterm.action.AdjustPaneSize({ 'Right', 5 }),
  },

  -- Window (tab) navigation (Option+Left/Right)
  {
    key = 'LeftArrow',
    mods = 'OPT',
    action = wezterm.action.ActivateTabRelative(-1),
  },
  {
    key = 'RightArrow',
    mods = 'OPT',
    action = wezterm.action.ActivateTabRelative(1),
  },

  -- Create new window (tab) (Option+Enter)
  {
    key = 'Enter',
    mods = 'OPT',
    action = wezterm.action.SpawnTab('CurrentPaneDomain'),
  },

  -- Close pane (x)
  {
    key = 'x',
    mods = 'LEADER',
    action = wezterm.action.CloseCurrentPane({ confirm = true }),
  },

  -- Close window (tab) (X)
  {
    key = 'X',
    mods = 'LEADER|SHIFT',
    action = wezterm.action.CloseCurrentTab({ confirm = true }),
  },

  -- Toggle pane zoom (tmux zoom feature)
  {
    key = 'z',
    mods = 'LEADER',
    action = wezterm.action.TogglePaneZoomState,
  },

  -- Copy mode (Leader+v)
  {
    key = 'v',
    mods = 'LEADER',
    action = wezterm.action.ActivateCopyMode,
  },

  -- Toggle fullscreen (Ctrl+g → f)
  {
    key = 'f',
    mods = 'LEADER',
    action = wezterm.action.ToggleFullScreen,
  },

  -- macOS native fullscreen (Cmd+Ctrl+f also works)
  {
    key = 'f',
    mods = 'CMD|CTRL',
    action = wezterm.action.ToggleFullScreen,
  },

  -- Synchronize panes (tmux synchronize-panes)
  {
    key = 'e',
    mods = 'LEADER',
    action = wezterm.action.Multiple({
      wezterm.action.SendKey({ key = 'e', mods = 'LEADER' }),
    }),
  },
}

-- ========================================
-- Copy mode (Vi-style key bindings)
-- ========================================

config.key_tables = {
  copy_mode = {
    { key = 'Escape', mods = 'NONE', action = wezterm.action.CopyMode('Close') },
    { key = 'q', mods = 'NONE', action = wezterm.action.CopyMode('Close') },

    -- Navigation
    { key = 'h', mods = 'NONE', action = wezterm.action.CopyMode('MoveLeft') },
    { key = 'j', mods = 'NONE', action = wezterm.action.CopyMode('MoveDown') },
    { key = 'k', mods = 'NONE', action = wezterm.action.CopyMode('MoveUp') },
    { key = 'l', mods = 'NONE', action = wezterm.action.CopyMode('MoveRight') },

    -- Word navigation
    { key = 'w', mods = 'NONE', action = wezterm.action.CopyMode('MoveForwardWord') },
    { key = 'b', mods = 'NONE', action = wezterm.action.CopyMode('MoveBackwardWord') },

    -- Beginning/end of line
    { key = '0', mods = 'NONE', action = wezterm.action.CopyMode('MoveToStartOfLine') },
    { key = '$', mods = 'SHIFT', action = wezterm.action.CopyMode('MoveToEndOfLineContent') },

    -- Page navigation
    { key = 'g', mods = 'NONE', action = wezterm.action.CopyMode('MoveToScrollbackTop') },
    { key = 'G', mods = 'SHIFT', action = wezterm.action.CopyMode('MoveToScrollbackBottom') },
    { key = 'u', mods = 'CTRL', action = wezterm.action.CopyMode('PageUp') },
    { key = 'd', mods = 'CTRL', action = wezterm.action.CopyMode('PageDown') },

    -- Start selection
    { key = 'v', mods = 'NONE', action = wezterm.action.CopyMode({ SetSelectionMode = 'Cell' }) },
    { key = 'V', mods = 'SHIFT', action = wezterm.action.CopyMode({ SetSelectionMode = 'Line' }) },

    -- Copy (copy to clipboard with y)
    {
      key = 'y',
      mods = 'NONE',
      action = wezterm.action.Multiple({
        wezterm.action.CopyTo('ClipboardAndPrimarySelection'),
        wezterm.action.CopyMode('Close'),
      }),
    },
    {
      key = 'Enter',
      mods = 'NONE',
      action = wezterm.action.Multiple({
        wezterm.action.CopyTo('ClipboardAndPrimarySelection'),
        wezterm.action.CopyMode('Close'),
      }),
    },
  },
}

-- ========================================
-- Tab bar format settings (tmux-style)
-- ========================================

wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
  local title = tab.active_pane.title
  local index = tab.tab_index

  -- Get process name (e.g. zsh, vim, htop)
  local process_name = title:match('([^/]+)$') or title

  -- tmux-style format: "number:process_name"
  local tab_title = string.format('%d:%s', index, process_name)

  -- Add * to active tabs
  if tab.is_active then
    tab_title = tab_title .. '*'
  end

  return {
    { Text = ' ' .. tab_title .. ' ' },
  }
end)

-- ========================================
-- Status bar settings
-- ========================================

wezterm.on('update-right-status', function(window, pane)
  -- Hostname and pane info (replicating tmux status bar left side)
  local hostname = wezterm.hostname()
  local pane_id = pane:pane_id()

  -- Date/time (replicating tmux status bar right side)
  local date = wezterm.strftime('%Y-%m-%d(%a) %H:%M')

  -- Display in status bar
  window:set_left_status(wezterm.format({
    { Text = hostname .. ':[' .. pane_id .. '] ' },
  }))

  window:set_right_status(wezterm.format({
    { Text = '[' .. date .. ']' },
  }))
end)

-- ========================================
-- SSH background color change
-- ========================================

wezterm.on('update-status', function(window, pane)
  local fg_process_name = pane:get_foreground_process_name()
  local overrides = window:get_config_overrides() or {}

  -- Change background color when SSH is running
  if string.find(fg_process_name or '', 'ssh') then
    overrides.colors = {
      background = '#001e1e',  -- Darker background color for SSH sessions
    }
  else
    overrides.colors = nil  -- Reset to default colors
  end

  window:set_config_overrides(overrides)
end)

-- ========================================
-- Other settings
-- ========================================

-- Scrollback lines
config.scrollback_lines = 10000

-- Mouse settings
config.mouse_bindings = {
  -- Right-click to paste
  {
    event = { Down = { streak = 1, button = 'Right' } },
    mods = 'NONE',
    action = wezterm.action.PasteFrom('Clipboard'),
  },
}

-- Reduce escape sequence delay by default
config.enable_csi_u_key_encoding = true

-- Terminal type
config.term = 'xterm-256color'

-- ========================================
-- Startup settings
-- ========================================

-- Maximize window on startup
wezterm.on('gui-startup', function(cmd)
  local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)

return config
