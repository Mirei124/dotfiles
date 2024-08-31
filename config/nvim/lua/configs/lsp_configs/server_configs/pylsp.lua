return {
  settings = {
    -- https://github.com/python-lsp/python-lsp-server
    pylsp = {
      plugins = {
        autopep8 = {
          enabled = false,
        },
        yapf = {
          enabled = true,
        },
        jedi_completion = {
          fuzzy = false,
          include_class_objects = true,
          include_function_objects = true,
        },
        pycodestyle = {
          enabled = true,
          maxLineLength = 120,
        },
        pydocstyle = {
          enabled = true,
        },
        pyflakes = {
          enabled = false,
        },
      }
    }
  }
}
