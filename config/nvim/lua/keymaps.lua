local bind = require("utils.bind")
local map_cr = bind.map_cr
local map_cu = bind.map_cu
local map_cmd = bind.map_cmd
local map_callback = bind.map_callback
local et = bind.escape_termcode

Diagnostic_show = true

vim.cmd([[
function! Zoom ()
    " check if is the zoomed state (tabnumber > 1 && window == 1)
    if tabpagenr('$') > 1 && tabpagewinnr(tabpagenr(), '$') == 1
        let l:cur_winview = winsaveview()
        let l:cur_bufname = bufname('')
        tabclose

        " restore the view
        if l:cur_bufname == bufname('')
            call winrestview(cur_winview)
        endif
    else
        tab split
    endif
endfunction
]])

local function command_panel()
  require("telescope.builtin").keymaps({
    lhs_filter = function(lhs)
      return not string.find(lhs, "Þ")
    end,
    layout_config = {
      width = 0.8,
      height = 0.8,
      prompt_position = "top",
    },
  })
end

local function lsp_formatting()
  vim.lsp.buf.format({
    filter = function(client)
      -- local cs = vim.lsp.get_active_clients({ bufnr = vim.fn.bufnr() })
      local disable_clients = {
        "bashls",
        "marksman",
        "pyright",
      }
      for _, v in pairs(disable_clients) do
        if client.name == v then
          return false
        end
      end

      vim.notify("Format using " .. client.name, vim.log.levels.INFO,
        { title = "LSP" })
      return true
    end,
    async = true,
  })
end

-- set leader map
vim.g.mapleader = " "
-- vim.api.nvim_set_keymap("n", " ", "", { noremap = true })
-- vim.api.nvim_set_keymap("x", " ", "", { noremap = true })

