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

    })
    local keymap = vim.keymap.set
    keymap('n', '<A-,>', '<CMD>BufferLineCyclePrev<CR>')
    keymap('n', '<A-.>', '<CMD>BufferLineCycleNext<CR>')

    keymap('n', '<leader>d', "<CMD>lua require('bufdelete').bufdelete(0, true)<CR>")
  end
}
