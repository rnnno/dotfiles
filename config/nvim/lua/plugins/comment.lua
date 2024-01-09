return {
    'numToStr/Comment.nvim',
    lazy = true,
    event = 'VeryLazy',
    config = function()
      require('Comment').setup()
    end
}
