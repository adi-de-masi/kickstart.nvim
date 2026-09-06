vim.pack.add({
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/nvim-treesitter/nvim-treesitter",
  {
    src = "https://github.com/olimorris/codecompanion.nvim",
    version = vim.version.range("^19.0.0"),
  },
})

-- Configure CodeCompanion
require("codecompanion").setup({
  interactions = {
    chat = {
      -- You can specify an adapter by name and model (both ACP and HTTP)
      adapter = {
        name = "ollama",
        model = "qwen2.5-coder:14b",
      },
    },
    -- Or, just specify the adapter by name
    inline = {
      adapter = "ollama",
    },
    cmd = {
      adapter = "ollama",
    },
    background = {
      adapter = {
        name = "ollama",
      },
    },
  },
  opts = {
    log_level = "DEBUG", -- or "TRACE"
  },
})
