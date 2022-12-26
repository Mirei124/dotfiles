-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- automatically run :PackerCompile whenever plugins.lua is updated
vim.cmd([[
  augroup packer_user_config
  autocmd!
  autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

-- Bootstrapping
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ 'git', 'clone', '--depth', '1', 'https://ghproxy.com/https://github.com/wbthomason/packer.nvim',
      install_path })
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup({ function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
  --------------------------------------------------------------------------------
  use "EdenEast/nightfox.nvim" -- theme
  use 'kyazdani42/nvim-web-devicons' -- icons

  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true },
  } -- status line

  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.0',
    -- or                            , branch = '0.1.x',
    requires = { { 'nvim-lua/plenary.nvim' } }
  } -- Find, Filter, Preview, Pick (pacman -S fd ripgrep)

  use "folke/neodev.nvim" -- neovim docs, etc.

  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  } -- syntax highlight

  use "folke/which-key.nvim" -- keybindings

  use {
    'akinsho/bufferline.nvim',
    tag = "v3.*",
    requires = 'kyazdani42/nvim-web-devicons'
  } -- bufferline

  -- use {
  --   'nvim-tree/nvim-tree.lua',
  --   requires = {
  --     'nvim-tree/nvim-web-devicons', -- optional, for file icons
  --   },
  --   -- tag = 'nightly' -- optional, updated every week. (see issue #1193)
  -- } -- file explorer

  use {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x",
    requires = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
    },
    config = function()
      vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])
    end
  } -- file explorer

  -- lsp
  use {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
  }

  -- use {
  --   "ray-x/lsp_signature.nvim",
  --   disable = true,
  --   config = function()
  --     require('lsp_signature').setup {}
  --   end
  -- }

  -- use {
  --   "folke/trouble.nvim",
  --   requires = "kyazdani42/nvim-web-devicons",
  --   disable = true,
  --   config = function()
  --     require("trouble").setup {}
  --   end
  -- }

  use {
    "jose-elias-alvarez/null-ls.nvim",
    requires = { "nvim-lua/plenary.nvim" },
  } -- inject LSP diagnostics, code actions, and more

  use 'numToStr/Comment.nvim' -- comment
  use "b0o/schemastore.nvim" -- json schemas
  -- setting the commentstring option based on the cursor location in the file
  use 'JoosepAlviste/nvim-ts-context-commentstring'

  use "windwp/nvim-autopairs"

  --auto complete
  use { 'hrsh7th/nvim-cmp' }
  use { 'hrsh7th/cmp-buffer' }
  use { 'hrsh7th/cmp-path' }
  use { 'hrsh7th/cmp-cmdline' }
  use { 'hrsh7th/cmp-nvim-lsp' }
  use { 'hrsh7th/cmp-nvim-lsp-signature-help' }

  use { "L3MON4D3/LuaSnip", tag = "v<CurrentMajor>.*" } -- Snippet Engine
  use { 'saadparwaiz1/cmp_luasnip' } -- luasnip completion source for nvim-cmp

  use "rafamadriz/friendly-snippets"

  use { 'nvim-lua/plenary.nvim' } -- required by popup
  use { 'nvim-lua/popup.nvim' } -- Popup API

  use {
    'nvim-telescope/telescope-fzf-native.nvim',
    run = 'make',
    config = function()
      require('telescope').load_extension('fzf')
    end
  } -- FZF sorter for telescope written in c

  use {
    "lukas-reineke/indent-blankline.nvim",
  } -- indent line

  use 'gcmt/wildfire.vim'

  use { 'norcalli/nvim-colorizer.lua',
    config = function()
      require('colorizer').setup()
    end
  } -- css color display

  use { 'simrat39/symbols-outline.nvim',
    config = function()
      require('symbols-outline').setup()
    end
  }

  use {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup()
    end
  }

  use {
    'lambdalisue/suda.vim',
    config = function()
      vim.cmd("let g:suda_smart_edit = 0")
    end
  }
  --------------------------------------------------------------------------------
  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end,
  config = {
    -- floating window
    display = {
      open_fn = function()
        return require('packer.util').float({ border = 'single' })
        -- return require('packer.util').float({ border = 'rounded' })
      end
    },
    -- profile the time taken loading your plugins
    profile = {
      enable = true,
      threshold = 0
    }
  } })
