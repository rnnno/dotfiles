 return {
   'catppuccin/nvim',
   name = 'catppuccin',
   config = function()
     require('catppuccin').setup({
       flavour = 'macchiato',
     })
     vim.cmd[[colorscheme catppuccin]]
     -- vim.cmd[[colorscheme habamax]]
   end
 }

