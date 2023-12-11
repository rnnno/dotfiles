vim.cmd [[packadd packer.nvim]]

require("packer").startup(function()
  use 'wbthomason/packer.nvim'
  -- write plugins.

  -- copilot
  use {
    "github/copilot.vim",
    config = function()
      vim.g.copilot_no_tab_map = true

      keymap(
        "i",
        "<C-g>",
        'copilot#Accept("<CR>")',
        { silent = true, expr = true, script = true, replace_keycodes = false }
      )
    end,
  }

  -- lsp
  use 'neovim/nvim-lspconfig'
  use 'j-hui/fidget.nvim'
  use 'williamboman/mason.nvim'
  use 'williamboman/mason-lspconfig.nvim'

  -- filer
  use 'nvim-tree/nvim-tree.lua'
  use 'lambdalisue/fern.vim'
  use 'lambdalisue/fern-renderer-devicons.vim'
  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.1',
    requires = { { 'nvim-lua/plenary.nvim' } }
  }

  -- git setting
  -- TODO: add git plagins


  -- treesitter
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }
  use "p00f/nvim-ts-rainbow"
  use { "yioneko/nvim-yati", tag = "*", requires = "nvim-treesitter/nvim-treesitter" }

  -- かっこを閉じてくれる
  use 'cohama/lexima.vim'
  -- かっこ閉じるオペレーターを追加
  use "tpope/vim-surround"

  --easymotion
  use "easymotion/vim-easymotion"

  -- TODO: このプラグインようわからんから確認する
  use {
    'stevearc/aerial.nvim',
    config = function() require('aerial').setup() end
  }


  -- lualine
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'nvim-tree/nvim-web-devicons', opt = true }
  }

  -- お気に入り
  use 'sidebar-nvim/sidebar.nvim'

  -- colorschemes
  use "EdenEast/nightfox.nvim"
  use { "catppuccin/nvim", as = "catppuccin" }

  -- lsp系統
  use "hrsh7th/nvim-cmp"
  use "hrsh7th/cmp-nvim-lsp"
  use "hrsh7th/cmp-vsnip"
  use "hrsh7th/vim-vsnip"
  use "hrsh7th/vim-vsnip-integ"
  use "hrsh7th/cmp-nvim-lsp-signature-help"
  use "hrsh7th/cmp-nvim-lsp-document-symbol"
  use "hrsh7th/cmp-calc"
  use "hrsh7th/cmp-buffer"
  use "hrsh7th/cmp-path"
  use "hrsh7th/cmp-cmdline"
  use "onsails/lspkind.nvim"
  use "rafamadriz/friendly-snippets"

  -- アイコン表示に必要らしい
  use 'ryanoasis/vim-devicons'


  -- These optional plugins should be loaded directly because of a bug in Packer lazy loading
  use 'nvim-tree/nvim-web-devicons' -- OPTIONAL: for file icons
  use 'lewis6991/gitsigns.nvim'     -- OPTIONAL: for git status

  -- タブ表示してくれる
  use 'romgrk/barbar.nvim'

  -- error hilighit
  use "folke/lsp-colors.nvim"

  -- todo hilighit
  use "folke/todo-comments.nvim"

  -- comentout
  use "tpope/vim-commentary"
end)
