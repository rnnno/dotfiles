return {
  'nvim-telescope/telescope.nvim',
  lazy = true,
  cmd = 'Telescope',
  keys = {
    { 'ff', '<CMD>Telescope file_browser<CR>', desc = 'Find file' },
    { 'fg', '<CMD>Telescope live_grep<CR>', desc = 'Find text' },
    { 'fb', '<CMD>Telescope buffers<CR>', desc = 'Find buffers' },
    { 'fh', '<CMD>Telescope help_tags<CR>', desc = 'Find help' },
    { 'fn', '<CMD>Telescope notify<CR>', desc = 'Find notifications' },
  },
  dependencies = {
    'nvim-telescope/telescope-file-browser.nvim',
    'nvim-lua/plenary.nvim',
  },
  config = function()
    require('telescope').load_extension('file_browser')
  end,
}
