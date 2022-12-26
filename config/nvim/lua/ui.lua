local theme_ = 'nightfox'
vim.cmd('colorscheme ' .. theme_)
require('lualine').setup({
  options = {
    theme = theme_,
    component_separators = { left = '|', right = '|'}
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    -- lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_x = {'encoding', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  }
})
