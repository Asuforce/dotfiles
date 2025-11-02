-- Hammerspoon設定ファイル
-- WezTermのグローバルホットキー設定

-- ========================================
-- WezTerm表示/非表示切り替え（Option+Space）
-- ========================================

-- Option+SpaceでWezTermを前面表示/非表示
hs.hotkey.bind({"option"}, "space", function()
  local wezterm = hs.application.find("WezTerm")

  if wezterm then
    -- WezTermが起動している場合
    if wezterm:isFrontmost() then
      -- 前面にある場合は非表示
      wezterm:hide()
    else
      -- 背面にある場合は前面に表示
      wezterm:activate()
    end
  else
    -- WezTermが起動していない場合は起動
    hs.application.launchOrFocus("WezTerm")
  end
end)

-- ========================================
-- 設定リロード（Ctrl+Option+R）
-- ========================================

hs.hotkey.bind({"ctrl", "option"}, "r", function()
  hs.reload()
  hs.alert.show("Hammerspoon設定をリロードしました")
end)

-- ========================================
-- 起動時のメッセージ
-- ========================================

hs.alert.show("Hammerspoon起動完了")
