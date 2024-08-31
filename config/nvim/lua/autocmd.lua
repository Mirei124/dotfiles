-- auto toggle fcitx5 state
Fcitx_should_restore = false

vim.api.nvim_create_autocmd("InsertLeave", {
  callback = function()
    local current_state = vim.fn.systemlist("fcitx5-remote")[1]
    if current_state == "2" then -- not en
      vim.fn.system("fcitx5-remote -c")
      Fcitx_should_restore = true
    end
  end
})

vim.api.nvim_create_autocmd("InsertEnter", {
  callback = function()
    if Fcitx_should_restore then
      local current_state = vim.fn.systemlist("fcitx5-remote")[1]
      if current_state == "1" then -- en
        vim.fn.system("fcitx5-remote -o")
        Fcitx_should_restore = false
      end
    end
  end
})
