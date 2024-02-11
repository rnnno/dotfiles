return {
  'vim-skk/skkeleton',
  lazy = true,
  event = 'BufReadPre',
  dependencies = {
    'vim-denops/denops.vim',
  },
  config = function()
    local keymap = vim.keymap.set
    keymap('i', '<C-j>', '<Plug>(skkeleton-toggle)')
    keymap('c', '<C-j>', '<Plug>(skkeleton-toggle)')
    keymap('t', '<C-j>', '<plug>(skkeleton-toggle)')

    local dictionaries = {}
    local handle = io.popen("ls $HOME/.skk/*")   -- フルバスで取得
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
      keepState = true,
    })

    if vim.fn.expand('%:e') == 'txt' or vim.fn.expand('%:e') == 'md' then
      vim.fn['skkeleton#config']({ keepState = true })
    else
      vim.fn['skkeleton#config']({ keepState = false })
    end

    vim.fn['skkeleton#register_kanatable'](
      'rom',
      {
        jj = 'escape',
      }
    )
  end,

}
