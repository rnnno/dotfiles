return {
  'neovim/nvim-lspconfig',
  dependencies = {
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
  },
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    local server_configs = require('lsp')
    local servers = vim.tbl_keys(server_configs)
    require('mason').setup({
      ui = { border = 'single' },
    })
    require('mason-lspconfig').setup({
      ensure_installed = servers,
      automatic_installation = true,
    })

    vim.diagnostic.config({
      virtual_text = false,
      virtual_lines = { current_line = true },
      float = { border = 'single' },
      severity_sort = true,
    })

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    local completion_item = capabilities.textDocument.completion.completionItem
    completion_item.snippetSupport = true
    completion_item.preselectSupport = true
    completion_item.insertReplaceSupport = true
    completion_item.labelDetailsSupport = true
    completion_item.deprecatedSupport = true
    completion_item.commitCharactersSupport = true
    completion_item.tagSupport = { valueSet = { 1 } }
    completion_item.resolveSupport = {
      properties = {
        'documentation',
        'detail',
        'additionalTextEdits',
      },
    }

    local default_handlers = {
      ['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'single' }),
      ['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'single' }),
    }

    vim.lsp.config('*', {
      capabilities = capabilities,
      handlers = default_handlers,
    })

    for name, config in pairs(server_configs) do
      vim.lsp.config(name, config)
    end

    if #servers > 0 then
      vim.lsp.enable(servers)
    end

    local group = vim.api.nvim_create_augroup('UserLspKeymaps', { clear = true })
    vim.api.nvim_create_autocmd('LspAttach', {
      group = group,
      callback = function(event)
        local opts = { silent = true, buffer = event.buf }

        local function map(lhs, rhs, desc)
          local map_opts = vim.tbl_extend('force', {}, opts, { desc = desc })
          vim.keymap.set('n', lhs, rhs, map_opts)
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
}

