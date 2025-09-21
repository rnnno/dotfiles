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

    -- dashboard.section.header.val = {
    --   " ⠀⠀⠀⠀⠀⠀⠀⠀⣠⣾⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣷⣄⠀⠀⠀⠀⠀⠀⠀⠀ ",
    --   " ⠀⠀⠀⠀⠀⠀⣠⣾⣿⣿⣿⣧⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣷⣄⠀⠀⠀⠀⠀⠀ ",
    --   " ⠀⠀⠀⠀⢠⣾⣿⣿⣿⣿⣿⣿⣷⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣷⣄⠀⠀⠀⠀ ",
    --   " ⠀⠀⣠⢦⡈⢻⣿⣿⣿⣿⣿⣿⣿⣿⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣷⡄⠀⠀ ",
    --   " ⠀⠀⣿⠀⠳⡄⠹⣿⣿⣿⣿⣿⣿⣿⣿⣦⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀ ",
    --   " ⠀⠀⣿⠀⠀⠙⣆⠘⢿⣿⣿⣿⣿⣿⣿⣿⣷⡀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀ ",
    --   " ⠀⠀⣿⠀⠀⠀⠈⢧⡈⢿⣿⣿⣿⣿⣿⣿⣿⣿⣄⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀ ",
    --   " ⠀⠀⣿⠀⠀⠀⠀⠀⠳⡄⠻⣿⣿⣿⣿⣿⣿⣿⣿⣦⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀ ",
    --   " ⠀⠀⣿⠀⠀⠀⠀⠀⠀⣿⠀⠙⣿⣿⣿⣿⣿⣿⣿⣿⣷⡀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀ ",
    --   " ⠀⠀⣿⠀⠀⠀⠀⠀⠀⣿⠀⠀⠈⢿⣿⣿⣿⣿⣿⣿⣿⣿⣄⠀⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀ ",
    --   " ⠀⠀⣿⠀⠀⠀⠀⠀⠀⣿⠀⠀⠀⠀⠻⣿⣿⣿⣿⣿⣿⣿⣿⣦⠙⣿⣿⣿⣿⣿⣿⣿⠀⠀ ",
    --   " ⠀⠀⣿⠀⠀⠀⠀⠀⠀⣿⠀⠀⠀⠀⠀⠙⣿⣿⣿⣿⣿⣿⣿⣿⣧⡈⢿⣿⣿⣿⣿⣿⠀⠀ ",
    --   " ⠀⠀⣿⠀⠀⠀⠀⠀⠀⣿⠀⠀⠀⠀⠀⠀⠈⢿⣿⣿⣿⣿⣿⣿⣿⣷⡄⠻⣿⣿⣿⣿⠀⠀ ",
    --   " ⠀⠀⣿⠀⠀⠀⠀⠀⠀⣿⠀⠀⠀⠀⠀⠀⠀⠀⠻⣿⣿⣿⣿⣿⣿⣿⣿⣆⠙⣿⣿⣿⠀⠀ ",
    --   " ⠀⠀⠙⢦⡀⠀⠀⠀⠀⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⣿⣿⣿⣿⣿⣿⣿⣿⣧⡈⠿⠋⠀⠀ ",
    --   " ⠀⠀⠀⠀⠙⢦⡀⠀⠀⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⢿⣿⣿⣿⣿⣿⣿⡿⠃⠀⠀⠀⠀ ",
    --   " ⠀⠀⠀⠀⠀⠀⠙⢦⡀⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢻⣿⣿⣿⡿⠋⠀⠀⠀⠀⠀⠀ ",
    --   " ⠀⠀⠀⠀⠀⠀⠀⠀⠙⠿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⡿⠋⠀⠀⠀⠀⠀⠀⠀⠀ ",
    -- }
    -- dashboard.section.header.opts.hl = "string"

    -- NOTE: https://github.com/MaximilianLloyd/ascii.nvim/
    -- dashboard.section.header.val = {
    --   "                                                                     ",
    --   "                                                                   ",
    --   "      ████ ██████           █████      ██                    ",
    --   "     ███████████             █████                            ",
    --   "     █████████ ███████████████████ ███   ███████████  ",
    --   "    █████████  ███    █████████████ █████ ██████████████  ",
    --   "   █████████ ██████████ █████████ █████ █████ ████ █████  ",
    --   " ███████████ ███    ███ █████████ █████ █████ ████ █████ ",
    --   "██████  █████████████████████ ████ █████ █████ ████ ██████",
    --   "                                                                     ",
    -- }

    dashboard.section.header.val = {
      [[ _______             ____   ____.__         ]],
      [[ \      \   ____  ___\   \ /   /|__| _____  ]],
      [[ /   |   \_/ __ \/  _ \   Y   / |  |/     \ ]],
      [[/    |    \  ___(  <_> )     /  |  |  Y Y  \]],
      [[\____|__  /\___  >____/ \___/   |__|__|_|  /]],
      [[        \/     \/                        \/ ]],
    }

    dashboard.section.buttons.val = {
      dashboard.button('f', '󰥨  Find file', '<CMD>Telescope file_browser<CR>'),
      dashboard.button('g', '󰱼  Find text', '<CMD>Telescope live_grep<CR>'),
      dashboard.button('r', '  Recent file', '<CMD>Telescope oldfiles<CR>'),
      dashboard.button('u', '󰊳  Update', '<CMD>Lazy sync<CR>'),
      dashboard.button('c', '  Config', '<CMD>e $MYVIMRC | :cd %:p:h | :silent !pwd <CR>'),
      dashboard.button('q', '  Quit', '<CMD>qa<CR>'),
    }


    local function footer()
      local stats = require('lazy').stats()
      local plugins = stats.count

      local version = vim.version()
      local version_info = '   version' .. version.major .. '.' .. version.minor .. '.' .. version.patch

      return '⚡plugins ' .. plugins .. version_info
    end

    dashboard.section.footer.val = footer()

    alpha.setup(dashboard.opts)
  end

}
