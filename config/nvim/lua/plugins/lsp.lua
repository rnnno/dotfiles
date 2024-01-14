return {
  'neovim/nvim-lspconfig',
  dependencies = {
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
  },
  -- lazy = true,
  -- event = 'BufReadPre',
  config = function()
    require('lspconfig.ui.windows').default_options.border = 'single'
    require('mason').setup({
      ui = { border = 'single' }
    })
    require('mason-lspconfig').setup()
    require('mason-lspconfig').setup_handlers({
      function(server_name)
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities.textDocument.completion.completionItem.snippetSupport = true
        require('lspconfig')[server_name].setup {}
      end
    })

    local keymap = vim.keymap.set
    keymap('n', 'ge', '<CMD>lua vim.diagnostic.open_float()<CR>')
    keymap('n', 'g]', '<CMD>lua vim.diagnostic.goto_next()<CR>')
    keymap('n', 'g[', '<CMD>lua vim.diagnostic.goto_prev()<CR>')
    keymap('n', 'K', '<CMD>lua vim.lsp.buf.hover()<CR>')
    keymap('n', 'gd', '<CMD>lua vim.lsp.buf.definition<CR>')
    keymap('n', 'gD', '<CMD>lua vim.lsp.buf.declartion<CR>')
    keymap('n', 'gt', '<CMD>lua vim.lsp.buf.type_definition<CR>')
    keymap('n', 'gr', '<CMD>lua vim.lsp.buf.references<CR>')
    keymap('n', 'ga', '<CMD>lua vim.lsp.buf.code_action<CR>')
    keymap('n', 'gi', '<CMD>lua vim.lsp.buf.implementation<CR>')
    keymap('n', 'gf', '<CMD>lua vim.lsp.buf.format({ async = true })<CR>')
    keymap('n', 'gn', '<CMD>lua vim.lsp.buf.rename()<CR>')
  end,

}
