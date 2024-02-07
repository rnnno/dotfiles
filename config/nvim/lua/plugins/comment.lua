return {
  'numToStr/Comment.nvim',
  lazy = true,
  event = 'BufReadPre',
  config = function()
    require('Comment').setup()
  end
}
