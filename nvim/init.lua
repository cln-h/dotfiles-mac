vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wrap = false
vim.opt.mouse = "a"
vim.opt.showmode = false
vim.opt.clipboard = "unnamedplus"
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true
-- vim.opt.inccommand = "split"
vim.opt.cursorline = true
vim.opt.scrolloff = 10
-- vim.opt.hlsearch = true
-- vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

-- status line options
vim.opt.laststatus = 3        -- global statusline
vim.opt.statusline =
    "%#Substitute# %Y %0*" .. -- filetype
    " %f " ..                 -- path to file
    "%m" ..                   -- modifed
    "%r" ..                   -- readonly
    "%=" ..                   -- separator
    " %{&fileencoding} " ..   -- file encoding
    "|" ..                    -- padding
    " %{&fileformat} " ..     -- file format
    "|" ..                    -- padding
    " %c:%l/%L "              -- column at line per total lines

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- Libraries
  {
    "https://github.com/nvim-lua/plenary.nvim",
    lazy = true,
  },

  -- UI
  {
    "rose-pine/neovim",
    name = "rose-pine",
    config = function()
      require("rose-pine").setup({
        variant = "main",
        dark_variant = "main",
        dim_inactive_windows = true,
        extend_background_behind_borders = true,
        enable = {
          terminal = true,
        },
        styles = {
          bold = true,
          italic = true,
          transparency = false,
        },
        groups = {
          border = "muted",
          link = "iris",
          panel = "surface",

          error = "love",
          hint = "iris",
          info = "foam",
          note = "pine",
          todo = "rose",
          warn = "gold",

          git_add = "foam",
          git_change = "rose",
          git_delete = "love",
          git_dirty = "rose",
          git_ignore = "muted",
          git_merge = "iris",
          git_rename = "pine",
          git_stage = "iris",
          git_text = "rose",
          git_untracked = "subtle",

          h1 = "iris",
          h2 = "foam",
          h3 = "rose",
          h4 = "gold",
          h5 = "pine",
          h6 = "foam",
        },
      })
    end,
  },
  {
    "https://github.com/lukas-reineke/indent-blankline.nvim",
    event = "VeryLazy",
    config = function()
      require("ibl").setup({
        indent = {
          char = "▏",
          tab_char = "→",
        },
        scope = {
          enabled = false,
        },
      })
    end,
  },
  {
    "MunifTanjim/nui.nvim",
    lazy = true,
  },
  { -- TODO: Play with notify. Will be a dep here.
    "folke/noice.nvim",
    event = "VeryLazy",
    config = function()
      require("noice").setup({})
    end,
    dependencies = {
      "MunifTanjim/nui.nvim",
    }
  },
  { 'echasnovski/mini.icons', version = '*' },
  {
    "goolord/alpha-nvim",
    dependencies = { 'echasnovski/mini.icons' },
    -- dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      local startify = require("alpha.themes.startify")
      -- available: devicons, mini, default is mini
      -- if provider not loaded and enabled is true, it will try to use another provider
      -- startify.file_icons.provider = "devicons"
      startify.file_icons.provider = "mini"
      require("alpha").setup(
        startify.config
      )
    end,
  },

  -- Search
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { 'nvim-lua/plenary.nvim' }
  },
  {
    "https://github.com/MagicDuck/grug-far.nvim",
    lazy = true,
    config = function()
      require("grug-far").setup({})
    end,
  },

  -- File Manager
  {
    "https://github.com/stevearc/oil.nvim",
    cmd = "Oil",
    config = function()
      local oil = require("oil")
      oil.setup({
        columns = {},
        view_options = {
          show_hidden = true,
          is_always_hidden = function(name, bufnr)
            return name == ".."
          end,
        },
        win_options = {
          concealcursor = "nvic",
        },
      })
    end,
  },
  {
    "https://github.com/ThePrimeagen/harpoon",
    branch = "harpoon2",
    event = "VeryLazy",
    config = function()
      local harpoon = require("harpoon")
      local extensions = require("harpoon.extensions")
      harpoon:setup()
      harpoon:extend(extensions.builtins.navigate_with_number())
    end,
  },

  -- Intellisense + Syntax
  {
    "https://github.com/Saghen/blink.cmp",
    version = "v0.*",
    event = "VeryLazy",
    config = function()
      require("blink.cmp").setup({
        keymap = {
          preset = "enter",
        },
        cmdline = {
          keymap = {
            preset = "super-tab",
          },
        },
      })
    end,
  },
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup({})
    end,
  },
  {
    'williamboman/mason-lspconfig.nvim',
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "vimls", "biome", "ts_ls" },
      })
    end
  },
  {
    "https://github.com/neovim/nvim-lspconfig",
    event = "VeryLazy",
    config = function()
      local servers = {
        gopls = {},
        lua_ls = {},
        pyright = {},
        rust_analyzer = {},
        ts_ls = {},
        biome = {},
      }

      local lspconfig = require("lspconfig")
      for server, config in pairs(servers) do
        config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
        lspconfig[server].setup(config)
      end

      -- HACK manually start LSP server after lazy load
      vim.cmd("filetype detect")
    end,
  },
  {
    "https://github.com/nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = "VeryLazy",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "cue",
          "go",
          "hcl",
          "nix",
          "puppet",
          "python",
          "rust",
          "terraform",
          "tsx",
          "typescript",
          "vimdoc",
        },
        highlight = {
          enable = true,
        },
        indent = {
          enable = true,
        },
      })
    end,
  },
  {
    "https://github.com/windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup()
    end,
  },
  {
    -- TODO: trouble.nvim
  },


  -- Git
  { -- TODO: Consider switching to neogit + diffview
    "https://github.com/tpope/vim-fugitive",
    cmd = "Git",
  },
  {
    "https://github.com/echasnovski/mini.diff",
    event = "VeryLazy",
    config = function()
      require("mini.diff").setup({})
    end,
  },
  {
    "f-person/git-blame.nvim",
    event = "VeryLazy",
    opts = {
      enabled = false,
    },
  },

  -- Motions
  {
    "https://github.com/folke/flash.nvim",
    event = "VeryLazy",
    config = function()
      require("flash").setup({
        modes = {
          search = {
            enabled = true,
          },
          char = {
            enabled = false,
          },
        },
        highlight = {
          groups = {
            label = "Question",
          },
        },
      })
    end,
  },
  {
    "https://github.com/echasnovski/mini.surround",
    event = "VeryLazy",
    config = function()
      require("mini.surround").setup({})
    end,
  },

  -- Copilot
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = {
          enabled = true,
          auto_trigger = "true",
          keymap = {
            accept = "<C-F>",
            close = "<Esc>",
            next = "<C-J>",
            prev = "<C-K>",
            select = "<C-R>",
            dismiss = "<C-X>",
          },
        },
        panel = {
          enabled = false,
        }
      })
    end,
  },
  -- { -- TODO: Use the blink.compat compatibility layer to use this plugin
  --   "zbirenbaum/copilot-cmp",
  --   config = function ()
  --     require("copilot_cmp").setup()
  --   end
  -- },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    config = function()
      require("CopilotChat").setup({})
    end,
    dependencies = {
      { "zbirenbaum/copilot.lua" },
      { "nvim-lua/plenary.nvim" }, -- for curl, log and async functions
    },
  },

  -- Notes
  -- {
  --   "epwalsh/obsidian.nvim",
  --   version = "*",  -- recommended, use latest release instead of latest commit
  --   lazy = true,
  --   ft = "markdown",
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --   },
  --   -- Example configuration
  --   -- opts = {
  --   --   workspaces = {
  --   --     {
  --   --       name = "personal",
  --   --       path = "~/vaults/personal",
  --   --     },
  --   --     {
  --   --       name = "work",
  --   --       path = "~/vaults/work",
  --   --     },
  --   --   },
  --   -- },
  --   opts = {
  --     workspaces = require("obsidian-vaults") or {},
  --   }
  -- },


  -- Misc
  {
    "https://github.com/farmergreg/vim-lastplace",
    event = "BufReadPost",
  },
  {
    "https://github.com/tpope/vim-sleuth",
    event = "VeryLazy",
    config = function()
      vim.cmd("silent Sleuth")
    end,
  },
  {
    "https://github.com/romainl/vim-cool",
    event = "VeryLazy",
  },
  {
    "https://github.com/numToStr/Comment.nvim",
    event = "VeryLazy",
    config = function()
      require("Comment").setup()
    end,
  },
  {
    "https://github.com/echasnovski/mini.bufremove",
    lazy = true,
  },

  -- Keymaps
  {
    "https://github.com/folke/which-key.nvim",
    event = "VeryLazy",
    keys = require("keymaps"),
  },
})

vim.diagnostic.config({
  virtual_lines = true,
  underline = true
})

vim.cmd("colorscheme rose-pine")

require('autocmds')
