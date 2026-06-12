-- Telescope (ported from nixvim plugins.telescope, incl. its keymaps).
return {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  keys = {
    { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
    { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
    { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Find buffers" },
    { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
    { "<leader>fc", "<cmd>Telescope commands<cr>", desc = "Commands (command palette)" },
    { "<leader>fk", "<cmd>Telescope keymaps<cr>", desc = "Find keymaps" },
    { "<leader>gs", "<cmd>Telescope git_status<cr>", desc = "Git status" },
    { "<leader>gc", "<cmd>Telescope git_commits<cr>", desc = "Git commits" },
  },
  config = function()
    local telescope = require("telescope")
    telescope.setup({
      defaults = {
        layout_config = {
          horizontal = { prompt_position = "top" },
        },
        sorting_strategy = "ascending",
      },
    })
    telescope.load_extension("fzf")
  end,
}
