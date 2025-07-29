return {
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    opts = {
      lsp = {
        signature = {
          enabled = false,
        }
      },
      routes = {
        {
          filter = {
            event = "lsp",
            find = "hecking",
          },
          opts = { skip = true },
        },
      },
    },
  },
  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim"
    },
    config = function()
      require("notify").setup({
        render = "wrapped-compact",
        stages = "static",
        max_width = 50,
      })
    end
  }
}

