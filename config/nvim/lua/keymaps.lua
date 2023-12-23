local keymap = vim.keymap.set

vim.g.mapleader = ' '

-- <C-v>だとペーストしちゃうから変更
keymap('n', '<A-v>', '<C-v>')
keymap('n', '<leader>w', ':w<CR>')

keymap('n', 'j', 'gj')
keymap('n', 'k', 'gk')

vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function() vim.lsp.buf.format() end,
  group = vim.api.nvim_create_augroup("lsp_document_format", { clear = true })
})

keymap('n', '<space>e', vim.diagnostic.open_float)
keymap('n', '[d', vim.diagnostic.goto_prev)
keymap('n', ']d', vim.diagnostic.goto_next)

keymap('n', 'K', vim.lsp.buf.hover)
keymap('n', 'gd', vim.lsp.buf.definition)
keymap('n', 'gi', vim.lsp.buf.implementation)
keymap('n', 'gr', vim.lsp.buf.references)
-- keymap('n', '<space>f', vim.lsp.buf.formatting)

keymap("n", "<M-j>", "<Cmd>move .+1<CR>==")
keymap("x", "<M-j>", ":move '>+1<CR>gv=gv")
keymap("n", "<M-k>", "<Cmd>move .-2<CR>==")
keymap("x", "<M-k>", ":move '<-2<CR>gv=gv")



-- キーバインド
-- 画面分割
keymap('n', 'ss', ':split<Return><C-w>w')
keymap('n', 'sv', ':vsplit<Return><C-w>w')
-- アクティブウィンドウの移動
keymap('n', '<leader>h', '<C-w>h')
keymap('n', '<leader>k', '<C-w>k')
keymap('n', '<leader>j', '<C-w>j')
keymap('n', '<leader>l', '<C-w>l')

keymap('n', '<A-a>', ':term<CR>')

keymap('i', 'jj', '<Esc>')
keymap('t', 'jj', '<C-\\><C-n>')

keymap('i', 'll', '<Right>')

keymap('n', '<F1>', ':edit $MYVIMRC<CR>')

keymap('n', '<leader>n', ':Fern .<CR>')

local builtin = require('telescope.builtin')
keymap('n', 'ff', builtin.find_files, {})
keymap('n', 'fg', builtin.live_grep, {})
keymap('n', 'fb', builtin.buffers, {})
keymap('n', 'fh', builtin.help_tags, {})

-- Move to previous/next
keymap('n', '<A-,>', '<Cmd>BufferPrevious<CR>')
keymap('n', '<A-.>', '<Cmd>BufferNext<CR>')
-- Re-order to previous/next
keymap('n', '<A-<>', '<Cmd>BufferMovePrevious<CR>')
keymap('n', '<A->>', '<Cmd>BufferMoveNext<CR>')
-- Goto buffer in position...
keymap('n', '<A-1>', '<Cmd>BufferGoto 1<CR>')
keymap('n', '<A-2>', '<Cmd>BufferGoto 2<CR>')
keymap('n', '<A-3>', '<Cmd>BufferGoto 3<CR>')
keymap('n', '<A-4>', '<Cmd>BufferGoto 4<CR>')
keymap('n', '<A-5>', '<Cmd>BufferGoto 5<CR>')
keymap('n', '<A-6>', '<Cmd>BufferGoto 6<CR>')
keymap('n', '<A-7>', '<Cmd>BufferGoto 7<CR>')
keymap('n', '<A-8>', '<Cmd>BufferGoto 8<CR>')
keymap('n', '<A-9>', '<Cmd>BufferGoto 9<CR>')
keymap('n', '<A-0>', '<Cmd>BufferLast<CR>')
-- Pin/unpin buffer
keymap('n', '<A-p>', '<Cmd>BufferPin<CR>')
-- Close buffer
keymap('n', '<A-c>', '<Cmd>BufferClose<CR>')

keymap('n', '<C-p>', '<Cmd>BufferPick<CR>')
-- Sort automatically by...
keymap('n', '<Space>bb', '<Cmd>BufferOrderByBufferNumber<CR>')
keymap('n', '<Space>bd', '<Cmd>BufferOrderByDirectory<CR>')
keymap('n', '<Space>bl', '<Cmd>BufferOrderByLanguage<CR>')

-- copilot
keymap("i", "<C-j>", "<Plug>(copilot-next)")
keymap("i", "<C-k>", "<Plug>(copilot-previous)")
keymap("i", "<C-o>", "<Plug>(copilot-dismiss)")
keymap("i", "<C-s>", "<Plug>(copilot-suggest)")
