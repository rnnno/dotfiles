return {
  'catppuccin/nvim',
  name = 'catppuccin',
  config = function()
    require('catppuccin').setup({
      flavour = 'macchiato',
      transparent_background = true,
    })

    vim.cmd [[ colorscheme catppuccin]]

    local transparent_groups = {
      -- 'Normal',
      'VertSplit',
      'StatusLine',
      'StatusLineNC',
      'TabLine',
      'TabLineFill',
      'NormalFloat',
      'NormalNC',
      'NormalSB',
      'FloatTitle',
      'FloatFooter',
      'TelescopeNormal',
      'TelescopeSelectionCaret',
    }
    for _, group in ipairs(transparent_groups) do
      vim.api.nvim_set_hl(0, group, { bg = 'NONE' })
    end

    -- なんかこうしないと白くなる
    vim.cmd [[ highlight FloatBorder guibg=NONE ]]

    vim.api.nvim_set_hl(0, 'LineNr', { fg = '#fffacd' })
    vim.api.nvim_set_hl(0, 'Comment', { fg = '#a9a9a9' })
  end
}

