-- Hammerspoon configuration file
-- Ghostty global hotkey configuration

-- ========================================
-- Toggle Ghostty show/hide (Option+Space)
-- ========================================

-- Option+Space to show/hide Ghostty
hs.hotkey.bind({"option"}, "space", function()
  local ghostty = hs.application.find("Ghostty")

  if ghostty then
    -- If Ghostty is running
    if ghostty:isFrontmost() then
      -- Hide if in front
      ghostty:hide()
    else
      -- Show if in background
      ghostty:activate()
    end
  else
    -- Launch Ghostty if not running
    hs.application.launchOrFocus("Ghostty")
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
