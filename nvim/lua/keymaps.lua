vim.g.mapleader = " "
vim.g.maplocalleader = " "

local nmap = function(lhs, rhs)
  vim.api.nvim_set_keymap('n', lhs, rhs, { noremap = true, silent = true })
end

nmap("<C-d>", "<C-d>zz")
nmap("<C-u>", "<C-u>zz")
nmap("J", "5j")
nmap("K", "5k")

return {
  -- Telescope
  {
    "<Leader>ff",
    function()
      local builtin = require("telescope.builtin")
      builtin.find_files()
    end,
    desc = "Find files",
  },
  {
    "<Leader>fg",
    function()
      local builtin = require("telescope.builtin")
      builtin.live_grep()
    end,
    desc = "Live grep"
  },
  {
    "<Leader>fb",
    function()
      local builtin = require("telescope.builtin")
      builtin.file_browser()
    end,
    desc = "File browser"
  },
  {
    "<Leader>fh",
    function()
      local builtin = require("telescope.builtin")
      builtin.help_tags()
    end,
    desc = "Help tags"
  },
  {
    "<Leader>fk",
    function()
      local builtin = require("telescope.builtin")
      builtin.keymaps()
    end,
    desc = "Keymaps"
  },
  {
    "<Leader>fs",
    function()
      local builtin = require("telescope.builtin")
      builtin.builtin()
    end,
    desc = "Telescope builtin"
  },
  {
    "<Leader>fw",
    function()
      local builtin = require("telescope.builtin")
      builtin.grep_string()
    end,
    desc = "Grep string"
  },
  {
    "<Leader>fd",
    function()
      local builtin = require("telescope.builtin")
      builtin.diagnostics()
    end,
    desc = "Diagnostics"
  },
  {
    "<Leader>fr",
    function()
      local builtin = require("telescope.builtin")
      builtin.resume()
    end,
    desc = "Telescope resume"
  },
  {
    "<Leader>f.",
    function()
      local builtin = require("telescope.builtin")
      builtin.oldfiles()
    end,
    desc = "Recent files"
  },
  {
    "<Leader><Leader>",
    function()
      local builtin = require("telescope.builtin")
      builtin.buffers()
    end,
    desc = "Buffers"
  },
  {
    "<Leader>/",
    function()
      local builtin = require("telescope.builtin")
      builtin.current_buffer_fuzzy_find({
        previewer = false,
        layout_strategy = "vertical",
        layout_config = {
          width = 0.5,
        },
      })
    end,
    desc = "Fuzzy find in buffer"
  },
  {
    "<Leader>f/",
    function()
      local builtin = require("telescope.builtin")
      builtin.live_grep({
        grep_open_files = true,
        prompt_title = "Live Grep in Open Files",
      })
    end,
    desc = "Live grep in buffers"
  },
  {
    "<Leader>fn",
    function()
      local builtin = require("telescope.builtin")
      builtin.find_files({ cwd = vim.fn.stdpath("config")})
    end,
    desc = "Find nvim config file"
  },

  -- Oil
  { "-", "<Cmd>Oil<CR>", desc = "Browse project from here" },
  { "_", "<Cmd>Oil .<CR>", desc = "Browse project" },

  -- Buffer
  {
    "<Leader>bd",
    function()
        require("mini.bufremove").delete(0)
    end,
    desc = "Delete buffer",
  },
  { "<C-Tab>", "<Cmd>bnext<CR>", desc = "Next buffer" },
  { "<C-S-Tab>", "<Cmd>bprevious<CR>", desc = "Previous buffer" },

  -- Git
  { "<Leader>gs", "<Cmd>Git<CR>", desc = "Git status" },
  { "<Leader>gb", "<Cmd>Git blame<CR>", desc = "Git blame" },
  { "<Leader>gl", "<Cmd>Git log<CR>", desc = "Git log" },
  { "<Leader>ghb", "<Cmd>silent !gh browse %<CR>", desc = "GitHub browse" },
  { "<Leader>ghr", "<Cmd>silent !gh repo view --web<CR>", desc = "GitHub repo" },
  {
      "<Leader>gd",
      function()
          require("mini.diff").toggle_overlay()
      end,
      desc = "Git diff overlay",
  },

  -- Yank
  { "<C-c>", '"+y', mode = { "n", "v" } , desc = "Yank to clipboard"},
  { "<Leader>yF", "<Cmd>let @+ = expand('%:p:~')<CR>", desc = "Yank absolute file path to clipboard" },
  { "<Leader>yf", "<Cmd>let @+ = expand('%')<CR>", desc = "Yank relative file path to clipboard" },

   -- LSP
   { "<Leader>h", vim.lsp.buf.hover, desc = "Toggle hover" },
   { "gd", vim.lsp.buf.definition, desc = "Go to definition" },
   { "gD", vim.lsp.buf.declaration, desc = "Go to declaration" },
   { "gi", vim.lsp.buf.implementation, desc = "Go to implementation" },
   { "go", vim.lsp.buf.type_definition, desc = "Go to type definition" },
   { "gR", vim.lsp.buf.references, desc = "Go to references" },
   { "gs", vim.lsp.buf.signature_help, desc = "Show signature" },
   { "gr", vim.lsp.buf.rename, desc = "Rename symbol" },
   { "<Leader>=", mode = {"n", "x" }, vim.lsp.buf.format, desc = "Format buffer" },
   { "<Leader>ca", vim.lsp.buf.code_action, desc = "Code action" },

  -- URL
  {
    "<Leader>url",
    function()
      local Job = require("plenary.job")
      local url = vim.fn.expand("<cWORD>")

      if not url:match('^https?://') then
        print('No valid URL under cursor')
        return
      end

     print('Opening: ' .. url)
     Job:new({
       command = 'open',  -- macOS
       args = { url },
     }):start()
    end,
    desc = "Open URL",
  }
}
