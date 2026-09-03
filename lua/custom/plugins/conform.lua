return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      -- Customize or remove this keymap to your liking
      '<leader>lf',
      function()
        require('conform').format { async = false }
      end,
      mode = 'n',
      desc = 'Format buffer',
    },
  },
  -- This will provide type hinting with LuaLS
  ---@module "conform"
  ---@type conform.setupOpts
  opts = {
    -- Define your formatters
    formatters_by_ft = {
      lua = { 'stylua' },
      python = { 'isort', 'black' },
      javascript = { 'eslint_d' },
      typescript = { 'eslint_d' },
      html = { 'eslint_d' },
      css = { 'eslint_d' },
    },
    -- Set default options
    default_format_opts = {
      lsp_format = 'fallback',
    },
    -- Set up format-on-save
    format_on_save = function(bufnr)
      -- Disable format_on_save for TypeScript to prevent auto-indent conflicts
      local filetype = vim.bo[bufnr].filetype
      if filetype == 'typescript' or filetype == 'typescriptreact' or filetype == 'ts' or filetype == 'tsx' then
        return false
      end
      return { timeout_ms = 500 }
    end,
    -- Customize formatters
    formatters = {
      shfmt = {
        prepend_args = { '-i', '2' },
      },
    },
    eslint_d = {
      args = { '--fix', '--stdin', '--stdin-filename', '$FILENAME' },
      cwd = function(bufnr)
        local bufname = vim.api.nvim_buf_get_name(bufnr)
        return vim.fs.dirname(bufname)
      end,
    },
  },
  init = function()
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

    -- Set TypeScript indentation to 2 spaces and disable ALL auto-formatting/indenting
    vim.api.nvim_create_autocmd('FileType', {
      pattern = { 'typescript', 'typescriptreact', 'ts', 'tsx' },
      callback = function()
        vim.opt_local.tabstop = 2
        vim.opt_local.shiftwidth = 2
        -- Disable ALL auto-indent/format options
        vim.opt_local.autoindent = false
        vim.opt_local.smartindent = false
        vim.opt_local.cindent = false
        vim.opt_local.indentexpr = ''
        vim.opt_local.equalprg = ''
        vim.opt_local.formatprg = ''
        vim.opt_local.formatexpr = ''
        -- Disable vim-sleuth for TypeScript files
        vim.b.sleuth_automatic = 0
      end,
    })

    -- Prevent ANY auto-indent/format before write for TypeScript files
    vim.api.nvim_create_autocmd('BufWritePre', {
      pattern = { '*.ts', '*.tsx' },
      callback = function()
        -- Completely disable all formatting/indenting right before save
        vim.opt_local.indentexpr = ''
        vim.opt_local.equalprg = ''
        vim.opt_local.formatprg = ''
        vim.opt_local.formatexpr = ''
        vim.opt_local.autoindent = false
        vim.opt_local.smartindent = false
        vim.opt_local.cindent = false
      end,
    })
  end,
}
