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
    local handle = io.popen("ls $HOME/.skk/*")
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

    local augroup = vim.api.nvim_create_augroup
    local autocmd = vim.api.nvim_create_autocmd

    augroup('skkeletonKeepState', { clear = true })
    autocmd('BufEnter', {
      group = 'skkeletonKeepState',
      pattern = '*',
      callback = function()
        vim.fn['skkeleton#config']({ keepState = false })
      end
    })
    autocmd('BufEnter', {
      group = 'skkeletonKeepState',
      pattern = { '*.txt', '*.md' },
      callback = function()
        vim.fn['skkeleton#config']({ keepState = true })
      end
    })

    vim.fn['skkeleton#register_kanatable'](
      'rom',
      {
        jj = 'escape',
      }
    )
  end,

}
