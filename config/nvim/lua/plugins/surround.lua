return {
  'kylechui/nvim-surround',
  lazy = true,
  event = 'VimEnter',
  config = function()
    require('nvim-surround').setup()
  end
}
