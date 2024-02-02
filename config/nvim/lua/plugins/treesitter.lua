return {
  'nvim-treesitter/nvim-treesitter',
  lazy = true,
  event = 'BufReadPre',
  dependencies = {
    'yioneko/nvim-yati',
    'andersevenrud/nvim_context_vt',
  },
  config = function()
    require('nvim-treesitter.configs').setup({
      ensure_installed = { 'c', 'cpp', 'vim', 'lua', 'go', 'html', 'css', 'tsx', 'typescript' },
      auto_install = true,
      highlight = {
        enable = true,
      },

      yati = {
        enable = true,
        default_lazy = true,
      },
      indent = {
        enable = false,
      },
    })


    require('nvim_context_vt').setup({
      enable = true,
    })
  end

}
