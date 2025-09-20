local keymap = vim.keymap.set
local fn = vim.fn

return {
  {
    'Shougo/ddc.vim',
    lazy = true,
    event = 'BufReadPre',
    dependencies = {
      'vim-denops/denops.vim',
      -- UI
      'Shougo/pum.vim',
      'Shougo/ddc-ui-pum',
      -- Source
      'Shougo/ddc-source-around',
      'Shougo/ddc-source-lsp',
      'hrsh7th/vim-vsnip',
      'LumaKernel/ddc-source-file',
      'Shougo/ddc-source-cmdline',
      'Shougo/ddc-source-copilot',
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
        'copilot',
        'skkeleton',
        'lsp',
        -- 'vsnip',
        'file',
        'around',
      })

      patch_global('cmdlineSources', {
        [':'] = {
          'cmdline',
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
            'matcher_fuzzy',
          },
          sorters = {
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
          sorters = { 'sorter_rank' },
        },
        file = {
          mark = '[F]',
          isVolatile = true,
          forceCompletionPattern = [[\S/\S*]],
        },
        skkeleton = {
          mark = '[SKK]',
          matchers = {},
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
        copilot = {
          mark = '[Copilot]',
          matchers = {},
          sorters = {},
          converters = {},
          minAutoCompleteLength = 1,
          isVolatile = true,
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
    lazy = true,
    event = 'BufReadPre',
    config = function()
      fn['pum#set_option']({
        auto_select = true,
        padding = true,
        border = 'single',
        preview = false,
        scrollbar_char = '▋',
        highlight_normal_menu = 'Normal',
      })

      keymap('i', '<C-n>', '<cmd>call pum#map#select_relative(+1)<CR>')
      keymap('i', '<C-p>', '<cmd>call pum#map#select_relative(-1)<CR>')
      keymap('i', '<C-y>', '<cmd>call pum#map#confirm()<CR>')
      keymap('i', '<C-e>', '<cmd>call pum#map#cancel()<CR>')


      vim.cmd [[
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
    end,
  },
  {
    'matsui54/denops-signature_help',
    dependencies = { 'vim-denops/denops.vim' },
    lazy = true,
    event = 'BufReadPre',
    config = function()
      vim.g.signature_help_config = {
        contentsStyle = 'full',
        viewStyle = 'floating',
      }

      fn['signature_help#enable']()
    end,
  },
  {
    'hrsh7th/vim-vsnip',
    lazy = true,
    event = 'BufReadPre',
    config = function()
      vim.g.vsnip_snippet_dir = "~/.config/vsnip"
      vim.cmd('imap <expr> <C-l> vsnip#jumpable(1) ? "<Plug>(vsnip-jump-next)" : "<C-l>"')
      vim.cmd('smap <expr> <C-l> vsnip#jumpable(1) ? "<Plug>(vsnip-jump-next)" : "<C-l>"')
      vim.cmd('imap <expr> <C-h> vsnip#jumpable(-1) ? "<Plug>(vsnip-jump-prev)" : "<C-h>"')
      vim.cmd('smap <expr> <C-h> vsnip#jumpable(-1) ? "<Plug>(vsnip-jump-prev)" : "<C-h>"')
    end,
  },
}

