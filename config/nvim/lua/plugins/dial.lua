return {
  'monaqa/dial.nvim',
  event = { 'BufReadPost', 'BufNewFile' },
  config = function()
    local augend = require('dial.augend')
    require('dial.config').augends:register_group({
      default = {
        augend.integer.alias.decimal,
        augend.integer.alias.hex,
        augend.date.alias['%Y-%m-%d'],
        augend.date.alias['%Y/%m/%d'],
        augend.constant.alias.bool,
        augend.constant.new({ elements = { 'yes', 'no' }, word = true, cyclic = true }),
      },
    })

    local map = require('dial.map')
    local keymap = vim.keymap.set
    local opts = { noremap = true, silent = true }
    local function set(mode, lhs, rhs, desc)
      keymap(mode, lhs, rhs, vim.tbl_extend('force', {}, opts, { desc = desc }))
    end

    set('n', '<C-a>', map.inc_normal(), 'Dial increment')
    set('n', '<C-x>', map.dec_normal(), 'Dial decrement')
    set('v', '<C-a>', map.inc_visual(), 'Dial increment')
    set('v', '<C-x>', map.dec_visual(), 'Dial decrement')
    set('v', 'g<C-a>', map.inc_gvisual(), 'Dial increment (g)')
    set('v', 'g<C-x>', map.dec_gvisual(), 'Dial decrement (g)')
  end,
}
