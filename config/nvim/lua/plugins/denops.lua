return {
  'vim-denops/denops.vim',
  lazy = true,
  cmd = { 'DenopsFixCache' },
  config = function()
    vim.cmd [[
      " Fix Deno module cache issue
      command! DenopsFixCache call denops#cache#update(#{reload: v:true})
    ]]
  end,
}

