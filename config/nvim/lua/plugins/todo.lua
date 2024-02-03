return {
  "folke/todo-comments.nvim",
  lazy = true,
  event = 'BufReadPre',
  config = function()
    require('todo-comments').setup()
  end
}
