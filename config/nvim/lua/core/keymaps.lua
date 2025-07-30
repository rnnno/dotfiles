local keymap = vim.keymap.set

vim.g.mapleader = ' '

local opts = { noremap = true, silent = true }

-- visual mode
keymap('n', '<A-v>', '<C-v>', opts)

-- save
keymap('n', '<leader>w', '<CMD>w<CR>', opts)

-- move cursor
keymap('n', 'j', 'gj', opts)
keymap('n', 'k', 'gk', opts)

-- move line
keymap("n", "<M-j>", "<Cmd>move .+1<CR>==", opts)
keymap("x", "<M-j>", ":move '>+1<CR>gv=gv", opts)
keymap("n", "<M-k>", "<Cmd>move .-2<CR>==", opts)
keymap("x", "<M-k>", ":move '<-2<CR>gv=gv", opts)

-- split window
keymap('n', 'ss', '<CMD>split<Return><C-w>w', opts)
keymap('n', 'sv', '<CMD>vsplit<Return><C-w>w', opts)

-- move window
keymap('n', '<leader>h', '<C-w>h', opts)
keymap('n', '<leader>k', '<C-w>k', opts)
keymap('n', '<leader>j', '<C-w>j', opts)
keymap('n', '<leader>l', '<C-w>l', opts)

-- escape
keymap('i', 'jj', '<Esc>', opts)
keymap('t', 'jj', '<C-\\><C-n>', opts)

-- edit config
keymap('n', '<F1>', '<CMD>edit $MYVIMRC<CR>', opts)