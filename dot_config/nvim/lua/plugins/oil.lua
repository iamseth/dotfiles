return {
  { "stevearc/oil.nvim",
    config = function()
      require("oil").setup({
        default_file_explorer = true,
        preview = {
          update_on_cursor_moved = true,
        },
        columns = {
          "icon",
          "size",
          "mtime",
          "permissions",
        },
        view_options = {
          show_hidden = true,
        },
      })
    end,
  },
}
