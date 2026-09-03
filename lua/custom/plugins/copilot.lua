return {
  'zbirenbaum/copilot.lua',
  cmd = 'Copilot',
  event = 'InsertEnter',
  -- Load before nvim-cmp to ensure copilot is ready
  priority = 100,
  config = function()
    require('copilot').setup {
      suggestion = {
        enabled = true,
        auto_trigger = true, -- Need to trigger to get suggestions for copilot-cmp
        debounce = 75,
        keymap = {
          accept = false, -- Disable accept keymap, use copilot-cmp instead
          accept_word = false,
          accept_line = false,
          next = '<M-]>',
          prev = '<M-[>',
          dismiss = '<C-]>',
        },
      },
      panel = { enabled = true },
    }
  end,
}
