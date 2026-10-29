-- Smaller editor plugins (ported from nixvim: nvim-autopairs, comment,
-- indent-blankline, nvim-surround, web-devicons).
return {
  { "nvim-tree/nvim-web-devicons", lazy = true },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
  },
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
  },
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    opts = {},
  },
}
