return {
  { "zbirenbaum/copilot.lua",
    opts = { filetypes = { ["*"] = true } },
    config = function()
      require("copilot").setup({
        suggestion = {
          auto_trigger = true,
          keymap = {
            accept_word = false,
            accept_line = false,
            accept = "<S-Tab>",
          },
        },
      })
    end,
  },
}
