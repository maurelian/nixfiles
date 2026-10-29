-- Native Neovim config (ported from modules/nixvim.nix). Edit live, no rebuild;
-- changes apply on next `nvim` launch. Plugins managed by lazy.nvim.

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Options/globals must load before lazy so <leader> is set for plugin keymaps.
require("config.options")
require("lazy").setup("plugins", {
  change_detection = { notify = false },
})
require("config.keymaps")
