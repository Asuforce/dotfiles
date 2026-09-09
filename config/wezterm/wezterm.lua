-- WezTerm configuration file
--
-- Pane/tab/workspace management is owned by herdr, not by WezTerm. WezTerm is
-- kept as the drawing surface only: no leader key, no pane or tab bindings.
-- See config/herdr/config.toml for the multiplexer bindings (prefix: ctrl+g).

local wezterm = require('wezterm')
local config = {}

-- Module-level state for opacity toggle
local opacity_is_opaque = false

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

-- Color scheme (drives pane contents; herdr's own UI has its own theme)
config.color_scheme = 'OneDark (Gogh)'

-- OneDark (Gogh) ships #5C6370 (its comment grey) as the foreground, which is
-- barely readable against its #1E2127 background. Use the scheme's actual text
-- colour instead. This is what pane contents inside herdr are drawn with.
config.colors = {
  foreground = '#ABB2BF',
}

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

-- Hide the tab bar: herdr draws its own tab bar and status entries, and
-- nothing here creates a second WezTerm tab.
config.hide_tab_bar_if_only_one_tab = true

-- ========================================
-- Key bindings settings
-- ========================================

-- No leader key: ctrl+g belongs to herdr's prefix. Only bindings that herdr
-- has no equivalent for are kept here.
config.keys = {
  -- Toggle fullscreen
  {
    key = 'f',
    mods = 'CMD|CTRL',
    action = wezterm.action.ToggleFullScreen,
  },

  -- Toggle window transparency
  {
    key = 't',
    mods = 'CMD|CTRL',
    action = wezterm.action_callback(function(window, pane)
      opacity_is_opaque = not opacity_is_opaque
      local overrides = window:get_config_overrides() or {}
      if opacity_is_opaque then
        overrides.window_background_opacity = 1.0
      else
        overrides.window_background_opacity = nil
      end
      window:set_config_overrides(overrides)
    end),
  },
}

-- ========================================
-- Other settings
-- ========================================

-- Scrollback lines (herdr keeps its own scrollback for panes)
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
