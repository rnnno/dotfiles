local ensure_installed = {
  'c',
  'cpp',
  'vim',
  'lua',
  'go',
  'html',
  'css',
  'tsx',
  'typescript',
}

return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false, -- main ブランチは lazy-load 非対応
    build = ':TSUpdate',
    config = function()
      local ts = require('nvim-treesitter')

      ts.setup({})

      local installed = ts.get_installed('parsers')
      local missing = vim.tbl_filter(function(lang)
        return not vim.tbl_contains(installed, lang)
      end, ensure_installed)
      if #missing > 0 then
        ts.install(missing)
      end

      local available

      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('Treesitter', { clear = true }),
        callback = function(ev)
          local lang = vim.treesitter.language.get_lang(ev.match)
          if not lang then
            return
          end

          -- パーサ未導入なら取得だけ行い、ハイライトは次回オープン時から有効になる
          if not vim.treesitter.language.add(lang) then
            available = available or ts.get_available()
            if not vim.tbl_contains(available, lang) then
              return
            end
            ts.install(lang)
            return
          end

          pcall(vim.treesitter.start, ev.buf, lang)
        end,
      })
    end,
  },
  {
    'andersevenrud/nvim_context_vt',
    lazy = true,
    event = 'BufWinEnter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      require('nvim_context_vt').setup({
        enable = true,
      })
    end,
  },
  {
    'Wansmer/treesj',
    lazy = true,
    keys = {
      { '<leader>m', "<CMD>lua require('treesj').toggle()<CR>" },
    },
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      require('treesj').setup({
        use_default_keymaps = false,
      })
    end,
  },
  {
    'shellRaining/hlchunk.nvim',
    lazy = true,
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {
      chunk = { enable = true },
      indent = { enable = false },
      line_num = { enable = true },
      blank = { enable = false },
    },
  },
}

