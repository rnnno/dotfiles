return {
  'nvim-tree/nvim-tree.lua',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
    'antosha417/nvim-lsp-file-operations',
    'echasnovski/mini.base16',
  },
  lazy = true,
  keys = {
    { '<leader>n', ':NvimTreeToggle<CR>' },
  },
  cmd = {
    'NvimTreeToggle',
  },
  config = function()
    local width = math.floor(vim.fn.winwidth(0) * 0.8)
    local height = vim.fn.winheight(0) - 2

    local row = (vim.fn.winheight(0) - height) / 2
    local col = (vim.fn.winwidth(0) - width) / 2

    require("nvim-tree").setup({
      view = {
        float = {
          enable = true,
          open_win_config = {
            relative = "editor",
            border = "rounded",
            width = width,
            height = height,
            row = row,
            col = col,
          },
        },
      },
      renderer = {
        group_empty = true,
        icons = {
          web_devicons = {
            folder = {
              enable = true,
            },
          },
        },
      },
      actions = {
        open_file = {
          quit_on_open = true,
        },
      },
      filters = {
        dotfiles = true,
      },
    })

    local keymap = vim.keymap.set
    keymap('n', '<leader>n', ':NvimTreeToggle<CR>')
  end,
}
