-- WezTerm設定ファイル
-- iTerm2 + tmuxからの移行設定

local wezterm = require('wezterm')
local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- ========================================
-- 外観設定
-- ========================================

-- ウィンドウの透過設定（iTerm2の半透明を再現）
config.window_background_opacity = 0.7

-- macOSのブラー効果
config.macos_window_background_blur = 0

-- フルスクリーン設定（別デスクトップにならない）
config.native_macos_fullscreen_mode = false

-- カラースキーム
config.color_scheme = 'OneDark (gogh)'

-- フォント設定
config.font = wezterm.font_with_fallback({
  'HackGen35 Console',
  'HackGen Console',
  'Monaco',
  'Menlo',
})
config.font_size = 14.0
config.use_ime = true

-- ウィンドウ設定
config.window_decorations = 'RESIZE'
config.window_padding = {
  left = 5,
  right = 5,
  top = 5,
  bottom = 5,
}

-- タブバーを上部に表示（tmux風）
config.tab_bar_at_bottom = false
config.use_fancy_tab_bar = false  -- シンプルなタブバー
config.show_tabs_in_tab_bar = true  -- タブを表示
config.hide_tab_bar_if_only_one_tab = false  -- 1つのタブでもバーを表示
config.tab_max_width = 32  -- タブの最大幅
config.show_new_tab_button_in_tab_bar = false  -- "+" ボタンを非表示

-- タブバーの色設定（tmux風）
config.colors = {
  tab_bar = {
    background = '#1a1b26',  -- タブバーの背景色
    active_tab = {
      bg_color = '#7aa2f7',  -- アクティブタブの背景色
      fg_color = '#1a1b26',  -- アクティブタブの文字色
      intensity = 'Bold',
    },
    inactive_tab = {
      bg_color = '#292e42',  -- 非アクティブタブの背景色
      fg_color = '#565f89',  -- 非アクティブタブの文字色
    },
    inactive_tab_hover = {
      bg_color = '#3b4261',  -- ホバー時の背景色
      fg_color = '#c0caf5',  -- ホバー時の文字色
    },
  },
}

-- ========================================
-- キーバインド設定（tmux風）
-- ========================================

-- リーダーキー: Ctrl+g（tmuxのprefixと同じ）
config.leader = { key = 'g', mods = 'CTRL', timeout_milliseconds = 1000 }

config.keys = {
  -- リーダーキー + r: 設定のリロード
  {
    key = 'r',
    mods = 'LEADER',
    action = wezterm.action.ReloadConfiguration,
  },

  -- ペイン分割
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

  -- ペイン移動（Vim風: h,j,k,l）
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

  -- ペインリサイズ（Ctrl+h,j,k,l）
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

  -- ウィンドウ（タブ）移動（Option+Left/Right）
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

  -- 新規ウィンドウ（タブ）作成（Option+Enter）
  {
    key = 'Enter',
    mods = 'OPT',
    action = wezterm.action.SpawnTab('CurrentPaneDomain'),
  },

  -- ペイン削除（x）
  {
    key = 'x',
    mods = 'LEADER',
    action = wezterm.action.CloseCurrentPane({ confirm = true }),
  },

  -- ウィンドウ（タブ）削除（X）
  {
    key = 'X',
    mods = 'LEADER|SHIFT',
    action = wezterm.action.CloseCurrentTab({ confirm = true }),
  },

  -- ペインのズーム切り替え（tmuxのzoom機能）
  {
    key = 'z',
    mods = 'LEADER',
    action = wezterm.action.TogglePaneZoomState,
  },

  -- コピーモード（Leader+v）
  {
    key = 'v',
    mods = 'LEADER',
    action = wezterm.action.ActivateCopyMode,
  },

  -- フルスクリーン切り替え（Ctrl+g → f）
  {
    key = 'f',
    mods = 'LEADER',
    action = wezterm.action.ToggleFullScreen,
  },

  -- macOS標準のフルスクリーン（Cmd+Ctrl+f でも可）
  {
    key = 'f',
    mods = 'CMD|CTRL',
    action = wezterm.action.ToggleFullScreen,
  },

  -- ペインの同期（tmuxのsynchronize-panes）
  {
    key = 'e',
    mods = 'LEADER',
    action = wezterm.action.Multiple({
      wezterm.action.SendKey({ key = 'e', mods = 'LEADER' }),
    }),
  },
}

