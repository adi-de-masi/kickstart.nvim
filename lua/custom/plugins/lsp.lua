return {
  'neovim/nvim-lspconfig',
  dependencies = {
    -- Automatically install LSPs to stdpath for neovim
    -- 'williamboman/mason.nvim',
    -- 'williamboman/mason-lspconfig.nvim',

    -- Useful status updates for LSP
    { 'j-hui/fidget.nvim', opts = {} },

    -- Additional lua configuration, makes nvim stuff amazing!
    'folke/neodev.nvim',
  },
  config = function()
    -- Mappings.
    -- See `:help vim.diagnostic.*` for documentation on any of the below functions
    local opts = { silent = true }

    function optsWithDesc(desc)
      return { desc = desc }
    end

    -- the following diagnostic commands don't work :(
    -- vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
    -- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)
    --- end of not working

    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, optsWithDesc 'previous diagnostics')
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, optsWithDesc 'next diagnostics')

    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'sh',
      callback = function()
        vim.lsp.start {
          name = 'bash-language-server',
          cmd = { 'bash-language-server', 'start' },
        }
      end,
    })

    -- Use an on_attach function to only map the following keys
    -- after the language server attaches to the current buffer
    local on_attach = function(client, bufnr)
      function bufoptsWithDesc(desc)
        return { silent = true, buffer = bufnr, desc = desc }
      end

      local function telescope_lsp(picker, fallback, picker_opts)
        return function()
          local ok, builtin = pcall(require, 'telescope.builtin')
          if ok and type(builtin[picker]) == 'function' then
            return builtin[picker](picker_opts or {})
          end
          return fallback()
        end
      end

      vim.keymap.set(
        'n',
        '<leader>ls',
        telescope_lsp('lsp_document_symbols', vim.lsp.buf.document_symbol),
        bufoptsWithDesc 'Open symbol picker'
      )
      vim.keymap.set(
        'n',
        '<leader>lS',
        telescope_lsp('lsp_dynamic_workspace_symbols', vim.lsp.buf.workspace_symbol),
        bufoptsWithDesc 'Open symbol picker (workspace)'
      )
      vim.keymap.set(
        'n',
        '<leader>dd',
        telescope_lsp('diagnostics', vim.diagnostic.setloclist),
        bufoptsWithDesc 'Open diagnostics picker'
      )
      -- Enable completion triggered by <c-x><c-o>
      vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

      -- Mappings.
      -- See `:help vim.lsp.*` for documentation on any of the below functions
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufoptsWithDesc 'LSP Hover')
      -- Neovim (0.11+) sets default LSP keymaps from `vim/_defaults.lua` on `LspAttach`.
      -- Those can overwrite mappings set inside `on_attach`, so we schedule our preferred
      -- mappings to run after the defaults.
      vim.schedule(function()
        -- Prefer Telescope UI for "jump-to/list" LSP requests when available;
        -- fall back to built-in LSP functions otherwise.
        --
        -- NOTE: Telescope doesn't provide `lsp_declarations`, so `gD` always falls back.
        vim.keymap.set(
          'n',
          'gd',
          telescope_lsp('lsp_definitions', vim.lsp.buf.definition),
          bufoptsWithDesc 'Definition (telescope)'
        )
        vim.keymap.set(
          'n',
          'gr',
          telescope_lsp('lsp_references', vim.lsp.buf.references),
          bufoptsWithDesc 'References (telescope)'
        )
        vim.keymap.set(
          'n',
          'gi',
          telescope_lsp('lsp_implementations', vim.lsp.buf.implementation),
          bufoptsWithDesc 'Implementation (telescope)'
        )
        vim.keymap.set(
          'n',
          'gt',
          telescope_lsp('lsp_type_definitions', vim.lsp.buf.type_definition),
          bufoptsWithDesc 'Type definition (telescope)'
        )
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufoptsWithDesc 'Declaration')
      end)
      -- TODO: C-k is already used for going to the top split figure out a different keymap
      -- vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufoptsWithDesc("Signature help"))
      -- vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, bufoptsWithDesc(""))
      -- vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, bufoptsWithDesc())
      -- vim.keymap.set('n', '<leader>wl', function()
      --   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      -- end, bufoptsWithDesc())
      vim.keymap.set('n', '<leader>lr', function()
        -- when rename opens the prompt, this autocommand will trigger
        -- it will "press" CTRL-F to enter the command-line window `:h cmdwin`
        -- in this window I can use normal mode keybindings
        local cmdId
        cmdId = vim.api.nvim_create_autocmd({ 'CmdlineEnter' }, {
          callback = function()
            local key = vim.api.nvim_replace_termcodes('<C-f>', true, false, true)
            vim.api.nvim_feedkeys(key, 'c', false)
            vim.api.nvim_feedkeys('0', 'n', false)
            -- autocmd was triggered and so we can remove the ID and return true to delete the autocmd
            cmdId = nil
            return true
          end,
        })
        vim.lsp.buf.rename()
        -- if LPS couldn't trigger rename on the symbol, clear the autocmd
        vim.defer_fn(function()
          -- the cmdId is not nil only if the LSP failed to rename
          vim.api.nvim_del_autocmd(cmdId)
          if cmdId then
          end
        end, 500)
      end, bufoptsWithDesc 'Rename symbol')
      vim.keymap.set('n', '<leader>lw', function()
        vim.diagnostic.setloclist()
      end, { desc = 'Diagnostic setloclist' })
      vim.keymap.set('n', '<leader>la', vim.lsp.buf.code_action, bufoptsWithDesc 'Run code action')
      -- vim.keymap.set('n', '<leader>f', vim.lsp.buf.formatting, bufoptsWithDesc("Format using LSP"))
    end

    -- Prefer blink.cmp capabilities if available (kickstart config uses blink.cmp),
    -- otherwise fall back to vanilla LSP capabilities.
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    local ok_blink, blink = pcall(require, 'blink.cmp')
    if ok_blink and type(blink.get_lsp_capabilities) == 'function' then
      capabilities = blink.get_lsp_capabilities(capabilities)
    end
    local lspconfig = vim.lsp.config

    lspconfig['gopls'] = {
      capabilities = capabilities,
      on_attach = on_attach,
    }
    vim.lsp.enable 'gopls'

    lspconfig['ts_ls'] = {
      capabilities = capabilities,
      on_attach = on_attach,
    }
    vim.lsp.enable 'ts_ls'

    lspconfig['sqlls'] = {
      capabilities = capabilities,
      on_attach = on_attach,
    }
    vim.lsp.enable 'sqlls'

    lspconfig['tailwindcss-language-server'] = {
      capabilities = capabilities,
      on_attach = on_attach,
      filetypes = { 'html', 'css', 'scss', 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'eruby' },
    }
    vim.lsp.enable 'tailwindcss-language-server'

    lspconfig['ruby_lsp'] = {
      capabilities = capabilities,
      on_attach = on_attach,
      mason = false,
      cmd = { vim.fn.expand '~/.local/share/mise/installs/ruby/3.4.1/bin/ruby-lsp' },
    }
    vim.lsp.enable 'ruby_lsp'

    lspconfig['lua_ls'] = {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = {
        Lua = {
          runtime = {
            version = 'LuaJIT',
          },
          diagnostics = {
            globals = { 'vim' },
          },
          workspace = {
            library = vim.api.nvim_get_runtime_file('', true),
            checkThirdParty = false,
          },
        },
      },
    }
    vim.lsp.enable 'lua_ls'

    lspconfig.marksman = {}
    if vim.fn.executable 'solargraph' == 1 then
      lspconfig['solargraph'] = {
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          flags = {
            debounce_text_changes = 150,
          },
        },
      }
    end
  end,
}
