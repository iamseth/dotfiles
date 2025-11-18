return {
  { "folke/noice.nvim",
    config = function()
     require("noice").setup({
       presets = {
         bottom_search = true, -- use a classic bottom cmdline for search
         command_palette = false,
         long_message_to_split = true, -- long messages will be sent to a split
         inc_rename = false, -- enables an input dialog for inc-rename.nvim
         lsp_doc_border = false, -- add a border to hover docs and signature help
       },
       routes = {
         { filter = { event = "msg_show", kind = "", find = "written" }, opts = { skip = true } },
       },
     })
   end,
   dependencies = {
     "MunifTanjim/nui.nvim",
     "nvim-lua/popup.nvim" ,
     "nvim-lua/plenary.nvim",
     "nvim-treesitter/nvim-treesitter",
   },
  },
}