local plug_map = {
  -- lsp
  ["n|<leader>li"] = map_cr("LspInfo")
      :with_silent()
      :with_desc("lsp: Info"),
  ["n|<leader>lr"] = map_cr("LspRestart")
      :with_silent()
      :with_nowait()
      :with_desc("lsp: Restart"),

  -- lazy.nvim
  ["n|<leader>ph"] = map_cr("Lazy")
      :with_silent()
      :with_noremap()
      :with_nowait()
      :with_desc("package: Show"),
  ["n|<leader>ps"] = map_cr("Lazy sync")
      :with_silent()
      :with_noremap()
      :with_nowait()
      :with_desc("package: Sync"),
  ["n|<leader>pu"] = map_cr("Lazy update")
      :with_silent()
      :with_noremap()
      :with_nowait()
      :with_desc("package: Update"),
  ["n|<leader>pi"] = map_cr("Lazy install")
      :with_silent()
      :with_noremap()
      :with_nowait()
      :with_desc("package: Install"),
  ["n|<leader>pl"] = map_cr("Lazy log")
      :with_silent()
      :with_noremap()
      :with_nowait()
      :with_desc("package: Log"),
  ["n|<leader>pc"] = map_cr("Lazy check")
      :with_silent()
      :with_noremap()
      :with_nowait()
      :with_desc("package: Check"),
  ["n|<leader>pd"] = map_cr("Lazy debug")
      :with_silent()
      :with_noremap()
      :with_nowait()
      :with_desc("package: Debug"),
  ["n|<leader>pp"] = map_cr("Lazy profile")
      :with_silent()
      :with_noremap()
      :with_nowait()
      :with_desc("package: Profile"),
  ["n|<leader>pr"] = map_cr("Lazy restore")
      :with_silent()
      :with_noremap()
      :with_nowait()
      :with_desc("package: Restore"),
  ["n|<leader>px"] = map_cr("Lazy clean")
      :with_silent()
      :with_noremap()
      :with_nowait()
      :with_desc("package: Clean"),

  -- Plugin: telescope
  ["n|<C-p>"] = map_callback(function()
        command_panel()
      end)
      :with_noremap()
      :with_silent()
      :with_desc("tool: Toggle command panel"),
  ["n|<leader>u"] = map_callback(function()
        require("telescope").extensions.undo.undo()
      end)
      :with_noremap()
      :with_silent()
      :with_desc("edit: Show undo history"),
  -- ["n|<leader>fp"] = map_callback(function()
  --       require("telescope").extensions.projects.projects()
  --     end)
  --     :with_noremap()
  --     :with_silent()
  --     :with_desc("find: Project"),
  ["n|<leader>fr"] = map_callback(function()
        require("telescope").extensions.frecency.frecency()
      end)
      :with_noremap()
      :with_silent()
      :with_desc("find: File by frecency"),
  ["n|<leader>fw"] = map_callback(function()
        require("telescope").extensions.live_grep_args.live_grep_args()
      end)
      :with_noremap()
      :with_silent()
      :with_desc("find: Word in project"),
  ["n|<leader>fe"] = map_cu("Telescope oldfiles")
      :with_noremap()
      :with_silent()
      :with_desc("find: File by history"),
  ["n|<leader>ff"] = map_cu("Telescope find_files")
      :with_noremap()
      :with_silent()
      :with_desc("find: File in project"),
  ["n|<leader>fc"] = map_callback(function()
        require("telescope.builtin").colorscheme({ enable_preview = true })
      end)
      :with_noremap()
      :with_silent()
      :with_desc("ui: Change colorscheme for current session"),
  ["n|<leader>fn"] = map_cu(":enew")
      :with_noremap()
      :with_silent()
      :with_desc("buffer: New"),
  ["n|<leader>fg"] = map_cu("Telescope git_files")
      :with_noremap()
      :with_silent()
      :with_desc("find: file in git project"),
  -- ["n|<leader>fz"] = map_cu("Telescope zoxide list")
  --     :with_noremap()
  --     :with_silent()
  --     :with_desc("edit: Change current direrctory by zoxide"),
  ["n|<leader>fb"] = map_cu("Telescope buffers")
      :with_noremap()
      :with_silent()
      :with_desc("find: Buffer opened"),
  ["n|<leader>fs"] = map_cu("Telescope grep_string")
      :with_noremap()
      :with_silent()
      :with_desc("find: Current word"),
  -- ["n|<leader>fd"] = map_cu("Telescope persisted")
  --     :with_noremap()
  --     :with_silent()
  --     :with_desc("find: Session"),

  -- Plugin: bufferline
  ["n|<A-j>"] = map_cr("BufferLineCycleNext")
      :with_noremap()
      :with_silent()
      :with_desc("buffer: Switch to next"),
  ["n|<A-k>"] = map_cr("BufferLineCyclePrev")
      :with_noremap()
      :with_silent()
      :with_desc("buffer: Switch to prev"),
  ["n|<A-S-j>"] = map_cr("BufferLineMoveNext")
      :with_noremap()
      :with_silent()
      :with_desc("buffer: Move current to next"),
  ["n|<A-S-k>"] = map_cr("BufferLineMovePrev")
      :with_noremap()
      :with_silent()
      :with_desc("buffer: Move current to prev"),
  ["n|<leader>be"] = map_cr("BufferLineSortByExtension")
      :with_noremap()
      :with_desc("buffer: Sort by extension"),
  ["n|<leader>bd"] = map_cr("BufferLineSortByDirectory")
      :with_noremap()
      :with_desc("buffer: Sort by direrctory"),
  ["n|<A-1>"] = map_cr("BufferLineGoToBuffer 1")
      :with_noremap()
      :with_silent()
      :with_desc("buffer: Goto buffer 1"),
  ["n|<A-2>"] = map_cr("BufferLineGoToBuffer 2")
      :with_noremap()
      :with_silent()
      :with_desc("buffer: Goto buffer 2"),
  ["n|<A-3>"] = map_cr("BufferLineGoToBuffer 3")
      :with_noremap()
      :with_silent()
      :with_desc("buffer: Goto buffer 3"),
  ["n|<A-4>"] = map_cr("BufferLineGoToBuffer 4")
      :with_noremap()
      :with_silent()
      :with_desc("buffer: Goto buffer 4"),
  ["n|<A-5>"] = map_cr("BufferLineGoToBuffer 5")
      :with_noremap()
      :with_silent()
      :with_desc("buffer: Goto buffer 5"),
  ["n|<A-6>"] = map_cr("BufferLineGoToBuffer 6")
      :with_noremap()
      :with_silent()
      :with_desc("buffer: Goto buffer 6"),
  ["n|<A-7>"] = map_cr("BufferLineGoToBuffer 7")
      :with_noremap()
      :with_silent()
      :with_desc("buffer: Goto buffer 7"),
  ["n|<A-8>"] = map_cr("BufferLineGoToBuffer 8")
      :with_noremap()
      :with_silent()
      :with_desc("buffer: Goto buffer 8"),
  ["n|<A-9>"] = map_cr("BufferLineGoToBuffer 9")
      :with_noremap()
      :with_silent()
      :with_desc("buffer: Goto buffer 9"),

  -- Plugin: nvim-bufdel
  ["n|<A-q>"] = map_cr("BufDel")
      :with_noremap()
      :with_silent()
      :with_desc("buffer: Delete current"),
  ["n|<A-w>"] = map_cr("close")
      :with_noremap()
      :with_silent()
      :with_desc("buffer: Close current"),

  -- Plugin: Comment
  ["n|gcc"] = map_callback(function()
        return vim.v.count == 0 and et("<Plug>(comment_toggle_linewise_current)")
            or et("<Plug>(comment_toggle_linewise_count)")
      end)
      :with_silent()
      :with_noremap()
      :with_expr()
      :with_desc("edit: Toggle comment for line"),
  ["n|<C-/>"] = map_callback(function()
        return vim.v.count == 0 and et("<Plug>(comment_toggle_linewise_current)")
            or et("<Plug>(comment_toggle_linewise_count)")
      end)
      :with_silent()
      :with_noremap()
      :with_expr()
      :with_desc("edit: Toggle comment for line"),
  ["n|gbc"] = map_callback(function()
        return vim.v.count == 0 and et("<Plug>(comment_toggle_blockwise_current)")
            or et("<Plug>(comment_toggle_blockwise_count)")
      end)
      :with_silent()
      :with_noremap()
      :with_expr()
      :with_desc("edit: Toggle comment for block"),
  -- ["n|gc"] = map_cmd("<Plug>(comment_toggle_linewise)")
  --     :with_silent()
  --     :with_noremap()
  --     :with_desc("edit: Toggle comment for line with operator"),
  -- ["n|gb"] = map_cmd("<Plug>(comment_toggle_blockwise)")
  --     :with_silent()
  --     :with_noremap()
  --     :with_desc("edit: Toggle comment for block with operator"),
  ["x|gc"] = map_cmd("<Plug>(comment_toggle_linewise_visual)")
      :with_silent()
      :with_noremap()
      :with_desc("edit: Toggle comment for line with selection"),
  ["x|gb"] = map_cmd("<Plug>(comment_toggle_blockwise_visual)")
      :with_silent()
      :with_noremap()
      :with_desc("edit: Toggle comment for block with selection"),

  -- Plugin: suda
  ["n|<A-s>"] = map_cu("SudaWrite")
      :with_silent()
      :with_noremap()
      :with_desc("editn: Save file using sudo"),

  -- Plugin: nvim-tree
  ["n|<C-n>"] = map_cr("NvimTreeToggle")
      :with_noremap()
      :with_silent()
      :with_desc("filetree: Toggle"),
  ["n|<leader>nf"] = map_cr("NvimTreeFindFile")
      :with_noremap()
      :with_silent()
      :with_desc("filetree: Find file"),
  ["n|<leader>nr"] = map_cr("NvimTreeRefresh")
      :with_noremap()
      :with_silent()
      :with_desc("filetree: Refresh"),

  -- Plugin: trouble
  ["n|gt"] = map_cr("TroubleToggle")
      :with_noremap()
      :with_silent()
      :with_desc("lsp: Toggle trouble list"),
  ["n|<leader>tr"] = map_cr("TroubleToggle lsp_references")
      :with_noremap()
      :with_silent()
      :with_desc("lsp: Show lsp references"),
  ["n|<leader>td"] = map_cr("TroubleToggle document_diagnostics")
      :with_noremap()
      :with_silent()
      :with_desc("lsp: Show document diagnostics"),
  ["n|<leader>tw"] = map_cr("TroubleToggle workspace_diagnostics")
      :with_noremap()
      :with_silent()
      :with_desc("lsp: Show workspace diagnostics"),
  ["n|<leader>tq"] = map_cr("TroubleToggle quickfix")
      :with_noremap()
      :with_silent()
      :with_desc("lsp: Show quickfix list"),
  ["n|<leader>tl"] = map_cr("TroubleToggle loclist")
      :with_noremap()
      :with_silent()
      :with_desc("lsp: Show loclist"),

  -- Plugin: markdown-preview
  ["n|<F12>"] = map_cr("MarkdownPreviewToggle")
      :with_noremap()
      :with_silent()
      :with_desc("tool: Preview markdown"),

  -- Mice
  -- zoom
  ["n|<A-p>"] = map_cr("call Zoom()")
      :with_noremap()
      :with_silent()
      :with_desc("buffer: Toggle fullscreen"),

  -- toggle wrap
  ["ni|<A-z>"] = map_callback(function()
        if vim.api.nvim_get_option_value("wrap",
              { scope = "local" }) then
          vim.api.nvim_set_option_value("wrap", false,
            { scope = "local" })
        else
          vim.api.nvim_set_option_value("wrap", true,
            { scope = "local" })
        end
      end)
      :with_noremap()
      :with_silent()
      :with_desc("edit: Toggle wrap"),

  ["i|kj"] = map_cmd("<Esc>")
      :with_noremap()
      :with_silent()
      :with_desc("edit: Quit insert mode"),

  ["ni|<A-/>"] = map_callback(function()
        require("ui").toggle_theme()
      end)
      :with_noremap()
      :with_silent()
      :with_desc("ui: Toggle theme"),
}
bind.nvim_load_mapping(plug_map)

