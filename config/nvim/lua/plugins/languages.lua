return {
  {
    'b0o/SchemaStore.nvim',
    lazy = false,
  },
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = { library = { { path = '${3rd}/luv/library', words = false } } },
  },
  {
    "adelarsq/neofsharp.vim",
    lazy = true,
    ft = { "fsharp" },
  },
}
