local autocmd = vim.api.nvim_create_autocmd

-- Relative line numbers in normal mode, otherwise set number
autocmd("BufEnter", {
  pattern = "*",
  command = "setlocal number",
})
autocmd("InsertLeave", {
  pattern = "*",
  callback = function()
    if vim.api.nvim_win_get_option(0, "number") then
      vim.api.nvim_win_set_option(0, "relativenumber", true)
    end
  end
})
autocmd("InsertEnter", {
  pattern = "*",
  callback = function()
    if vim.api.nvim_win_get_option(0, "number") then
      vim.api.nvim_win_set_option(0, "relativenumber", false)
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

-- Disable line numbers within copilot chat buffer
autocmd("BufEnter", {
  pattern = {"copilot-chat"},
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
  end
})

