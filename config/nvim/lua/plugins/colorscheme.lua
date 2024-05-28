return {
  'catppuccin/nvim',
  name = 'catppuccin',
  config = function()
    require('catppuccin').setup({
      flavour = 'macchiato',
      transparent_backgound = true,
    })
    vim.cmd [[colorscheme catppuccin]]
    vim.cmd [[ highlight Normal guibg=NONE ctermbg=NONE ]]
    vim.cmd [[ highlight VertSplit guibg=NONE ctermbg=NONE ]]
    vim.cmd [[ highlight StatusLine guibg=NONE ctermbg=NONE ]]
    vim.cmd [[ highlight StatusLineNC guibg=NONE ctermbg=NONE ]]

    vim.cmd [[ highlight NormalNC guibg=NONE ]]
    vim.cmd [[ highlight LineNr guifg=#fffacd ]]
    vim.cmd [[ highlight Comment guifg=#a9a9a9]]



    -- vim.cmd[[colorscheme habamax]]
  end
}
