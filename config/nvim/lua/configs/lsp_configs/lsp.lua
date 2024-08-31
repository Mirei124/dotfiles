-- 1. mason
-- 2. mason-lspconfig
-- 3. lspconfig

return function()
  require("mason").setup({
    log_level = vim.log.levels.WARN,
    ui = {
      border = "single",
      icons = {
        package_installed = "✓",
        package_pending = "➜",
        package_uninstalled = "✗",
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

  -- Set icons for sidebar.
  local icons = require("utils.icons").get("diagnostics", true)
  local diagnostic_icons = {
    Error = icons.Error_alt,
    Warn = icons.Warning_alt,
    Info = icons.Information_alt,
    Hint = icons.Hint_alt,
  }
  for type, icon in pairs(diagnostic_icons) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl })
  end

  --- lspconfig --------------------------------------------
  local lspconfig = require("lspconfig")

  -- :h lsp-handler-configuration
  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
      -- :h vim.diagnostic.config()
      underline = {
        -- set to HINT for pyright to display gray out text
        severity = vim.diagnostic.severity.HINT,
      },
      virtual_text = {
        severity = vim.diagnostic.severity.ERROR,
      },
      signs = true,
      float = {
        style = "minimal",
        border = "single",
        focusable = false,
      },
      update_in_insert = false,
    }
  )

  -- local function attach_handler(client, bufnr)
  --   if client.name == "tsserver" then
  --     client.server_capabilities.documentFormattingProvider = false
  --   end
  -- end
  local opts = {
    --on_attach = attach_handler,
    capabilities = require("cmp_nvim_lsp").default_capabilities(),
  }

  require("mason-lspconfig").setup_handlers({
    function(server_name)
      local server_opts = opts

      local server_conf_file = vim.fn.stdpath("config") ..
          "/lua/configs/lsp_configs/server_configs/" ..
          server_name .. ".lua"
      if vim.fn.filereadable(server_conf_file) == 1
      then
        local require_ok
        require_ok, server_opts = pcall(require,
          "configs.lsp_configs.server_configs." .. server_name)
        if require_ok then
          server_opts = vim.tbl_deep_extend("force", server_opts, opts)
        else
          --vim.print(vim.inspect(server_opts))
          vim.notify("[mason-lspconfig] server settings of " ..
            server_name .. " load failed", vim.log.levels.WARN)
          server_opts = opts
        end
        -- else
        --   vim.notify("[mason-lspconfig] server " .. server_name ..
        --     " not configured", vim.log.levels.DEBUG)
      end

      -- :h lspconfig-setup
      lspconfig[server_name].setup(server_opts)
    end
  })

  vim.api.nvim_command("LspStart")
end
