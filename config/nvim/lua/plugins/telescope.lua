return {
  'nvim-telescope/telescope.nvim',
  dependencies = {
    'nvim-telescope/telescope-file-browser.nvim',
    'nvim-lua/plenary.nvim',
  },
  config = function()
    require('telescope').load_extension('file_browser')
    local keymap = vim.keymap.set
    local opts = { noremap = true, silent = true }

    keymap('n', 'ff', '<CMD>Telescope file_browser<CR>', opts)
    keymap('n', 'fg', '<CMD>Telescope live_grep<CR>', opts)
    keymap('n', 'fb', '<CMD>Telescope buffers<CR>', opts)
    keymap('n', 'fh', '<CMD>Telescope help_tags<CR>', opts)
    keymap('n', 'fn', '<CMD>Telescope notify<CR>', opts)
  end,
}
