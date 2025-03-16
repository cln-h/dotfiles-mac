local augroup = vim.api.nvim_create_augroup -- create autocommand group
local autocmd = vim.api.nvim_create_autocmd -- create autocommand

-- Relative line numbers in normal mode, otherwise set number
autocmd("BufEnter", {
  pattern = "*",
  command = "setlocal number",
})
autocmd("WinEnter", {
  pattern = "*",
  callback = function()
      if vim.api.nvim_win_get_option(0, "number") then
          vim.api.nvim_win_set_option(0, "relativenumber", true)
      end
  end
})

-- Highlight on yank
autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 1000 })
  end
})

-- Remove whitespace on save
autocmd("BufWritePre", {
  pattern = "",
  command = ":%s/\\s\\+$//e"
})

-- Disable new line auto comment
autocmd("BufEnter", {
  pattern = "",
  command = "set fo-=c fo-=r fo-=o"
})

-- Spell checking and text wrap for markdown/text files
autocmd("Filetype", {
  pattern = {"gitcommit", "markdown", "text"},
  callback = function()
      vim.opt_local.wrap = true
      vim.opt_local.spell = true
  end
})
