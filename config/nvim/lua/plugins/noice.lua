return {
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {},
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    }
  },
  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    opts = {},
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim"
    },
    config = function()
      require("notify").setup({
        -- background_colour = "#000000",
        render = "wrapped-compact",
        stages = "static",
        max_width = 50,
      })
    end
  }
}
