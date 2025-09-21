return {
  'kevinhwang91/nvim-ufo',
  event = { 'BufReadPost', 'BufNewFile' },
  dependencies = {
    'kevinhwang91/promise-async',
  },
  config = function()
    vim.o.foldcolumn = '0'
    vim.o.foldlevel = 99
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true

    local ufo = require('ufo')

    ufo.setup({
      provider_selector = function(_, filetype)
        local ts_only = {
          markdown = true,
          yaml = true,
        }
        if ts_only[filetype] then
          return { 'treesitter', 'indent' }
        end
        return { 'lsp', 'indent' }
      end,
      close_fold_kinds_for_ft = {
        default = { 'imports' },
      },
      preview = {
        win_config = {
          border = 'single',
          winblend = 0,
        },
      },
    })

    local function map(lhs, rhs, desc)
      vim.keymap.set('n', lhs, rhs, { silent = true, desc = desc })
    end

    map('zR', ufo.openAllFolds, 'UFO: すべて開く')
    map('zM', ufo.closeAllFolds, 'UFO: すべて閉じる')
    map('zr', function()
      ufo.openFoldsExceptKinds({ 'imports' })
    end, 'UFO: import 以外を開く')
    map('zm', function()
      ufo.closeFoldsWith(0)
    end, 'UFO: レベル指定で閉じる')
    map('zp', function()
      local winid = ufo.peekFoldedLinesUnderCursor()
      if not winid then
        vim.lsp.buf.hover()
      end
    end, 'UFO: 折りたたみをプレビュー')
  end,
}
