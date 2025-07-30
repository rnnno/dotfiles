return {
  'catppuccin/nvim',
  name = 'catppuccin',
  config = function()
    require('catppuccin').setup({
      flavour = 'macchiato',
      transparent_background = true,
    })

    vim.cmd [[ colorscheme catppuccin]]

    vim.api.nvim_set_hl(0, 'LineNr', { fg = '#fffacd' })
    vim.api.nvim_set_hl(0, 'Comment', { fg = '#a9a9a9' })
  end
}
