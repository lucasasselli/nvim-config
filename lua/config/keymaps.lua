vim.g.mapleader = ","

local keymap = vim.keymap

keymap.set("n", "<leader><space>", ":nohl<CR>", { desc = "Clear search highlights" })
keymap.set("n", "<space>", "za", { desc = "Open folds" })

keymap.set("n", "L", "gt", { desc = "Change tab" })
keymap.set("n", "H", "gT", { desc = "Change tab" })
keymap.set("n", "<space>", "za", { desc = "Toggle fold" })

-- Commands
vim.api.nvim_create_user_command('Hex', '%!xxd', {})

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        -- Enable completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = ev.buf }
        keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
        keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
        keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
        keymap.set('n', '<leader>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, opts)
        keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
        keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
        keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
        keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    end
})
