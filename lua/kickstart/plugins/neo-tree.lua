-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim
return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  lazy = false,
  keys = {
    { '\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
  },
  opts = {
    filesystem = {
      window = {
        mappings = {
          ['\\'] = 'close_window',
        },
      },
    },
    -- your config here
    event_handlers = {
      -- save layout before opening neotree
      {
        event = 'neo_tree_window_before_open',
        handler = function()
          -- vim.cmd("set noequalalways")
          local layout = {}
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            layout[win] = {
              height = vim.api.nvim_win_get_height(win),
              width = vim.api.nvim_win_get_width(win),
            }
          end
          vim._neotree_layout = layout
        end,
      },
      -- restore layout after closing neotree
      {
        event = 'neo_tree_window_after_close',
        handler = function()
          if vim._neotree_layout then
            for win, dims in pairs(vim._neotree_layout) do
              if vim.api.nvim_win_is_valid(win) then
                pcall(vim.api.nvim_win_set_height, win, dims.height)
                pcall(vim.api.nvim_win_set_width, win, dims.width)
              end
            end
          end
        end,
      },
    },
  },
}
