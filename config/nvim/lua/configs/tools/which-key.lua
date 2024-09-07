return function()
  local icons = {
    ui = require("utils.icons").get("ui"),
    misc = require("utils.icons").get("misc"),
  }

  require("which-key").setup({
    preset = "classic",
    delay = 200,
    plugins = {
      presets = {
        operators = false,
        motions = false,
        text_objects = false,
        windows = true,
        nav = false,
        z = true,
        g = true,
      },
    },
    icons = {
      breadcrumb = icons.ui.Separator,
      separator = icons.misc.Vbar,
      group = icons.misc.Add,
    },
  })
end
