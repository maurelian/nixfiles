-- catppuccin (ported from nixvim colorschemes.catppuccin)
return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000, -- load before other plugins so highlights are set first
  lazy = false,
  opts = {
    flavour = "mocha",
    transparent_background = false,
    integrations = {
      cmp = true,
      gitsigns = true,
      nvimtree = false,
      treesitter = true,
      telescope = { enabled = true },
      which_key = true,
    },
  },
  config = function(_, opts)
    require("catppuccin").setup(opts)
    vim.cmd.colorscheme("catppuccin")
  end,
}
