local util = require('lsp.util')

return {
  root_dir = function(bufnr, on_dir)
    local root = util.find_deno_root(bufnr)
    if root then
      on_dir(root)
    end
  end,
  single_file_support = false,
  init_options = {
    lint = true,
    unstable = true,
    suggest = {
      imports = {
        hosts = {
          ['https://deno.land'] = true,
          ['https://cdn.nest.land'] = true,
          ['https://crux.land'] = true,
        },
      },
    },
  },
}
