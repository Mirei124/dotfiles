require("mason").setup({
  --log_level = vim.log.levels.INFO,
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗"
    }
  }
})

require("mason-lspconfig").setup({
  ensure_installed = {
    "lua_ls",
    "bashls",
    "jsonls",
    "lemminx",
  }
})

local lspconfig = require('lspconfig')
local opts = {}

opts = {
  on_attach = require("lsp.handlers").on_attach,
  capabilities = require("lsp.handlers").capabilities,
}

require("mason-lspconfig").setup_handlers {
  function(server_name)
    local require_ok, conf_opts = pcall(require, 'lsp.settings.' .. server_name)
    if require_ok then
      conf_opts = vim.tbl_deep_extend('force', conf_opts, opts)
      -- vim.pretty_print(conf_opts)
    else
      conf_opts = opts
    end
    lspconfig[server_name].setup(conf_opts)
  end,
}
