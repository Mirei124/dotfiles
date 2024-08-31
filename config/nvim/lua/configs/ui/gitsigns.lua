return function()
  local bind = require("utils.bind")

  local function gitsigns_keymap(buf)
    local actions = require("gitsigns.actions")
    local map = {
      ["n|]c"] = bind.map_callback(function()
            if vim.wo.diff then
              return "]c"
            end
            vim.schedule(function()
              actions.next_hunk()
            end)
            return "<Ignore>"
          end)
          :with_buffer(buf)
          :with_expr()
          :with_desc("git: Goto next hunk"),
      ["n|[c"] = bind.map_callback(function()
            if vim.wo.diff then
              return "[c"
            end
            vim.schedule(function()
              actions.prev_hunk()
            end)
            return "<Ignore>"
          end)
          :with_buffer(buf)
          :with_expr()
          :with_desc("git: Goto prev hunk"),
      ["n|<leader>hb"] = bind.map_callback(function()
            actions.blame_line({ full = true })
          end)
          :with_buffer(buf)
          :with_desc("git: Blame line"),
      ["n|<leader>hd"] = bind.map_callback(function()
            actions.diffthis()
          end)
          :with_buffer(buf)
          :with_desc("git: Diff file"),
      ["n|<leader>hu"] = bind.map_cr("Gitsigns reset_hunk")
          :with_silent()
          :with_buffer(buf)
          :with_desc("git: Reset hunk"),
    }
    bind.nvim_load_mapping(map)
  end

  require("gitsigns").setup({
    signs = {
      add = { text = "│", },
      change = { text = "│", },
      delete = { text = "_", },
      topdelete = { text = "‾", },
      changedelete = { text = "~", },
    },
    on_attach = gitsigns_keymap,
    watch_gitdir = { interval = 1000, follow_files = true },
    current_line_blame = false,
    current_line_blame_opts = { delay = 1000, virtual_text_pos = "eol" },
    sign_priority = 6,
    update_debounce = 100,
    status_formatter = nil, -- Use default
    word_diff = false,
    diff_opts = { internal = true },
  })
end
