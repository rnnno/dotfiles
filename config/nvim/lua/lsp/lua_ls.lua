local library = vim.api.nvim_get_runtime_file('lua', true)

vim.list_extend(library, {
  '${3rd}/luv/library',
  '${3rd}/busted/library',
  '${3rd}/luassert/library',
})

return {
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
        pathStrict = true,
        path = { '?.lua', '?/init.lua' },
      },
      workspace = {
        library = library,
        checkThirdParty = 'Disable',
      },
    },
  },
}
