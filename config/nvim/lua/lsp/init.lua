local M = {
  servers = {},
  capabilities = nil,
}

local files = vim.api.nvim_get_runtime_file('lua/lsp/*.lua', true)

for _, file in ipairs(files) do
  local name = vim.fn.fnamemodify(file, ':t:r')
  if name ~= 'init' and name ~= 'util' then
    local ok, config = pcall(require, 'lsp.' .. name)
    if ok and config then
      M.servers[name] = config
    else
      vim.notify(('LSP config %s failed to load: %s'):format(name, config), vim.log.levels.WARN)
    end
  end
end

local initialized = false

function M.setup_common()
  if initialized then
    return M.capabilities
  end

  vim.diagnostic.config({
    virtual_text = false,
    virtual_lines = { current_line = true },
    float = { border = 'single' },
    severity_sort = true,
  })

  local capabilities = vim.lsp.protocol.make_client_capabilities()
  local completion_item = capabilities.textDocument.completion.completionItem
  completion_item.snippetSupport = true
  completion_item.preselectSupport = true
  completion_item.insertReplaceSupport = true
  completion_item.labelDetailsSupport = true
  completion_item.deprecatedSupport = true
  completion_item.commitCharactersSupport = true
  completion_item.tagSupport = { valueSet = { 1 } }
  completion_item.resolveSupport = {
    properties = {
      'documentation',
      'detail',
      'additionalTextEdits',
    },
  }

  capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
  }

  vim.lsp.config('*', {
    capabilities = capabilities,
  })

  M.capabilities = capabilities
  initialized = true

  return capabilities
end

setmetatable(M, {
  __index = function(_, key)
    return M.servers[key]
  end,
  __pairs = function()
    return pairs(M.servers)
  end,
})

return M
