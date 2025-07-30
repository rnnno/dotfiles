return {
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = true,
    event = 'VeryLazy',
    dependencies = {
      'yioneko/nvim-yati',
    },
    config = function()
      require('nvim-treesitter.configs').setup({
        ensure_installed = { 'c', 'cpp', 'vim', 'lua', 'go', 'html', 'css', 'tsx', 'typescript' },
        auto_install = true,
        highlight = {
          enable = true,
        },

        yati = {
          enable = true,
          default_lazy = true,
        },
        indent = {
          enable = false,
        },
      })
    end
  },
  {
    'andersevenrud/nvim_context_vt',
    lazy = true,
    event = 'BufWinEnter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      require('nvim_context_vt').setup({
        enable = true,
      })
    end
  },
  {
    'Wansmer/treesj',
    lazy = true,
    keys = {
      { '<leader>m', "<CMD>lua require('treesj').toggle()<CR>" },
    },
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      require('treesj').setup({
        use_default_keymaps = false,
      })
    end,
  }

}
