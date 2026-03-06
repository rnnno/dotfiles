return {
  {
    'folke/noice.nvim',
    event = 'VimEnter',
    dependencies = {
      'MunifTanjim/nui.nvim',
      'rcarriga/nvim-notify',
    },
    opts = {
      lsp = {
        signature = {
          enabled = false,
        }
      },
      routes = {
        {
          filter = {
            event = 'lsp',
            find = 'hecking',
          },
          opts = { skip = true },
        },
      },
    },
  },
  {
    'rcarriga/nvim-notify',
    event = 'VimEnter',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    config = function()
      require('notify').setup({
        render = 'wrapped-compact',
        stages = 'static',
        max_width = 50,
      })
    end,
  }
}
