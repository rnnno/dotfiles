local util = require('lsp.util')

return {
  root_dir = function(bufnr, on_dir)
    if util.is_deno_project(bufnr) then
      return
    end
    local root = util.find_eslint_root(bufnr)
    if root then
      on_dir(root)
    end
  end,
}
