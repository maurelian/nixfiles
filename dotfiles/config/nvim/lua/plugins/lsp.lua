-- LSP (ported from nixvim plugins.lsp). Server binaries come from nix (on PATH);
-- no mason. nvim-lspconfig ships the per-server definitions (cmd/filetypes/root)
-- that the Neovim 0.11 `vim.lsp.config`/`vim.lsp.enable` API consumes.
-- Servers: ts_ls, pyright, gopls, rust_analyzer (via rustup), nil_ls, jsonls,
-- yamlls, bashls (+ lua_ls for editing this config).
return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = { "hrsh7th/cmp-nvim-lsp" },
  config = function()
    -- completion capabilities for every server
    vim.lsp.config("*", {
      capabilities = require("cmp_nvim_lsp").default_capabilities(),
    })

    -- lua_ls: teach it the `vim` global so editing this config is quiet
    vim.lsp.config("lua_ls", {
      settings = {
        Lua = {
          diagnostics = { globals = { "vim" } },
          workspace = { checkThirdParty = false },
        },
      },
    })

    vim.lsp.enable({
      "ts_ls", "pyright", "gopls", "rust_analyzer",
      "nil_ls", "jsonls", "yamlls", "bashls", "lua_ls",
    })
  end,
}
