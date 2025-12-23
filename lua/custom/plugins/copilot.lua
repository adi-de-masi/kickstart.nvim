return {
  'zbirenbaum/copilot.lua',
  cmd = 'Copilot',
  event = 'InsertEnter',
  dependencies = {
    'copilotlsp-nvim/copilot-lsp',
  },
  opts = {
    nes = {
      enabled = true,
      keymap = {
        accept_and_goto = '<leader>p',
        accept = false,
        dismiss = '<Esc>',
      },
    },
    suggestion = { enabled = false },
    panel = { enabled = false },
  },
}
