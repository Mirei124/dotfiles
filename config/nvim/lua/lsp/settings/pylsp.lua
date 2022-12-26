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
        pyflakes = { enabled = false },
      }
    }
  }
}
