-- Ported from nixvim `opts`, `globals`, and `extraConfigLua`.

-- Leader (set before lazy/plugins load)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opt = vim.opt
opt.number = true
opt.relativenumber = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.expandtab = true
opt.smartindent = true
opt.wrap = false
opt.swapfile = false
opt.backup = false
opt.undofile = true
opt.hlsearch = false
opt.incsearch = true
opt.termguicolors = true
opt.scrolloff = 8
opt.updatetime = 50
opt.signcolumn = "yes"
opt.clipboard = "unnamedplus"
-- Neovim 0.11: rounded borders for hover/signature/diagnostic floats
-- (replaces the old vim.lsp.handlers border overrides).
opt.winborder = "rounded"

-- Diagnostics
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  update_in_insert = false,
  underline = true,
  severity_sort = true,
  float = { border = "rounded", source = true },
})

-- Treat .sol files as Solidity
vim.filetype.add({ extension = { sol = "solidity" } })
