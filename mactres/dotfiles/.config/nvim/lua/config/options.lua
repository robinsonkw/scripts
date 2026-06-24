-- ~/.config/nvim/lua/config/options.lua
local opt = vim.opt

vim.g.mapleader = " "
vim.g.maplocalleader = " "

opt.termguicolors = true
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.number = true
opt.relativenumber = false
opt.cursorline = true
opt.showcmd = true
opt.incsearch = true
opt.hlsearch = true
opt.ignorecase = true
opt.smartcase = true
opt.linebreak = true
opt.textwidth = 80
opt.wrapmargin = 0
opt.breakindent = true
opt.wrap = true
opt.colorcolumn = "100"
opt.list = true
opt.listchars = { tab = "▸ ", trail = "·" }
opt.foldlevelstart = 99
opt.foldmethod = "expr"        -- Better with Treesitter
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.lazyredraw = true
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.updatetime = 300
opt.timeoutlen = 500

