local install_plugins = {
  --- ui ---------------------------------------------------
  {
    "EdenEast/nightfox.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd("colorscheme " .. My_theme)
    end,
  },
  {
    "akinsho/bufferline.nvim",
    lazy = true,
    event = { "BufReadPost", "BufAdd", "BufNewFile" },
    config = require("configs.ui.bufferline"),
  },
  {
    "nvim-lualine/lualine.nvim",
    lazy = true,
    event = { "BufReadPost", "BufAdd", "BufNewFile" },
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = require("configs.ui.lualine"),
  },
  {
    "j-hui/fidget.nvim",
    lazy = true,
    event = "LspAttach",
    config = require("configs.ui.fidget"),
  },
  {
    "rcarriga/nvim-notify",
    lazy = true,
    event = "VeryLazy",
    config = require("configs.ui.nvim-notify"),
  },
  {
    "folke/paint.nvim",
    lazy = true,
    event = { "CursorHold", "CursorHoldI" },
    config = require("configs.ui.paint"),
  },
  {
    "lewis6991/gitsigns.nvim",
    lazy = true,
    event = { "CursorHold", "CursorHoldI" },
    config = require("configs.ui.gitsigns"),
  },
  --- lsp plug ---------------------------------------------
  {
    "neovim/nvim-lspconfig",
    lazy = true,
    event = { "CursorHold", "CursorHoldI" },
    config = require("configs.lsp_configs.lsp"),
    dependencies = {
      { "williamboman/mason.nvim" },
      { "williamboman/mason-lspconfig.nvim" },
      {
        -- "Jint-lzxy/lsp_signature.nvim",
        "ray-x/lsp_signature.nvim",
        config = function()
          require("lsp_signature").setup({
            floating_window = false,
          })
        end,
      },
    }
  },
  {
    "nvimdev/lspsaga.nvim",
    lazy = true,
    event = { "LspAttach" },
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons'
    },
    config = require("configs.lsp_configs.lspsaga"),
  },
  {
    "nvimtools/none-ls.nvim",
    lazy = true,
    event = { "CursorHold", "CursorHoldI" },
    config = require("configs.lsp_configs.null-ls"),
    dependencies = {
      "nvim-lua/plenary.nvim",
      "jay-babu/mason-null-ls.nvim",
    },
  },
  --- completion -------------------------------------------
  {
    "hrsh7th/nvim-cmp",
    lazy = true,
    event = "InsertEnter",
    config = require("configs.completion.nvim-cmp"),
    dependencies = {
      {
        "L3MON4D3/LuaSnip",
        dependencies = { "rafamadriz/friendly-snippets" },
        config = require("configs.completion.LuaSnip"),
      },
      { "lukas-reineke/cmp-under-comparator" },
      { "saadparwaiz1/cmp_luasnip" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-nvim-lua" },
      -- { "andersevenrud/cmp-tmux" },
      { "hrsh7th/cmp-path" },
      -- { "hrsh7th/cmp-cmdline" },
      { "f3fora/cmp-spell" },
      { "hrsh7th/cmp-buffer" },
      { "kdheepak/cmp-latex-symbols" },
      -- { "ray-x/cmp-treesitter",              commit = "c8e3a74" },
    }
  },
  --- syntax highlight -------------------------------------
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = true,
    build = function()
      if #vim.api.nvim_list_uis() ~= 0 then
        vim.api.nvim_command([[TSUpdate]])
      end
    end,
    event = "BufReadPre",
    config = require("configs.syntax_highlight.nvim-treesitter"),
    dependencies = {
      { "andymass/vim-matchup" },
      { "nvim-treesitter/nvim-treesitter-textobjects" },
      {
        "windwp/nvim-ts-autotag",
        config = function()
          require("nvim-ts-autotag").setup()
        end,
      },
      {
        "NvChad/nvim-colorizer.lua",
        config = require("configs.syntax_highlight.nvim-colorizer"),
      },
      {
        "hiphish/rainbow-delimiters.nvim",
        config = require("configs.syntax_highlight.rainbow-delimiters"),
      },
      {
        "JoosepAlviste/nvim-ts-context-commentstring",
        config = require("configs.syntax_highlight.nvim-ts-context-commentstring"),
      },
    },
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    lazy = true,
    event = { "CursorHold", "CursorHoldI" },
    config = require("configs.syntax_highlight.indent-blankline"),
  },
  --- tools ------------------------------------------------
  {
    "LunarVim/bigfile.nvim",
    lazy = false,
    priority = 999,
    config = require("configs.tools.bigfile"),
  },
  {
    "gcmt/wildfire.vim",
    lazy = true,
    event = { "CursorHold" },
  },
  {
    "m4xshen/autoclose.nvim",
    lazy = true,
    event = "InsertEnter",
    config = require("configs.tools.autoclose"),
  },
  {
    "ojroques/nvim-bufdel",
    lazy = true,
    cmd = { "BufDel", "BufDelAll", "BufDelOthers" },
  },
  {
    "numToStr/Comment.nvim",
    lazy = true,
    event = { "CursorHold", "CursorHoldI" },
    config = false,
  },
  {
    "lambdalisue/suda.vim",
    lazy = true,
    cmd = { "SudaRead", "SudaWrite" },
  },
  {
    "folke/which-key.nvim",
    lazy = true,
    event = { "CursorHold", "CursorHoldI" },
    config = require("configs.tools.which-key"),
  },
  {
    "nvim-tree/nvim-tree.lua",
    lazy = true,
    cmd = {
      "NvimTreeToggle",
      "NvimTreeOpen",
      "NvimTreeFindFile",
      "NvimTreeFindFileToggle",
      "NvimTreeRefresh",
    },
    config = require("configs.tools.nvim-tree"),
  },
  {
    "folke/trouble.nvim",
    lazy = true,
    cmd = { "Trouble", "TroubleToggle", "TroubleRefresh" },
    config = require("configs.tools.trouble"),
  },
  {
    "nvim-telescope/telescope.nvim",
    lazy = true,
    cmd = "Telescope",
    config = require("configs.tools.telescope"),
    dependencies = {
      { "nvim-tree/nvim-web-devicons" },
      { "nvim-lua/plenary.nvim" },
      { "debugloop/telescope-undo.nvim" },
      { "nvim-telescope/telescope-frecency.nvim" },
      { "nvim-telescope/telescope-fzf-native.nvim",    build = "make" },
      { "nvim-telescope/telescope-live-grep-args.nvim" },
    },
  },
  {
    "stevearc/aerial.nvim",
    lazy = true,
    event = "LspAttach",
    config = require("configs.tools.aerial"),
  },
  {
    "dnlhc/glance.nvim",
    lazy = true,
    event = "LspAttach",
    config = require("configs.tools.glance"),
  },
  {
    "echasnovski/mini.nvim",
    lazy = true,
    event = "CursorHold",
    version = "*",
    config = require("configs.tools.mini-align"),
  },
  --- lang -------------------------------------------------
  {
    "folke/neodev.nvim",
    lazy = true,
    -- event = "VeryLazy",
    ft = "lua",
    opts = {},
  },
  {
    "b0o/schemastore.nvim",
    lazy = true,
    event = "VeryLazy",
  },
  {
    "iamcco/markdown-preview.nvim",
    lazy = true,
    ft = "markdown",
    build = ":call mkdp#util#install()",
  }
}

local lazy_opts = {
  ui = { border = "single" },
  -- automatically check for plugin updates
  checker = {
    enabled = false,
    concurrency = 3,
    notify = true,
    frequency = 86400 * 7,
    check_pinned = false
  }
}

require("lazy").setup(install_plugins, lazy_opts)
