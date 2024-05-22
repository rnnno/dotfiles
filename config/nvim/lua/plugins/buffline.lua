return {
  'akinsho/bufferline.nvim',
  lazy = true,
  event = 'BufReadPre',
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
        diagnostics_indicator = function(count, level, diagnostics_dict, context)
          local s = " "
          for e, n in pairs(diagnostics_dict) do
            local sym = e == "error" and " "
                or (e == "warning" and " " or "")
            s = s .. n .. sym
          end
          return s
        end
      }


    })

    local keymap = vim.keymap.set
    keymap('n', '<A-,>', '<CMD>BufferLineCyclePrev<CR>')
    keymap('n', '<A-.>', '<CMD>BufferLineCycleNext<CR>')

    keymap('n', '<leader>d', "<CMD>lua require('bufdelete').bufdelete(0, true)<CR>")
  end
}
