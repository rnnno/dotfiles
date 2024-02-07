return {
  'goolord/alpha-nvim',
  lazy = true,
  event = 'VimEnter',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    local alpha = require('alpha')
    local dashboard = require('alpha.themes.dashboard')

    dashboard.section.header.val = {
      " ⠀⠀⠀⠀⠀⠀⠀⠀⣠⣾⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣷⣄⠀⠀⠀⠀⠀⠀⠀⠀ ",
      " ⠀⠀⠀⠀⠀⠀⣠⣾⣿⣿⣿⣧⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣷⣄⠀⠀⠀⠀⠀⠀ ",
      " ⠀⠀⠀⠀⢠⣾⣿⣿⣿⣿⣿⣿⣷⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣷⣄⠀⠀⠀⠀ ",
      " ⠀⠀⣠⢦⡈⢻⣿⣿⣿⣿⣿⣿⣿⣿⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣷⡄⠀⠀ ",
      " ⠀⠀⣿⠀⠳⡄⠹⣿⣿⣿⣿⣿⣿⣿⣿⣦⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀ ",
      " ⠀⠀⣿⠀⠀⠙⣆⠘⢿⣿⣿⣿⣿⣿⣿⣿⣷⡀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀ ",
      " ⠀⠀⣿⠀⠀⠀⠈⢧⡈⢿⣿⣿⣿⣿⣿⣿⣿⣿⣄⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀ ",
      " ⠀⠀⣿⠀⠀⠀⠀⠀⠳⡄⠻⣿⣿⣿⣿⣿⣿⣿⣿⣦⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀ ",
      " ⠀⠀⣿⠀⠀⠀⠀⠀⠀⣿⠀⠙⣿⣿⣿⣿⣿⣿⣿⣿⣷⡀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀ ",
      " ⠀⠀⣿⠀⠀⠀⠀⠀⠀⣿⠀⠀⠈⢿⣿⣿⣿⣿⣿⣿⣿⣿⣄⠀⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀ ",
      " ⠀⠀⣿⠀⠀⠀⠀⠀⠀⣿⠀⠀⠀⠀⠻⣿⣿⣿⣿⣿⣿⣿⣿⣦⠙⣿⣿⣿⣿⣿⣿⣿⠀⠀ ",
      " ⠀⠀⣿⠀⠀⠀⠀⠀⠀⣿⠀⠀⠀⠀⠀⠙⣿⣿⣿⣿⣿⣿⣿⣿⣧⡈⢿⣿⣿⣿⣿⣿⠀⠀ ",
      " ⠀⠀⣿⠀⠀⠀⠀⠀⠀⣿⠀⠀⠀⠀⠀⠀⠈⢿⣿⣿⣿⣿⣿⣿⣿⣷⡄⠻⣿⣿⣿⣿⠀⠀ ",
      " ⠀⠀⣿⠀⠀⠀⠀⠀⠀⣿⠀⠀⠀⠀⠀⠀⠀⠀⠻⣿⣿⣿⣿⣿⣿⣿⣿⣆⠙⣿⣿⣿⠀⠀ ",
      " ⠀⠀⠙⢦⡀⠀⠀⠀⠀⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⣿⣿⣿⣿⣿⣿⣿⣿⣧⡈⠿⠋⠀⠀ ",
      " ⠀⠀⠀⠀⠙⢦⡀⠀⠀⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⢿⣿⣿⣿⣿⣿⣿⡿⠃⠀⠀⠀⠀ ",
      " ⠀⠀⠀⠀⠀⠀⠙⢦⡀⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢻⣿⣿⣿⡿⠋⠀⠀⠀⠀⠀⠀ ",
      " ⠀⠀⠀⠀⠀⠀⠀⠀⠙⠿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⡿⠋⠀⠀⠀⠀⠀⠀⠀⠀ ",
    }
    dashboard.section.header.opts.hl = "String"

    dashboard.section.buttons.val = {
      dashboard.button("n", "  NvimTree", ":NvimTreeToggle<CR>"),
      dashboard.button("u", "󰊳  Update", ":Lazy sync<CR>"),
      -- TODO:Telescope入れるか検討する 
      -- dashboard.button("r", "  Recent file", ":Telescope oldfiles <CR>"),
      -- dashboard.button("f", "󰥨  Find file", ":Telescope find_files <CR>"),
      -- dashboard.button("g", "󰱼  Find text", ":Telescope live_grep <CR>"),
      dashboard.button("c", "  Config", ":e $MYVIMRC | :cd %:p:h | :silent !pwd <CR>"),
      dashboard.button("q", "  Quit", ":qa<CR>"),
    }


    local function footer()
      local stats = require('lazy').stats()
      local plugins = stats.count

      local version = vim.version()
      local version_info = "   version" .. version.major .. "." .. version.minor .. "." .. version.patch

      return "⚡plugins " .. plugins .. version_info
    end

    dashboard.section.footer.val = footer()

    alpha.setup(dashboard.opts)
  end

}
