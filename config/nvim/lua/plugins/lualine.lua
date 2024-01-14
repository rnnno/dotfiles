return {
  'nvim-lualine/lualine.nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
    'ryanoasis/vim-devicons',
    'yasunori0418/statusline_skk.vim'
  },
  config = function()
    local function convert_skkeleton_mode()
      local skk_mode = vim.fn['skkeleton#mode']()
      local mode_mappings = {
        hira = 'あぁ',
        kata = 'アァ',
        hankata = 'ｱｧ',
        zenkaku = 'Ａａ',
        abbrev = 'abbrev',
      }
      return mode_mappings[skk_mode] or 'Aa'
    end

    local function skk_mode()
      local current_mode = vim.fn.mode()
      if current_mode == 'i' or current_mode == 'c' or current_mode == 't' then
        return convert_skkeleton_mode()
      else
        return ''
      end
    end

    require('lualine').setup({
      options = {
        icons_enabled = true,
        theme = 'auto',
        component_separators = { left = '', right = ''},
        section_separators = { left = '', right = ''},
        disabled_filetypes = {
          statusline = {},
          winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = false,
        refresh = {
          statusline = 1000,
          tabline = 1000,
          winbar = 1000,
        }
      },

      sections = {
        lualine_a = {'mode', skk_mode},
        lualine_b = {'branch', 'diff', 'diagnostics'},
        lualine_c = {'filename'},
        lualine_x = {'encoding', 'fileformat', 'filetype'},
        lualine_y = {'progress'},
        lualine_z = {'location'}
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {'filename'},
        lualine_x = {'location'},
        lualine_y = {},
        lualine_z = {}
      },
      tabline = {},
      winbar = {},
      inactive_winbar = {},
      extensions = {
        'lazy',
        'mason',
      }

    })

    vim.g.lightline_skk_announce = true
    end

}
