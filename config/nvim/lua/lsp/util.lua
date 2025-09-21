local lsp_util = require('lspconfig.util')

local M = {}

local deno_root = lsp_util.root_pattern('deno.json', 'deno.jsonc', 'deno.lock', 'import_map.json')
local node_root = lsp_util.root_pattern(
  'package.json',
  'tsconfig.json',
  'jsconfig.json',
  'pnpm-workspace.yaml',
  'yarn.lock',
  'package-lock.json'
)
local eslint_root = lsp_util.root_pattern(
  '.eslintrc.js',
  '.eslintrc.cjs',
  '.eslintrc.json',
  '.eslintrc.yaml',
  '.eslintrc.yml',
  '.eslintrc',
  'package.json'
)

local function buffer_path(bufnr)
  local name = vim.api.nvim_buf_get_name(bufnr)
  if name == '' then
    return nil
  end
  return name
end

function M.find_deno_root(bufnr)
  local path = buffer_path(bufnr)
  if not path then
    return nil
  end
  return deno_root(path)
end

function M.find_node_root(bufnr)
  local path = buffer_path(bufnr)
  if not path then
    return nil
  end
  return node_root(path)
end

function M.find_eslint_root(bufnr)
  local path = buffer_path(bufnr)
  if not path then
    return nil
  end
  return eslint_root(path)
end

function M.is_deno_project(bufnr)
  return M.find_deno_root(bufnr) ~= nil
end

return M
