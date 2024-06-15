return {
  'neovim/nvim-lspconfig',
  dependencies = {
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
  },
  lazy = true,
  event = 'BufEnter',
  config = function()
    local nvim_lsp = require('lspconfig')
    require('lspconfig.ui.windows').default_options.border = 'single'
    require('mason').setup({
      ui = { border = 'single' }
    })
    require('mason-lspconfig').setup()
    require('mason-lspconfig').setup_handlers({
      function(server_name)
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities.textDocument.completion.completionItem.snippetSupport = true

        local root = nvim_lsp.util.root_pattern("deno.json", "deno.jsonc", "package.json")(vim.fn.getcwd()) or
            (vim.fn.getcwd())
        -- local root = nvim_lsp.util.root_pattern("deno.json", "deno.jsonc","package.json")
        local is_deno_root = vim.fn.glob(root .. '/deno.json') ~= '' or vim.fn.glob(root .. '/deno.jsonc') ~= ''
        local is_node_root = vim.fn.glob(root .. '/package.json') ~= ''

        local opts = {}

        if server_name == "lua_ls" then
          opts.settings = {
            Lua = {
              runtime = {
                version = "LuaJIT",
                pathStrict = true,
                path = { "?.lua", "?/init.lua" },
              },
              workspace = {
                library = vim.list_extend(vim.api.nvim_get_runtime_file("lua", true), {
                  "${3rd}/luv/library",
                  "${3rd}/busted/library",
                  "${3rd}/luassert/library",
                }),
                checkThirdParty = "Disable",
              },
            },
          }
        end

        if server_name == "denols" then
          if not is_deno_root then
            return
          end

          opts.root_dir = nvim_lsp.util.root_pattern("deno.json", "deno.jsonc")
          opts.init_options = {
            lint = true,
            unstable = true,
            suggest = {
              imports = {
                hosts = {
                  ["https://deno.land"] = true,
                  ["https://cdn.nest.land"] = true,
                  ["https://crux.land"] = true
                }
              }
            }
          }
        end

        if server_name == "tsserver" then
          if not is_node_root then
            return
          end

          opts.root_dir = nvim_lsp.util.root_pattern("package.json")
        end

        if server_name == "eslint" then
          if not is_node_root then
            return
          end

          opts.root_dir = nvim_lsp.util.root_pattern("package.json")
        end

        require('lspconfig')[server_name].setup(opts)
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
