return {
  'neovim/nvim-lspconfig',
  dependencies = {
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
  },
  lazy = true,
  event = 'VimEnter',
  config = function()
    local servers = {
      "lua_ls", "ts_ls", "eslint", "denols", "jsonls", "clangd", "rust_analyzer", "taplo", "autotools_ls"
    }

    local nvim_lsp = require('lspconfig')
    require('lspconfig.ui.windows').default_options.border = 'single'
    require('mason').setup({
      ui = { border = 'single' },
    })

    require('mason-lspconfig').setup({
      automatic_enable = true,
      ensure_installed = servers,
      automatic_installation = true,
      handlers = {
        function(server_name)
          local capabilities = require("cmp_nvim_lsp").default_capabilities()

          local cwd = vim.loop.cwd()
          local is_deno_root = vim.fn.glob(cwd .. '/deno.json') ~= '' or vim.fn.glob(cwd .. '/deno.jsonc') ~= ''
          local is_node_root = vim.fn.glob(cwd .. '/package.json') ~= ''

          local opts = {
            capabilities = capabilities,
          }

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
            if not is_deno_root then return end
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
            if not is_node_root then return end
            opts.root_dir = nvim_lsp.util.root_pattern("package.json")
          end

          if server_name == "eslint" then
            if not is_node_root then return end
            opts.root_dir = nvim_lsp.util.root_pattern("package.json")
          end

          require('lspconfig')[server_name].setup(opts)
        end
      },
    })

    local keymap = vim.keymap.set
    local opts = { noremap = true, silent = true }

    keymap('n', 'ge', vim.diagnostic.open_float, opts)
    keymap('n', 'g]', vim.diagnostic.goto_next, opts)
    keymap('n', 'g[', vim.diagnostic.goto_prev, opts)
    keymap('n', 'K', vim.lsp.buf.hover, opts)
    keymap('n', 'gd', vim.lsp.buf.definition, opts)
    keymap('n', 'gD', vim.lsp.buf.declaration, opts)
    keymap('n', 'gt', vim.lsp.buf.type_definition, opts)
    keymap('n', 'gr', vim.lsp.buf.references, opts)
    keymap('n', 'ga', vim.lsp.buf.code_action, opts)
    keymap('n', 'gi', vim.lsp.buf.implementation, opts)
    keymap('n', 'gf', function() vim.lsp.buf.format({ async = true }) end, opts)
    keymap('n', 'gn', vim.lsp.buf.rename, opts)
  end,
}

