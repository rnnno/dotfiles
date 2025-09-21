return {
  'nvim-telescope/telescope.nvim',
  dependencies = {
    'nvim-telescope/telescope-file-browser.nvim',
    'nvim-lua/plenary.nvim',
  },
  config = function()
    require('telescope').load_extension('file_browser')
    local keymap = vim.keymap.set
    keymap('n', 'ff', '<CMD>Telescope file_browser<CR>')

    keymap('n', 'fg', '<CMD>Telescope live_grep<CR>')
    keymap('n', 'fb', '<CMD>Telescope buffers<CR>')
    keymap('n', 'fh', '<CMD>Telescope help_tags<CR>')
    keymap('n', 'fn', '<CMD>Telescope notify<CR>')
  end,
}
