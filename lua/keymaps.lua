-- Adi's custom section
local map = vim.keymap.set
--local unmap = vim.keymap.del

-- Keep LSP commands under <leader>l. Telescope-backed commands fall back to
-- Neovim's native LSP UI when Telescope is unavailable.
local function telescope_lsp(picker, fallback, picker_opts)
  return function()
    local ok, builtin = pcall(require, 'telescope.builtin')
    if ok and type(builtin[picker]) == 'function' then
      return builtin[picker](picker_opts or {})
    end
    return fallback()
  end
end

-- Neovim defines these globally. Remove them so <leader>l is the only LSP
-- command family in this configuration.
for _, keys in ipairs { 'grn', 'gra', 'grr', 'gri', 'grt', 'grx' } do
  pcall(vim.keymap.del, 'n', keys)
end

map('n', '<leader>lr', telescope_lsp('lsp_references', vim.lsp.buf.references), { desc = 'LSP: [R]eferences' })
map('n', '<leader>li', telescope_lsp('lsp_implementations', vim.lsp.buf.implementation), { desc = 'LSP: [I]mplementations' })
map('n', '<leader>lt', telescope_lsp('lsp_type_definitions', vim.lsp.buf.type_definition), { desc = 'LSP: [T]ype definitions' })
map('n', '<leader>lo', telescope_lsp('lsp_document_symbols', vim.lsp.buf.document_symbol), { desc = 'LSP: D[o]cument symbols' })
map('n', '<leader>lS', telescope_lsp('lsp_dynamic_workspace_symbols', vim.lsp.buf.workspace_symbol), { desc = 'LSP: Work[S]pace symbols' })
map('n', '<leader>ld', telescope_lsp('lsp_definitions', vim.lsp.buf.definition), { desc = 'LSP: [D]efinition' })

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
map('n', '<leader>se', '<Cmd>Telescope emoji<CR>', { desc = '😃 [S]earch [E]moji' })
map('n', '<leader>tb', '<Cmd>Telescope buffers<CR>', { desc = 'Telescope: [B]uffers' })
map('n', '<leader>tq', '<Cmd>Telescope quickfix<CR>', { desc = 'Telescope: [Q]uickfix list' })
map('n', '<leader>tl', '<Cmd>Telescope loclist<CR>', { desc = 'Telescope: [L]ocation list' })
map('n', '<leader>tm', '<Cmd>Telescope marks<CR>', { desc = 'Telescope: [M]arks' })
map('n', '<leader>tg', '<Cmd>Telescope git_status<CR>', { desc = 'Telescope: [G]it status' })
map('n', '<leader>tB', '<Cmd>Telescope git_branches<CR>', { desc = 'Telescope: Git [B]ranches' })
map('n', '<leader>lw', function()
  vim.diagnostic.setloclist()
end, { desc = 'Diagnostic setloclist' })
map({ 'n', 'x' }, '<leader>la', vim.lsp.buf.code_action, { desc = 'LSP: Code [A]ctions' })
map('n', '<leader>ln', vim.lsp.buf.rename, { desc = 'LSP: Re[n]ame' })
map('n', '<leader>lD', vim.lsp.buf.declaration, { desc = 'LSP: [D]eclaration' })
map('n', '<leader>lc', vim.lsp.codelens.run, { desc = 'LSP: [C]ode lens' })

map('n', '<leader>tr', '<Cmd>Telescope resume<CR>', { desc = 'Telescope: [R]esume' })
map('n', '<leader>rt', '<Cmd>RenderMarkdown toggle<CR>', { desc = 'toggle render markdown', silent = true })
map('n', '<leader>re', '<Cmd>RenderMarkdown expand<CR>', { desc = 'Increase anti-conceal margin above and below by 1', silent = true })
map('n', '<leader>re', '<Cmd>RenderMarkdown expand<CR>', { desc = 'Decrease anti-conceal margin above and below by 1', silent = true })

map('n', '<leader>e', '<Cmd>Neotree toggle<CR>')
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
