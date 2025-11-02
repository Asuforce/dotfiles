-- Neovim configuration

-- File type detection
vim.cmd('filetype plugin indent on')

-- Encoding
vim.opt.encoding = 'utf-8'
vim.opt.fileencodings = { 'utf-8', 'iso-2022-jp', 'cp932', 'sjis', 'euc-jp' }

-- Command line completion
vim.opt.wildmenu = true

-- Show typed command at last line
vim.opt.showcmd = true

-- Backspace behavior
vim.opt.backspace = { 'indent', 'eol', 'start' }

-- Auto indent
vim.opt.autoindent = true
vim.opt.shiftwidth = 2

-- Show ruler at the last line
vim.opt.ruler = true

-- Always show status line
vim.opt.laststatus = 2

-- Line numbers
vim.opt.number = true

-- Tab width
vim.opt.tabstop = 2

-- Visual bell
vim.opt.visualbell = true

-- Expand tab to spaces
vim.opt.expandtab = true

-- Highlight search results
vim.opt.hlsearch = true

-- Clipboard
vim.opt.clipboard:append('unnamed')

-- Case insensitive search
vim.opt.ignorecase = true

-- Smart case search
vim.opt.smartcase = true

-- Color scheme
vim.cmd('syntax on')
vim.cmd('color elflord')

-- Window management keybinds
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

keymap('n', 's', '<Nop>', opts)
keymap('n', 'sj', '<C-w>j', opts)
keymap('n', 'sk', '<C-w>k', opts)
keymap('n', 'sl', '<C-w>l', opts)
keymap('n', 'sh', '<C-w>h', opts)
keymap('n', 'sJ', '<C-w>J', opts)
keymap('n', 'sK', '<C-w>K', opts)
keymap('n', 'sL', '<C-w>L', opts)
keymap('n', 'sH', '<C-w>H', opts)
keymap('n', 'sr', '<C-w>r', opts)
keymap('n', 's=', '<C-w>=', opts)
keymap('n', 'sw', '<C-w>w', opts)
keymap('n', 'sO', '<C-w>=', opts)
keymap('n', 'sN', ':<C-u>bn<CR>', opts)
keymap('n', 'sP', ':<C-u>bp<CR>', opts)
keymap('n', 'st', ':<C-u>tabnew<CR>', opts)
keymap('n', 'ss', ':<C-u>sp<CR>', opts)
keymap('n', 'sv', ':<C-u>vs<CR>', opts)
keymap('n', 'sq', ':<C-u>q<CR>', opts)

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Plugin specifications
local plugins = {
  -- Indentation guides
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    opts = {},
  },

  -- Trailing whitespace
  {
    'cappyzawa/trim.nvim',
    opts = {
      trim_on_write = true,
      trim_trailing = true,
      trim_last_line = true,
      trim_first_line = false,
    },
  },

  -- Status line
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      options = {
        icons_enabled = true,
        theme = 'auto',
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        disabled_filetypes = {},
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = false,
        refresh = {
          statusline = 1000,
          tabline = 1000,
          winbar = 1000,
        },
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { 'filename' },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {},
      },
      extensions = {},
    },
  },

  -- File tree
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('nvim-tree').setup({
        sort = {
          sorter = 'name',
          folders_first = true,
        },
        renderer = {
          icons = {
            show = {
              file = true,
              folder = true,
              folder_arrow = true,
              git = true,
            },
          },
        },
        view = {
          side = 'left',
          width = 30,
        },
      })
      -- Keybind for opening nvim-tree with Ctrl-b
      vim.keymap.set('n', '<C-b>', '<cmd>NvimTreeToggle<cr>', { noremap = true, silent = true })
    end,
  },

  -- Icon support
  {
    'nvim-tree/nvim-web-devicons',
    lazy = true,
  },
}

-- Load lazy.nvim
require('lazy').setup(plugins, {
  install = { colorscheme = { 'elflord' } },
})
