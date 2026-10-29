-- which-key (ported from nixvim plugins.which-key). v3 API: groups via `add`.
return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    delay = 500,
  },
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)
    wk.add({
      { "<leader>f", group = "Find", icon = "🔍" },
      { "<leader>g", group = "Git", icon = "" },
      { "<leader>c", group = "Code", icon = "" },
      { "<leader>r", group = "Rename", icon = "" },
    })
  end,
}
