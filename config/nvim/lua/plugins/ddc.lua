local keymap = vim.keymap.set
local fn = vim.fn

return {
  {
    'Shougo/ddc.vim',
    dependencies = {
      'vim-denops/denops.vim',
      -- UI
      'Shougo/pum.vim',
      'Shougo/ddc-ui-pum',
      -- Source
      'Shougo/ddc-source-around',
      'Shougo/ddc-source-lsp',
      'Shougo/deoppet.nvim',
      'LumaKernel/ddc-source-file',
      'Shougo/ddc-source-cmdline',
      'Shougo/ddc-source-cmdline-history',
      -- Filter
      'Shougo/ddc-filter-matcher_head',
      'Shougo/ddc-filter-sorter_rank',
      'Shougo/ddc-filter-converter_truncate_abbr',
      'Shougo/ddc-filter-converter_remove_overlap',
      'tani/ddc-fuzzy',
      -- Preview
      'matsui54/denops-signature_help',
    },
    config = function()
      local patch_global = fn['ddc#custom#patch_global']

      patch_global('ui', 'pum')

      patch_global('autoCompleteEvents', {
        'InsertEnter',
        'TextChangedI',
        'TextChangedP',
        'CmdlineChanged',
      })

      patch_global('sources', {
        'skkeleton',
        'lsp',
        'deoppet',
        'file',
        'around',
      })

      patch_global('cmdlineSources', {
        [':'] = {
          'cmdline',
          'cmdline-history',
          'around',
        },
        ['/'] = {
          'around',
        },
        ['?'] = {
          'around',
        },
      })

      patch_global('sourceOptions', {
        _ = {
          matchers = {
            -- 'matcher_head',
            'matcher_fuzzy',
          },
          sorters = {
            -- 'sorter_rank',
            'sorter_fuzzy',
          },
          converters = { 'converter_truncate_abbr', 'converter_fuzzy', 'converter_remove_overlap' },
          ignoreCase = true,
          minAutoCompleteLength = 1,
        },
        around = {
          mark = '[A]',
        },
        lsp = {
          mark = '[LSP]',
          dup = 'keep',
          keywordPattern = '[a-zA-Z0-9_À-ÿ$#\\-*]*',
          forceCompletionPattern = [[\.\w*|:\w*|->\w*]],
          sorters = { 'sorter_lsp-kind', 'sorter_rank' },
        },
        deoppet = {
          mark = '[DP]',
          dup = true,
        },
        file = {
          mark = '[F]',
          isVolatile = true,
          forceCompletionPattern = [[\S/\S*]],
        },
        skkeleton = {
          mark = '[SKK]',
          matchers = { 'skkeleton' },
          sorters = {},
          converters = {},
          isVolatile = true,
          minAutoCompleteLength = 2,
        },
        cmdline = {
          mark = '[CMD]',
        },
        ['cmdline-history'] = {
          mark = '[HIST]',
        },
      })

      patch_global('sourceParams', {
        lsp = {
          snippetEngine = vim.fn['denops#callback#register'](function(body)
            vim.fn['vsnip#anonymous'](body)
          end),
          enableResolveItem = true,
          enableAdditionalTextEdit = true,
          confirmBehavior = 'replace',
        },
      })


      fn['ddc#enable_cmdline_completion']()
      fn['ddc#enable']()
    end,
  },
  {
    'Shougo/pum.vim',
    config = function()
      fn['pum#set_option']({
        auto_select = true,
        padding = true,
        border = 'single',
        preview = false,
        scrollbar_char = '▋',
        highlight_normal_menu = 'Normal',
      })

      -- Insert
      local opts = { silent = true, noremap = true }
      keymap('i', '<C-n>', '<cmd>call pum#map#select_relative(+1)<CR>', opts)
      keymap('i', '<C-p>', '<cmd>call pum#map#select_relative(-1)<CR>', opts)
      keymap('i', '<C-y>', '<cmd>call pum#map#confirm()<CR>', opts)
      keymap('i', '<C-e>', '<cmd>call pum#map#cancel()<CR>', opts)


      vim.cmd[[
      nnoremap :       <Cmd>call CommandlinePre()<CR>:

      function! CommandlinePre() abort
      cnoremap <Tab>   <Cmd>call pum#map#insert_relative(+1)<CR>
      cnoremap <S-Tab> <Cmd>call pum#map#insert_relative(-1)<CR>
      cnoremap <C-n>   <Cmd>call pum#map#insert_relative(+1)<CR>
      cnoremap <C-p>   <Cmd>call pum#map#insert_relative(-1)<CR>
      cnoremap <C-y>   <Cmd>call pum#map#confirm()<CR>
      cnoremap <C-e>   <Cmd>call pum#map#cancel()<CR>

      autocmd User DDCCmdlineLeave ++once call CommandlinePost()

      " Enable command line completion for the buffer
      call ddc#enable_cmdline_completion()
      endfunction
      function! CommandlinePost() abort
        silent! cunmap <Tab>
        silent! cunmap <S-Tab>
        silent! cunmap <C-n>
        silent! cunmap <C-p>
        silent! cunmap <C-y>
        silent! cunmap <C-e>
      endfunction
      ]]


      -- Commandline
      -- keymap('c', '<Tab>', '<Cmd>call pum#map#select_relative(+1)<CR>', { noremap = true })
      -- keymap('c', '<S-Tab>', '<Cmd>call pum#map#select_relative(-1)<CR>', { noremap = true })
      -- keymap('c', '<C-n>', '<cmd>call pum#map#select_relative(+1)<CR>', { noremap = true })
      -- keymap('c', '<C-p>', '<cmd>call pum#map#select_relative(-1)<CR>', { noremap = true })
      -- keymap('c', '<C-y>', '<cmd>call pum#map#confirm()<CR>', { noremap = true })
      -- keymap('c', '<C-e>', '<cmd>call pum#map#cancel()<CR>', { noremap = true })
    end,
  },
  {
    'matsui54/denops-signature_help',
    dependencies = { 'vim-denops/denops.vim' },
    config = function()
      vim.g.signature_help_config = {
        contentsStyle = 'full',
        viewStyle = 'floating',
      }

      fn['signature_help#enable']()
    end,
  },
  {
    'Shougo/deoppet.nvim',
    config = function ()
      fn['deoppet#initialize']()
      -- vim.cmd[[
      -- deoppet#custom#option('snippets',
      -- \ map(globpath(&runtimepath, 'neosnippets', 1, 1),
      -- \     { _, val -> { 'path': val } }))      
      -- )]]
      keymap('i', '<C-k>', '<Plug>(deoppet_expand)')
      keymap('i', '<C-f>', '<plug>(deoppet_jump_forward)')
      keymap('i', '<C-b>', '<plug>(deoppet_jump_backward)')
      keymap('s', '<C-f>', '<plug>(deoppet_jump_forward)')
      keymap('s', '<C-b>', '<plug>(deoppet_jump_backward)')
    end
  }
}
