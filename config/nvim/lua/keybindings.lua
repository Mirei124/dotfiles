-- vim:foldmethod=marker:foldlevel=0:

-- {{{
-- auto fcitx switch
vim.cmd([[
let g:input_toggle = 1
function! Fcitx2en()
   let s:input_status = system("fcitx5-remote")
   if s:input_status == 2
      let g:input_toggle = 1
      let l:a = system("fcitx5-remote -c")
   endif
endfunction

function! Fcitx2zh()
   let s:input_status = system("fcitx5-remote")
   if s:input_status != 2 && g:input_toggle == 1
      let l:a = system("fcitx5-remote -o")
      let g:input_toggle = 0
   endif
endfunction

set ttimeoutlen=150
" autocmd InsertLeave * call Fcitx2en()
" autocmd InsertEnter * call Fcitx2zh()
]])
vim.api.nvim_create_autocmd({ 'InsertLeave' }, {
  command = 'call Fcitx2en()'
})

-- zoom
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

-- auto parenthesis completion
--vim.keymap.set('i', '(', '()<left>')
--vim.keymap.set('i', '[', '[]<left>')
--vim.keymap.set('i', '{', '{}<left>')
--vim.keymap.set('i', '\'', '\'\'<left>')
--vim.keymap.set('i', '\"', '\"\"<left>')
-- }}}

local wk = require('which-key')
-- telescope
local builtin = require('telescope.builtin')

wk.register({
  ['<leader>'] = {
    w = { '<cmd>SudaWrite<cr>', 'save file with sudo' },
    z = { '<cmd>call Zoom()<cr>', 'zoom' },
    t = { '<cmd>Neotree<cr>', 'toggle file explorer' },
    o = { '<cmd>SymbolsOutline<cr>', 'toggle outline' },
  },
  ['f'] = {
    -- telescope
    f = { builtin.find_files, 'find_files' },
    g = { builtin.live_grep, 'live_grep' },
    b = { builtin.buffers, 'buffers' },
    h = { builtin.help_tags, 'help_tags' },
    -- fold
    o = { '<cmd>foldopen<cr>', 'open fold' },
    c = { '<cmd>foldclose<cr>', 'close fold' },
  },
  ['<space>v'] = { '<cmd>close<cr>', 'close a buffer' },
  -- ['<space>x'] = { '<cmd>bd<cr>', 'delete a buffer' },
  ['<c-j>'] = { '<c-w><c-j>', 'switch view' },
  ['<c-k>'] = { '<c-w><c-k>', 'switch view' },
  ['<c-h>'] = { '<c-w><c-h>', 'switch view' },
  ['<c-l>'] = { '<c-w><c-l>', 'switch view' },
})

-- Comment
vim.keymap.set('n', '<c-/>', function()
  return vim.v.count == 0
      and '<Plug>(comment_toggle_linewise_current)'
      or '<Plug>(comment_toggle_linewise_count)'
end, { expr = true })

require('Comment').setup({
  ---Add a space b/w comment and the line
  padding = true,
  ignore = '^$',
  ---LHS of toggle mappings in NORMAL mode
  toggler = {
    ---Line-comment toggle keymap
    line = '<space>c',
    ---Block-comment toggle keymap
    block = '<space>b',
  },
  ---LHS of operator-pending mappings in NORMAL and VISUAL mode
  opleader = {
    ---Line-comment keymap
    line = '<space>c',
    ---Block-comment keymap
    block = '<space>b',
  },
  ---LHS of extra mappings
  extra = {
    ---Add comment on the line above
    above = 'gcO',
    ---Add comment on the line below
    below = 'gco',
    ---Add comment at the end of line
    eol = 'gcA',
  },
})

-- lspconfig
-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)
Diagnostic_show = true
vim.keymap.set('n', '<space>d', function()
  if (Diagnostic_show) then
    Diagnostic_show = false
    return vim.diagnostic.hide()
  else
    Diagnostic_show = true
    return vim.diagnostic.enable()
  end
end, opts)

-- trouble
-- vim.keymap.set('n', '<space>d', '<cmd>TroubleToggle<cr>')
-- vim.keymap.set('n', '<space>q', '<cmd>TroubleToggle quickfix<cr>')

-- See `:help vim.lsp.*` for documentation on any of the below functions
local bufopts = { noremap = true, silent = true }
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
vim.keymap.set('n', '<space>wl', function()
  print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
end, bufopts)
vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
vim.keymap.set('n', '<space>a', vim.lsp.buf.code_action, bufopts)
vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)

-- gitsigns
require('gitsigns').setup {
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts_)
      opts_ = opts_ or {}
      opts_.buffer = bufnr
      vim.keymap.set(mode, l, r, opts_)
    end

    -- Navigation
    map('n', ']c', function()
      if vim.wo.diff then return ']c' end
      vim.schedule(function() gs.next_hunk() end)
      return '<Ignore>'
    end, { expr = true })

    map('n', '[c', function()
      if vim.wo.diff then return '[c' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end, { expr = true })

    -- Actions
    map({ 'n', 'v' }, '<leader>hs', ':Gitsigns stage_hunk<CR>')
    map({ 'n', 'v' }, '<leader>hr', ':Gitsigns reset_hunk<CR>')
    map('n', '<leader>hS', gs.stage_buffer)
    map('n', '<leader>hu', gs.undo_stage_hunk)
    map('n', '<leader>hR', gs.reset_buffer)
    map('n', '<leader>hp', gs.preview_hunk)
    map('n', '<leader>hb', function() gs.blame_line { full = true } end)
    map('n', '<leader>tb', gs.toggle_current_line_blame)
    map('n', '<leader>hd', gs.diffthis)
    map('n', '<leader>hD', function() gs.diffthis('~') end)
    map('n', '<leader>td', gs.toggle_deleted)

    -- Text object
    map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
  end
}
