-- Hammerspoon configuration file
-- WezTerm global hotkey configuration

-- ========================================
-- Toggle WezTerm show/hide (Option+Space)
-- ========================================

-- Option+Space to show/hide WezTerm
hs.hotkey.bind({"option"}, "space", function()
  local wezterm = hs.application.find("WezTerm")

  if wezterm then
    -- If WezTerm is running
    if wezterm:isFrontmost() then
      -- Hide if in front
      wezterm:hide()
    else
      -- Show if in background
      wezterm:activate()
    end
  else
    -- Launch WezTerm if not running
    hs.application.launchOrFocus("WezTerm")
  end
end)

-- ========================================
-- Reload configuration (Ctrl+Option+R)
-- ========================================

hs.hotkey.bind({"ctrl", "option"}, "r", function()
  hs.reload()
  hs.alert.show("Hammerspoon configuration reloaded")
end)

-- ========================================
-- Startup message
-- ========================================

hs.alert.show("Hammerspoon startup complete")
