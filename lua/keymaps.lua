-- Adi's custom section
local map = vim.keymap.set
--local unmap = vim.keymap.del

-- Neovim 0.11+ ships default LSP keymaps in `vim/_defaults.lua` (e.g. `grr`, `gri`, `grt`),
-- but those use the built-in UI (often a locations list / read-only buffer).
-- Override them here to prefer Telescope pickers.
local function telescope_lsp(picker, fallback, picker_opts)
  return function()
    local ok, builtin = pcall(require, 'telescope.builtin')
    if ok and type(builtin[picker]) == 'function' then
      return builtin[picker](picker_opts or {})
    end
    return fallback()
  end
end

map('n', 'gr', telescope_lsp('lsp_references', vim.lsp.buf.references), { desc = 'LSP: references (telescope)' })
map('n', 'gi', telescope_lsp('lsp_implementations', vim.lsp.buf.implementation), { desc = 'LSP: implementations (telescope)' })
map('n', 'gt', telescope_lsp('lsp_type_definitions', vim.lsp.buf.type_definition), { desc = 'LSP: type definitions (telescope)' })
map('n', 'gO', telescope_lsp('lsp_document_symbols', vim.lsp.buf.document_symbol), { desc = 'LSP: document symbols (telescope)' })
map('n', 'gd', telescope_lsp('lsp_definitions', vim.lsp.buf.document_symbol), { desc = 'LSP: Go to definition' })

map('n', ';', ':', { desc = 'CMD enter command mode' })
map('i', 'jk', '<ESC>')

map('n', '<leader>h', '<cmd>nohlsearch<CR>', { desc = 'set no highlight search' })
map('n', '<A-j>', '<cmd> m .+1<CR>==', { desc = 'Move line down' })
map('n', '<A-k>', '<cmd> m .-2<CR>==', { desc = 'Move line up' })
map('v', '<A-j>', ":m '>+1<CR>gv=gv", { desc = 'Move selected block down' })
map('v', '<A-k>', ":m '<-2<CR>gv=gv", { desc = 'Move selected block up' })
map('v', '<leader>y', '"*y', { desc = 'Yank to clipboard' })

map('n', '<leader>w', ':w <CR>', { desc = 'alias to :w' })
map('n', '<C-h>', '<Cmd>NvimTmuxNavigateLeft<CR>', { silent = true })
map('n', '<C-j>', '<Cmd>NvimTmuxNavigateDown<CR>', { silent = true })
map('n', '<C-k>', '<Cmd>NvimTmuxNavigateUp<CR>', { silent = true })
map('n', '<C-l>', '<Cmd>NvimTmuxNavigateRight<CR>', { silent = true })
map('n', '<C-\\>', '<Cmd>NvimTmuxNavigateLastActive<CR>', { silent = true })
map('n', '<leader>m', '<Cmd>MarkdownPreview<CR>', { silent = true })
map('n', '<leader>gg', '<Cmd> LazyGit <CR>', { desc = 'start LazyGit' })

map('n', '<leader>d', ' Run/Debug')
map('n', '<leader>fe', '<Cmd>Telescope emoji<CR>', { desc = '😃 [F]ind [E]moji' })
map('n', '<leader>l', ' Lsp')
map('n', '<leader>lw', function()
  vim.diagnostic.setloclist()
end, { desc = 'Diagnostic setloclist' })
map('n', '<leader>la', '<Cmd>lua vim.lsp.buf.code_action()<CR>', { desc = 'code actions' })

map('n', '<leader>t', ' Telescope or  Trouble')
map('n', '<leader>tr', '<Cmd>Telescope resume<CR>')
map('n', '<leader>o', ' Obsidian')
map('n', '<leader>r', ' Render Markdown')
map('n', '<leader>rt', '<Cmd>RenderMarkdown toggle<CR>', { desc = 'toggle render markdown', silent = true })
map('n', '<leader>re', '<Cmd>RenderMarkdown expand<CR>', { desc = 'Increase anti-conceal margin above and below by 1', silent = true })
map('n', '<leader>re', '<Cmd>RenderMarkdown expand<CR>', { desc = 'Decrease anti-conceal margin above and below by 1', silent = true })
map('n', '<leader>os', '<Cmd>ObsidianSearch<CR>', { silent = true })
map('n', '<leader>ob', '<Cmd>ObsidianBacklink<CR>', { silent = true })
map('n', '<leader>ot', '<Cmd>ObsidianToday<CR>', { silent = true })
map('n', '<leader>od', '<Cmd>ObsidianDailies<CR>', { silent = true })
map('n', '<leader>oq', '<Cmd>ObsidianQuickSwitch<CR>', { silent = true })
map('n', '<leader>on', '<Cmd>ObsidianNew<CR>', { silent = true })

map('n', '<leader>e', '<Cmd>NvimTreeFindFileToggle<CR>', { silent = true })
map('n', '<leader><Tab>', '<Cmd>bn<CR>', { desc = 'next buffer' })
map('n', '<leader><S-Tab>', '<Cmd>bp<CR>', { desc = 'previous buffer' })
map('n', '<leader>x', '<Cmd>bd<CR>', { desc = 'delete buffer' })

map('n', 'X', ':only<CR>', { desc = 'Close other panes' })

-- TJs kickstart
--
--
-- [[ Basic Keymaps ]]
--  See `:help map()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
--map('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
map('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
-- map('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- map('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- map('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- map('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
-- map('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
-- map('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
-- map('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
-- map('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})
