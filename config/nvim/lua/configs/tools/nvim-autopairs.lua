return function()
  require("nvim-autopairs").setup({
    disable_filetype = {
      "TelescopePrompt",
      "spectre_panel",
      "bigfile_disable_treesitter"
    },
    fast_wrap = {},
  })

  -- If you want insert `(` after select function or method item
  local cmp_autopairs = require('nvim-autopairs.completion.cmp')
  local cmp = require('cmp')
  cmp.event:on(
    'confirm_done',
    cmp_autopairs.on_confirm_done()
  )
end
