vim.g.mkdp_filetypes = { 'markdown' }

vim.pack.add({
  'https://github.com/iamcco/markdown-preview.nvim',
}, { load = false })

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'markdown',
  callback = function()
    vim.cmd.packadd('markdown-preview.nvim')
  end,
})
