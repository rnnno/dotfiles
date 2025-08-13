vim.scriptencoding = 'utf-8'

-- Disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Encoding
vim.opt.encoding = 'utf-8'
vim.opt.fileencoding = 'utf-8'

-- UI
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = ''
vim.opt.title = true
vim.opt.showmode = false
vim.opt.showcmd = true
vim.opt.cmdheight = 1
vim.opt.laststatus = 2
vim.opt.scrolloff = 16
vim.opt.showtabline = 2
vim.opt.signcolumn = 'yes'
vim.opt.termguicolors = true
vim.opt.winblend = 0
vim.opt.pumblend = 0
vim.opt.conceallevel = 1
vim.opt.helplang = { 'ja', 'en' }

-- Indent
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.breakindent = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2

-- Search
vim.opt.hlsearch = true
vim.opt.inccommand = 'split'
vim.opt.ignorecase = true

-- Behavior
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.hidden = true
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.clipboard = 'unnamedplus'
vim.opt.updatetime = 1000
vim.opt.shell = 'zsh'

