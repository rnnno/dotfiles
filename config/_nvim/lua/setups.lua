-- LSPconfig
require('mason').setup()
require('mason-lspconfig').setup_handlers({ function(server)
  local opt = {
    capabilities = require('cmp_nvim_lsp').default_capabilities(
      vim.lsp.protocol.make_client_capabilities()
    )
  }
  require('lspconfig')[server].setup(opt)
end })


local cmp = require('cmp')
local lspkind = require('lspkind')

cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn['vsnip#anonymous'](args.body)
    end
  },
  window = {
    completion = cmp.config.window.bordered({
      border = 'single'
    }),
    documentation = cmp.config.window.bordered({
      border = 'single'
    }),
  },
  mapping = cmp.mapping.preset.insert({
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    ['<C-b>'] = cmp.mapping.scroll_docs(-5),
    ['<C-f>'] = cmp.mapping.scroll_docs(3),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  formatting = {
    format = lspkind.cmp_format({
      mode = 'symbol',
      maxwidth = 49,
      ellipsis_char = '...',
    })
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
    { name = 'nvim_lsp_signature_help' },
    { name = 'calc' },
  }, {
    { name = 'buffer', keyword_length = 1 },
  })
})

cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'nvim_lsp_document_symbol' }
  }, {
    { name = 'buffer' }
  })
})

cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline', keyword_length = 1 }
  })
})

local capabilities = require('cmp_nvim_lsp').default_capabilities()
vim.cmd('let g:vsnip_filetypes = {}')



require 'nvim-treesitter.configs'.setup {
  ensure_installed = { "c", "lua", "typescript", "tsx", "javascript", "json", "lua", "bash", "astro", "markdown",
    "css", "scss", "yaml", "toml", "vue", "php", "html", "vim", "query" },

  sync_install = false,

  auto_install = true,

  ignore_install = { "javascript" },


  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
}

require('aerial').setup({
  on_attach = function(bufnr)
    vim.keymap.set('n', '{', '<cmd>AerialPrev<CR>', { buffer = bufnr })
    vim.keymap.set('n', '}', '<cmd>AerialNext<CR>', { buffer = bufnr })
  end
})
vim.keymap.set('n', '<leader>a', '<cmd>AerialToggle!<CR>')


require('nightfox').setup({
  options = {
    styles = {
      comments = "italic",
      keywords = "bold",
      types = "italic,bold",
    }
  }
})



require("lsp-colors").setup({
  Error = "#db4b4b",
  Warning = "#e0af68",
  Information = "#0db9d7",
  Hint = "#10B981"
})

require("nvim-treesitter.configs").setup {
  yati = {
    enable = true,
    disable = { "python" },
    default_lazy = true,
    default_fallback = "auto"
  },
  indent = {
    enable = false -- disable builtin indent module
  }
}


require("nvim-treesitter.configs").setup {
  highlight = {
  },
  rainbow = {
    enable = true,
    extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
    max_file_lines = nil, -- Do not enable for files with more than n lines, int
    -- colors = {}, -- table of hex strings
    -- termcolors = {} -- table of colour name strings
  }
}

require('nvim-web-devicons').get_icons()
require('nvim-web-devicons').has_loaded()

require("lualine").setup()

require('telescope').setup()

require('telescope').setup({
  defaults = {
    layout_config = {
      vertical = { width = 0.5 }
    },
  },
})

require('todo-comments').setup()

require("sidebar-nvim").setup({
  open = true,
  sections = { "files", "git", "todos", "diagnostics" },
  todos = { ignored_paths = { "~" }, initially_closed = true },
  files = {
    show_hidden = false,
    ignored_paths = { "%.git$" }
  }
})
require("sidebar-nvim.builtin.todos").open_all()
