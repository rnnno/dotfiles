local keymap = vim.keymap.set

return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
    },
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lsp = require('lsp')
      local servers = vim.tbl_keys(lsp.servers)
      require('mason').setup({
        ui = { border = 'single' },
      })
      require('mason-lspconfig').setup({
        ensure_installed = servers,
        automatic_installation = true,
      })

      lsp.setup_common()

      for name, config in pairs(lsp.servers) do
        vim.lsp.config(name, config)
      end

      if #servers > 0 then
        vim.lsp.enable(servers)
      end

      local group = vim.api.nvim_create_augroup('UserLspKeymaps', { clear = true })
      vim.api.nvim_create_autocmd('LspAttach', {
        group = group,
        callback = function(event)
          local opts = { noremap = true, silent = true, buffer = event.buf }

          local function map(lhs, rhs, desc)
            keymap('n', lhs, rhs, vim.tbl_extend('force', {}, opts, { desc = desc }))
          end

          map('ge', vim.diagnostic.open_float, 'Diagnostics (float)')
          map('g]', vim.diagnostic.goto_next, 'Next diagnostic')
          map('g[', vim.diagnostic.goto_prev, 'Prev diagnostic')
          map('K', vim.lsp.buf.hover, 'LSP hover')
          map('gd', vim.lsp.buf.definition, 'Go to definition')
          map('gD', vim.lsp.buf.declaration, 'Go to declaration')
          map('gt', vim.lsp.buf.type_definition, 'Type definition')
          map('gr', vim.lsp.buf.references, 'List references')
          map('ga', vim.lsp.buf.code_action, 'Code action')
          map('gn', vim.lsp.buf.rename, 'Rename symbol')
        end,
      })
    end,
  },
  {
    'bassamsdata/namu.nvim',
    event = 'LspAttach',
    dependencies = {
      'MunifTanjim/nui.nvim',
    },
    keys = {
      {
        '<leader>rn',
        function()
          require('namu').rename()
        end,
        desc = 'Namu rename',
        mode = { 'n', 'v' },
      },
    },
    opts = {},
  },
}

