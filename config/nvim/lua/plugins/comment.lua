return {
  'numToStr/Comment.nvim',
  lazy = true,
  event = 'VimEnter',
  config = function()
    require('Comment').setup()
  end
}
