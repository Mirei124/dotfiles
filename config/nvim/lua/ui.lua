local night_theme = "carbonfox"
local day_theme = "dayfox"
My_theme = night_theme

return {
  toggle_theme = function(target_theme)
    if target_theme == nil then
      if night_theme == My_theme
      then
        target_theme = day_theme
      else
        target_theme = night_theme
      end
    end
    vim.cmd("colorscheme " .. target_theme)
    require("lualine").setup({ options = { theme = target_theme } })
    My_theme = target_theme
  end
}
