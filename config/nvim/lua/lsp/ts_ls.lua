local util = require('lsp.util')

return {
  root_dir = function(bufnr, on_dir)
    if util.find_deno_root(bufnr) then
      return
    end
    local root = util.find_node_root(bufnr)
    if root then
      on_dir(root)
    end
  end,
  single_file_support = false,
}
