return {
  'obsidian-nvim/obsidian.nvim',
  version = '*', -- use latest release, remove to use latest commit
  ft = 'markdown',
  ---@module 'obsidian'
  ---@type obsidian.config
  opts = {
    legacy_commands = false, -- this will be removed in the next major release
    -- Disable footer to avoid "calling 'backlinks' on bad self" when timer runs
    -- after buffer is closed/reused (plugin bug: footer doesn't validate buffer).
    footer = { enabled = false },
    workspaces = {
      {
        name = 'MyOnlyVault',
        path = '~/AdisObsidianSyncVault',
      },
    },
  },
}