local function load_lsp_keymap(buf)
  local lsp_map = {
    --[[ ["n|<leader>li"] = map_cr("LspInfo")
        :with_silent()
        :with_buffer(buf)
        :with_desc("lsp: Info"),
    ["n|<leader>lr"] = map_cr("LspRestart")
        :with_silent()
        :with_buffer(buf)
        :with_nowait()
        :with_desc("lsp: Restart"), ]]
    ["n|go"] = map_cr("AerialToggle!")
        :with_silent()
        :with_buffer(buf)
        :with_desc("lsp: Toggle outline"),
    ["n|gto"] = map_callback(function()
          require("telescope").extensions.aerial.aerial()
        end)
        :with_silent()
        :with_buffer(buf)
        :with_desc("lsp: Toggle outline in Telescope"),
    ["n|[g"] = map_cr("Lspsaga diagnostic_jump_prev")
        :with_silent()
        :with_buffer(buf)
        :with_desc("lsp: Prev diagnostic"),
    ["n|]g"] = map_cr("Lspsaga diagnostic_jump_next")
        :with_silent()
        :with_buffer(buf)
        :with_desc("lsp: Next diagnostic"),
    ["n|<leader>ld"] = map_cr("Lspsaga show_line_diagnostics ++unfocus")
        :with_silent()
        :with_buffer(buf)
        :with_desc("lsp: Line diagnostic"),
    ["n|gs"] = map_callback(function()
          vim.lsp.buf.signature_help()
        end)
        :with_desc("lsp: Signature help"),
    ["n|gr"] = map_cr("Lspsaga rename")
        :with_silent()
        :with_buffer(buf)
        :with_desc("lsp: Rename in file range"),
    ["n|gR"] = map_cr("Lspsaga rename ++project")
        :with_silent()
        :with_buffer(buf)
        :with_desc("lsp: Rename in project range"),
    ["n|K"] = map_cr("Lspsaga hover_doc")
        :with_silent()
        :with_buffer(buf)
        :with_desc("lsp: Show doc"),
    ["nv|ga"] = map_cr("Lspsaga code_action")
        :with_silent()
        :with_buffer(buf)
        :with_desc("lsp: Code action for cursor"),
    ["n|gd"] = map_cr("Glance definitions")
        :with_silent()
        :with_buffer(buf)
        :with_desc("lsp: Preview definition"),
    ["n|gD"] = map_cr("Lspsaga goto_definition")
        :with_silent()
        :with_buffer(buf)
        :with_desc("lsp: Goto definition"),
    -- ["n|gi"] = map_callback(function()
    --       vim.lsp.buf.implementation()
    --     end)
    --     :with_silent()
    --     :with_desc("lsp: Goto implementation"),
    ["n|gi"] = map_cr("Glance implementations")
        :with_silent()
        :with_buffer(buf)
        :with_desc("lsp: Goto implementation"),
    ["n|gh"] = map_cr("Glance references")
        :with_silent()
        :with_buffer(buf)
        :with_desc("lsp: Show reference"),
    ["n|<leader>ci"] = map_cr("Lspsaga incoming_calls")
        :with_silent()
        :with_buffer(buf)
        :with_desc("lsp: Show incoming calls"),
    ["n|<leader>co"] = map_cr("Lspsaga outgoing_calls")
        :with_silent()
        :with_buffer(buf)
        :with_desc("lsp: Show outgoing calls"),
    ["n|<leader>tt"] = map_callback(function()
          if (Diagnostic_show) then
            Diagnostic_show = false
            return vim.diagnostic.hide()
          else
            Diagnostic_show = true
            return vim.diagnostic.enable()
          end
        end)
        :with_silent()
        :with_desc("lsp: Toggle diagnostic"),
    ["nv|<A-f>"] = map_callback(function()
          lsp_formatting()
        end)
        :with_silent()
        :with_buffer(buf)
        :with_desc("lsp: Format file or range"),
  }
  bind.nvim_load_mapping(lsp_map)
end

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lspkeymaploader", { clear = true }),
  callback = function(event)
    load_lsp_keymap(event.buf)
  end,
})
