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

-- Format on save
autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then return end

    if client.supports_method('textDocument/formatting') then
      -- format the current buffer on save
      vim.api.nvim_create_autocmd('BufWritePre', {
        buffer = args.buf,
        callback = function()
          vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
        end,
      })
    end
  end,
})
