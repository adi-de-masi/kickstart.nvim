return {
  'zbirenbaum/copilot.lua',
  cmd = 'Copilot',
  event = 'InsertEnter',
  dependencies = {
    'copilotlsp-nvim/copilot-lsp',
  },
  opts = {
    -- nes = {
    --   enabled = true,
    --   keymap = {
    --     accept_and_goto = '<C-y>',
    --     accept = false,
    --     dismiss = '<Esc>',
    --   },
    -- },
    suggestion = { enabled = true },
    panel = { enabled = false },
  },
}
