vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("TrimAndEnsureFinalNewline", { clear = true }),
  callback = function()
    -- 行末の空白を削除
    vim.cmd([[silent! %s/\s\+$//e]])

    -- 末尾に空行がなければ挿入
    local last_line = vim.api.nvim_buf_get_lines(0, -2, -1, false)[1]
    if last_line ~= "" then
      local total_lines = vim.api.nvim_buf_line_count(0)
      vim.api.nvim_buf_set_lines(0, total_lines, total_lines, false, { "" })
    end
  end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("HighlightOnYank", { clear = true }),
  callback = function()
    vim.highlight.on_yank({ higroup = "Visual", timeout = 250 })
  end,
})

local group = vim.api.nvim_create_augroup("DynamicLineNumber", { clear = true })

vim.api.nvim_create_autocmd("InsertEnter", {
  group = group,
  callback = function()
    vim.opt.relativenumber = false
    vim.opt.number = true
  end,
})

vim.api.nvim_create_autocmd("InsertLeave", {
  group = group,
  callback = function()
    vim.opt.relativenumber = true
    vim.opt.number = true
  end,
})

