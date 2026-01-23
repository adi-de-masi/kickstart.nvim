return {
  'obsidian-nvim/obsidian.nvim',
  version = '*', -- use latest release, remove to use latest commit
  lazy = true,
  event = function()
    local vault_path = vim.fn.expand("~/AdisObsidianSyncVault")
    return {
      "BufReadPre " .. vault_path .. "/**/*.md",
      "BufNewFile " .. vault_path .. "/**/*.md",
    }
  end,
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  cmd = {
    "ObsidianOpen",
    "ObsidianNew",
    "ObsidianQuickSwitch",
    "ObsidianFollowLink",
    "ObsidianBacklinks",
    "ObsidianTags",
    "ObsidianToday",
    "ObsidianYesterday",
    "ObsidianTomorrow",
    "ObsidianDailies",
    "ObsidianTemplate",
    "ObsidianSearch",
    "ObsidianLink",
    "ObsidianLinkNew",
    "ObsidianLinks",
    "ObsidianExtractNote",
    "ObsidianWorkspace",
    "ObsidianPasteImg",
    "ObsidianRename",
    "ObsidianTOC",
  },
  ---@module 'obsidian'
  ---@type obsidian.config
  opts = {
    legacy_commands = false, -- this will be removed in the next major release
    workspaces = {
      {
        name = 'MyOnlyVault',
        path = '~/AdisObsidianSyncVault',
      },
    },
  },
}
