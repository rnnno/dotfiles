return {
  {
    'numToStr/Comment.nvim',
    lazy = true,
    keys = { 'gc', 'gb' },
    opts = {},
  },
  {
    'LudoPinelli/comment-box.nvim',
    lazy = true,
    keys = {
      {
        '<leader>cb',
        function()
          require('comment-box').lbox()
        end,
        desc = 'Comment box (box)',
      },
      {
        '<leader>cc',
        function()
          require('comment-box').cbox()
        end,
        desc = 'Comment box (center)',
      },
    },
  },
}
