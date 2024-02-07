return {
  'kylechui/nvim-surround',
  lazy = true,
  event = 'BufReadPre',
  config = function()
    require('nvim-surround').setup()
  end
}
