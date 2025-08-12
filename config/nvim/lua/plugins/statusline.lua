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

return {
  'tamton-aquib/staline.nvim',
  lazy = true,
  event = 'BufWinEnter',
  config = function()
    require "staline".setup {
      sections = {
        left = { '  ', 'mode', ' ', { 'Staline', skk_mode }, ' ', 'branch', ' ', },
        mid = { 'lsp' },
        right = { 'file_name', 'line_column' }
      },
      mode_colors = {
        n = "#90ee90",
        nt = "#90ee90",

        t = "#f48d93",

        i = "#87cefa",

        c = "#ff7f50",
      },
      defaults = {
        true_colors = true,
        line_column = " [%l/%L] :%c  ",
      },
      special_table = {
        lazy = { 'Lazy', '󱒋 ' },
      },
    }
  end
}

