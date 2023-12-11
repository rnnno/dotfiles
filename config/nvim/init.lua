require "plugins"

require "keymaps"
require "setups"
require "commands"


vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { "plugins.lua" },
  command = "PackerCompile",
})
