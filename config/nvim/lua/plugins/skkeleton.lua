return {
  'vim-skk/skkeleton',
  lazy = true,
  event = 'BufReadPre',
  dependencies = {
    'vim-denops/denops.vim',
  },
  config = function()
    local keymap = vim.keymap.set
    local opts = { silent = true, remap = true }
    keymap('i', '<C-j>', '<Plug>(skkeleton-enable)', opts)
    keymap('c', '<C-j>', '<Plug>(skkeleton-enable)', opts)
    keymap('t', '<C-j>', '<plug>(skkeleton-enable)', opts)
    keymap('n', '<C-j>', 'i<plug>(skkeleton-enable)', opts)

    local dictionaries = {}
    local handle = io.popen('ls $HOME/.skk/*')
    if handle then
      for file in handle:lines() do
        table.insert(dictionaries, file)
      end
      handle:close()
    end

    vim.fn['skkeleton#config']({
      eggLikeNewline = true,
      registerConvertResult = true,
      globalDictionaries = dictionaries,
      keepState = false,
    })

    vim.fn['skkeleton#register_kanatable'](
      'rom',
      {
        jj = 'escape',
        ['!'] = { '!', '' },
      }
    )
  end,
}

