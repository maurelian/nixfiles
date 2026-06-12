-- Treesitter (ported from nixvim plugins.treesitter). Pinned to the classic
-- `master` branch + configs API. Parsers compile with the system C compiler
-- (Xcode CLT). nixvim installed grammars implicitly; here we name a sensible set.
return {
  "nvim-treesitter/nvim-treesitter",
  branch = "master",
  build = ":TSUpdate",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = {
        "lua", "vim", "vimdoc", "bash", "python", "go", "rust", "nix",
        "json", "yaml", "toml", "javascript", "typescript", "tsx",
        "markdown", "markdown_inline", "solidity",
      },
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = { enable = true },
    })
  end,
}