-- ========================================
-- コピーモード（Vi風キーバインド）
-- ========================================

config.key_tables = {
  copy_mode = {
    { key = 'Escape', mods = 'NONE', action = wezterm.action.CopyMode('Close') },
    { key = 'q', mods = 'NONE', action = wezterm.action.CopyMode('Close') },

    -- 移動
    { key = 'h', mods = 'NONE', action = wezterm.action.CopyMode('MoveLeft') },
    { key = 'j', mods = 'NONE', action = wezterm.action.CopyMode('MoveDown') },
    { key = 'k', mods = 'NONE', action = wezterm.action.CopyMode('MoveUp') },
    { key = 'l', mods = 'NONE', action = wezterm.action.CopyMode('MoveRight') },

    -- 単語移動
    { key = 'w', mods = 'NONE', action = wezterm.action.CopyMode('MoveForwardWord') },
    { key = 'b', mods = 'NONE', action = wezterm.action.CopyMode('MoveBackwardWord') },

    -- 行頭/行末
    { key = '0', mods = 'NONE', action = wezterm.action.CopyMode('MoveToStartOfLine') },
    { key = '$', mods = 'SHIFT', action = wezterm.action.CopyMode('MoveToEndOfLineContent') },

    -- ページ移動
    { key = 'g', mods = 'NONE', action = wezterm.action.CopyMode('MoveToScrollbackTop') },
    { key = 'G', mods = 'SHIFT', action = wezterm.action.CopyMode('MoveToScrollbackBottom') },
    { key = 'u', mods = 'CTRL', action = wezterm.action.CopyMode('PageUp') },
    { key = 'd', mods = 'CTRL', action = wezterm.action.CopyMode('PageDown') },

    -- 選択開始
    { key = 'v', mods = 'NONE', action = wezterm.action.CopyMode({ SetSelectionMode = 'Cell' }) },
    { key = 'V', mods = 'SHIFT', action = wezterm.action.CopyMode({ SetSelectionMode = 'Line' }) },

    -- コピー（yでクリップボードにコピー）
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
-- タブバーのフォーマット設定（tmux風）
-- ========================================

wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
  local title = tab.active_pane.title
  local index = tab.tab_index

  -- プロセス名を取得（例: zsh, vim, htop）
  local process_name = title:match('([^/]+)$') or title

  -- tmux風のフォーマット: "番号:プロセス名"
  local tab_title = string.format('%d:%s', index, process_name)

  -- アクティブなタブには * を付ける
  if tab.is_active then
    tab_title = tab_title .. '*'
  end

  return {
    { Text = ' ' .. tab_title .. ' ' },
  }
end)

-- ========================================
-- ステータスバー設定
-- ========================================

wezterm.on('update-right-status', function(window, pane)
  -- ホスト名とペイン情報（tmuxのステータスバー左側を再現）
  local hostname = wezterm.hostname()
  local pane_id = pane:pane_id()

  -- 日時（tmuxのステータスバー右側を再現）
  local date = wezterm.strftime('%Y-%m-%d(%a) %H:%M')

  -- ステータスバーに表示
  window:set_left_status(wezterm.format({
    { Text = hostname .. ':[' .. pane_id .. '] ' },
  }))

  window:set_right_status(wezterm.format({
    { Text = '[' .. date .. ']' },
  }))
end)

-- ========================================
-- その他の設定
-- ========================================

-- スクロールバック行数
config.scrollback_lines = 10000

-- マウス設定
config.mouse_bindings = {
  -- 右クリックでペースト
  {
    event = { Down = { streak = 1, button = 'Right' } },
    mods = 'NONE',
    action = wezterm.action.PasteFrom('Clipboard'),
  },
}

-- デフォルトでのエスケープシーケンスのディレイを減らす
config.enable_csi_u_key_encoding = true

-- ターミナルタイプ
config.term = 'xterm-256color'

-- ========================================
-- 起動時の設定
-- ========================================

-- ウィンドウを起動時に最大化
wezterm.on('gui-startup', function(cmd)
  local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)

return config
