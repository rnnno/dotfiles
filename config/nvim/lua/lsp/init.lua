local M = {}

local files = vim.api.nvim_get_runtime_file('lua/lsp/*.lua', true)

for _, file in ipairs(files) do
  local name = vim.fn.fnamemodify(file, ':t:r')
  if name ~= 'init' and name ~= 'util' then
    local ok, config = pcall(require, 'lsp.' .. name)
    if ok and config then
      M[name] = config
    else
      vim.notify(('LSP config %s failed to load: %s'):format(name, config), vim.log.levels.WARN)
    end
  end
end

return M
