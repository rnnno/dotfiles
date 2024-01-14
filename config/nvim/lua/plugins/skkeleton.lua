return {
  'vim-skk/skkeleton',
  dependencies = {
    'vim-denops/denops.vim',
  },
  config = function()
    local keymap = vim.keymap.set
    keymap('i', '<C-j>', '<Plug>(skkeleton-toggle)')
    keymap('c', '<C-j>', '<Plug>(skkeleton-toggle)')
    keymap('t', '<C-j>', '<plug>(skkeleton-toggle)')

    local dictionaries = {
      '~/.skk/SKK-JISYO.L'
    }

    vim.fn['skkeleton#config']({
      eggLikeNewline = true,
      registerConvertResult = true,
      globalDictionaries = dictionaries,
    })

    vim.fn['skkeleton#register_kanatable'](
      'rom',
      {
        jj = 'escape',
      }
    )
  end,

}
