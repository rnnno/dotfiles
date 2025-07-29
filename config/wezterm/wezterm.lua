local wezterm = require 'wezterm';
local act = wezterm.action

return {
  enable_wayland = false,
  initial_cols = 100,
  initial_rows = 40,
  font_size = 12.0,
  cell_width = 1.0,
  line_height = 1.0,
  color_scheme = "iceberg-dark",
  font = wezterm.font_with_fallback({
    { family = "FiraCode Nerd Font", harfbuzz_features = { "cv01", "cv02", "cv06", "cv23", "cv24", "cv25", "cv26", "cv29", "cv32", "ss02", "ss03", "ss05", "ss09", "ss07" }, weight = "Medium" },
  }),
  use_fancy_tab_bar = true,
  hide_tab_bar_if_only_one_tab = true,
  window_background_opacity = 0.80,
  text_background_opacity = 0.85,
  -- window_background_image = "Pictures/IMG_2162.JPG",
  -- window_background_image_hsb = {
  --   brightness = 0.03,
  --   hue = 1.0,
  --   saturation = 0.1,
  -- },
  skip_close_confirmation_for_processes_named = { "" },
  window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
  },
  wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
    return {
      { Text = " " .. tab.active_pane.title .. " " },
    }
  end),
  colors = {
    tab_bar = {
      background = "#1b1f2f",

      active_tab = {
        bg_color = "#444b71",
        fg_color = "#c6c8d1",
        intensity = "Normal",
        underline = "None",
        italic = false,
        strikethrough = false,
      },

      inactive_tab = {
        bg_color = "#282d3e",
        fg_color = "#c6c8d1",
        intensity = "Normal",
        underline = "None",
        italic = false,
        strikethrough = false,
      },

      inactive_tab_hover = {
        bg_color = "#1b1f2f",
        fg_color = "#c6c8d1",
        intensity = "Normal",
        underline = "None",
        italic = true,
        strikethrough = false,
      },

      new_tab = {
        bg_color = "#1b1f2f",
        fg_color = "#c6c8d1",
        italic = false
      },

      new_tab_hover = {
        bg_color = "#444b71",
        fg_color = "#c6c8d1",
        italic = false
      },
    }
  },
  leader = {
    key = "m",
    mods = "CTRL",
    timeout_milliseconds = 1500,
  },
  keys = {
    { key = "t",     mods = "LEADER",     action = act.SpawnTab("CurrentPaneDomain") },
    { key = "d",     mods = "LEADER",     action = act.CloseCurrentTab { confirm = true } },
    { key = "w",     mods = "LEADER",     action = act.ShowTabNavigator },

    { key = "v",     mods = "LEADER",     action = act.SplitHorizontal { domain = "CurrentPaneDomain" } },
    { key = "s",     mods = "LEADER",     action = act.SplitVertical { domain = "CurrentPaneDomain" } },
    { key = "x",     mods = "LEADER",     action = act.CloseCurrentPane { confirm = true } },

    { key = "h",     mods = "LEADER",     action = act.ActivatePaneDirection("Left") },
    { key = "l",     mods = "LEADER",     action = act.ActivatePaneDirection("Right") },
    { key = "k",     mods = "LEADER",     action = act.ActivatePaneDirection("Up") },
    { key = "j",     mods = "LEADER",     action = act.ActivatePaneDirection("Down") },
    { key = "H",     mods = "LEADER",     action = act.AdjustPaneSize { "Left", 10 } },
    { key = "L",     mods = "LEADER",     action = act.AdjustPaneSize { "Right", 10 } },
    { key = "K",     mods = "LEADER",     action = act.AdjustPaneSize { "Up", 5 } },
    { key = "J",     mods = "LEADER",     action = act.AdjustPaneSize { "Down", 5 } },

    { key = "x",     mods = "CTRL|SHIFT", action = act.ActivateCopyMode },
    { key = "v",     mods = "CTRL|SHIFT", action = act.PasteFrom("Clipboard") },

    { key = "Enter", mods = "ALT",        action = 'DisableDefaultAssignment' },
  },
}
