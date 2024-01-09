local keymap = vim.keymap.set

vim.g.mapleader = ' '

-- <C-v>だとペーストしちゃうから変更
keymap('n', '<A-v>', '<C-v>')

keymap('n', '<leader>w', ':w<CR>')

keymap('n', 'j', 'gj')
keymap('n', 'k', 'gk')


keymap("n", "<M-j>", "<Cmd>move .+1<CR>==")
keymap("x", "<M-j>", ":move '>+1<CR>gv=gv")
keymap("n", "<M-k>", "<Cmd>move .-2<CR>==")
keymap("x", "<M-k>", ":move '<-2<CR>gv=gv")

-- 画面分割
keymap('n', 'ss', ':split<Return><C-w>w')
keymap('n', 'sv', ':vsplit<Return><C-w>w')
-- アクティブウィンドウの移動
keymap('n', '<leader>h', '<C-w>h')
keymap('n', '<leader>k', '<C-w>k')
keymap('n', '<leader>j', '<C-w>j')
keymap('n', '<leader>l', '<C-w>l')

-- jjでインサート抜ける
keymap('i', 'jj', '<Esc>')
keymap('t', 'jj', '<C-\\><C-n>')

-- keymap('i', 'll', '<Right>')

keymap('n', '<F1>', ':edit $MYVIMRC<CR>')


