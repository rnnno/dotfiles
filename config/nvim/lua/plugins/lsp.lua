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
      vim.lsp.config(name, vim.tbl_deep_extend('force', {
        capabilities = capabilities,
        handlers = default_handlers,
      }, config))
    end

    if #servers > 0 then
      vim.lsp.enable(servers)
    end

    local group = vim.api.nvim_create_augroup('UserLspKeymaps', { clear = true })
    vim.api.nvim_create_autocmd('LspAttach', {
      group = group,
      callback = function(event)
        local opts = { silent = true, buffer = event.buf }

        vim.keymap.set('n', 'ge', vim.diagnostic.open_float, vim.tbl_extend('force', opts, { desc = 'Diagnostics (float)' }))
        vim.keymap.set('n', 'g]', vim.diagnostic.goto_next, vim.tbl_extend('force', opts, { desc = 'Next diagnostic' }))
        vim.keymap.set('n', 'g[', vim.diagnostic.goto_prev, vim.tbl_extend('force', opts, { desc = 'Prev diagnostic' }))
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, vim.tbl_extend('force', opts, { desc = 'LSP hover' }))
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, vim.tbl_extend('force', opts, { desc = 'Go to definition' }))
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, vim.tbl_extend('force', opts, { desc = 'Go to declaration' }))
        vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, vim.tbl_extend('force', opts, { desc = 'Type definition' }))
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, vim.tbl_extend('force', opts, { desc = 'List references' }))
        vim.keymap.set('n', 'ga', vim.lsp.buf.code_action, vim.tbl_extend('force', opts, { desc = 'Code action' }))
        vim.keymap.set('n', 'gn', vim.lsp.buf.rename, vim.tbl_extend('force', opts, { desc = 'Rename symbol' }))
      end,
    })
  end,
}

