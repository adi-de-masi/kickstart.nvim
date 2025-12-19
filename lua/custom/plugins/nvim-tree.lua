return {
  'nvim-tree/nvim-tree.lua',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  keys = {
    { '<leader>e', '<cmd>NvimTreeToggle<CR>', desc = 'Explorer (NvimTree)' },
  },
  opts = {},
  config = function(_, opts)
    require('nvim-tree').setup(opts)
  end,
}
