local keymap = vim.keymap.set

vim.g.mapleader = ' '

keymap('n', '<A-v>', '<C-v>')

keymap('n', '<leader>w', '<CMD>w<CR>')

keymap('n', 'j', 'gj')
keymap('n', 'k', 'gk')

keymap("n", "<M-j>", "<Cmd>move .+1<CR>==")
keymap("x", "<M-j>", ":move '>+1<CR>gv=gv")
keymap("n", "<M-k>", "<Cmd>move .-2<CR>==")
keymap("x", "<M-k>", ":move '<-2<CR>gv=gv")

keymap('n', 'ss', '<CMD>split<Return><C-w>w')
keymap('n', 'sv', '<CMD>vsplit<Return><C-w>w')

keymap('n', '<leader>h', '<C-w>h')
keymap('n', '<leader>k', '<C-w>k')
keymap('n', '<leader>j', '<C-w>j')
keymap('n', '<leader>l', '<C-w>l')

keymap('i', 'jj', '<Esc>')
keymap('t', 'jj', '<C-\\><C-n>')

keymap('n', '<F1>', '<CMD>edit $MYVIMRC<CR>')
