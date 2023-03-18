return {
  settings = {
    pylsp = {
      plugins = {
        autopep8 = { enabled = false },
        jedi_completion = {
          eager = true,
          fuzzy = true,
          include_class_objects = true,
          include_function_objects = true,
        },
        pycodestyle = {
          maxLineLength = 120
        },
        -- checks Python source files for errors
        pyflakes = { enabled = false },
        yapf = {
          enabled = true,
          args = '--style={column_limit: 120}'
        },
      }
    }
  }
}
