return {
  {
    'akinsho/bufferline.nvim',
    lazy = true,
    event = 'BufWinEnter',
    dependencies = {
      'famiu/bufdelete.nvim',
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      require('bufferline').setup({
        options = {
          indicator = {
            style = 'underline',
          },
          show_close_icon = false,
          show_buffer_close_icons = false,
          show_tab_indicators = false,
          -- show_duplicate_prefix = true,
          separator_style = { '', '' },
          always_show_bufferline = true,
          diagnostics = 'nvim_lsp',
          diagnostics_indicator = function(_, _, diagnostics_dict)
            local output = ' '
            for kind, total in pairs(diagnostics_dict) do
              local symbol = kind == 'error' and ' '
                  or (kind == 'warning' and ' ' or '')
              output = output .. total .. symbol
            end
            return output
          end,
        },
      })

      local keymap = vim.keymap.set
      local opts = { noremap = true, silent = true }

      keymap('n', '<A-,>', '<CMD>BufferLineCyclePrev<CR>', opts)
      keymap('n', '<A-.>', '<CMD>BufferLineCycleNext<CR>', opts)

      keymap('n', '<leader>d', "<CMD>lua require('bufdelete').bufdelete(0, true)<CR>", opts)
    end,
  },
  {
    'Bekaboo/dropbar.nvim',
    lazy = true,
    event = 'BufWinEnter',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
      'nvim-treesitter/nvim-treesitter',
    },
    opts = {
      menu = {
        preview = true,
      },
    },
    config = function(_, config_opts)
      local dropbar = require('dropbar')
      dropbar.setup(config_opts)

      local api = require('dropbar.api')
      local keymap = vim.keymap.set
      local opts = { noremap = true, silent = true }

      keymap('n', '<leader>bb', function()
        api.pick()
      end, opts)
    end,
  },
}
