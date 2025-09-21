return {
  'MagicDuck/grug-far.nvim',
  cmd = 'GrugFar',
  keys = {
    {
      '<leader>sf',
      function()
        require('grug-far').open()
      end,
      desc = 'Search & replace (grug-far)',
    },
  },
  opts = {
    engines = {
      ripgrep = {
        additionalArgs = { '--hidden' },
      },
    },
    preview = {
      border = 'single',
    },
  },
}
