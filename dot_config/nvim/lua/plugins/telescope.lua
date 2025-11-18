return {
  { "nvim-telescope/telescope.nvim",
      config = function()
        local actions = require("telescope.actions")
        require("telescope").setup({
          pickers = {
            find_files = { theme = "ivy" },
              live_grep = { theme = "ivy" },
              buffers = { theme = "ivy" },
              lsp_document_symbols = { theme = "dropdown" },
            },
            defaults = {
              mappings = {
                i = { ["<esc>"] = actions.close },
                n = { ["<esc>"] = actions.close },
                -- i = { ["<C-v>"] = actions.select_vertical },
              },
            },
          })
      end,
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
      },
  },

{ 'nvim-telescope/telescope-fzf-native.nvim' },


}
