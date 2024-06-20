return {
    "neovim/nvim-lspconfig",
    dependencies = {
        { "williamboman/mason.nvim" },
        { "williamboman/mason-lspconfig.nvim" },
        {
            "hrsh7th/nvim-cmp",
            dependencies = {
                "hrsh7th/cmp-nvim-lsp",
                "hrsh7th/cmp-buffer",
                "hrsh7th/cmp-path",
                "saadparwaiz1/cmp_luasnip",
                "L3MON4D3/LuaSnip" }
        }
    },
    config = function(_)
        local luasnip = require("luasnip");
        local cmp = require('cmp')
        cmp.setup({
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },
            window = {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered(),
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-n>'] = cmp.mapping.select_next_item(),
                ['<C-b>'] = cmp.mapping.select_prev_item(),
                ['<C-u>'] = cmp.mapping.scroll_docs(-2),
                ['<C-d>'] = cmp.mapping.scroll_docs(2),
                ['<C-Space>'] = cmp.mapping.complete(),
                ['<C-e>'] = cmp.mapping.abort(),
                ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                ['<Tab>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif luasnip.expand_or_locally_jumpable() then
                        luasnip.expand_or_jump()
                    else
                        fallback()
                    end
                end, { 'i', 's' }),
                ['<S-Tab>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif luasnip.locally_jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { 'i', 's' }),
            }),
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'luasnip' },
                { name = "buffer" },
                { name = "path" },
            })
        })

        local lspconfig = require('lspconfig')
        local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()

        require('mason').setup({})
        require('mason-lspconfig').setup({
            ensure_installed = {
                'clangd',
                'lua_ls'
            },
            handlers = {
                function(server)
                    lspconfig[server].setup({
                        capabilities = lsp_capabilities,
                    })
                end,

                -- Clangd (C/C++)
                ['clangd'] = function()
                    lspconfig.clangd.setup({
                        capabilities = lsp_capabilities,
                        keys = {
                            { "<leader>cR", "<cmd>ClangdSwitchSourceHeader<cr>", desc = "Switch Source/Header (C/C++)" },
                        },
                        root_dir = function(fname)
                            return require("lspconfig.util").root_pattern(
                                    "Makefile",
                                    "configure.ac",
                                    "configure.in",
                                    "config.h.in",
                                    "meson.build",
                                    "meson_options.txt",
                                    "build.ninja"
                                )(fname) or
                                require("lspconfig.util").root_pattern("compile_commands.json", "compile_flags.txt")(
                                    fname
                                ) or require("lspconfig.util").find_git_ancestor(fname)
                        end,
                        cmd = {
                            "clangd",
                            "--background-index",
                            "--clang-tidy",
                            "--header-insertion=iwyu",
                            "--completion-style=detailed",
                            "--function-arg-placeholders",
                            "--fallback-style=llvm",
                        },
                        init_options = {
                            usePlaceholders = true,
                            completeUnimported = true,
                            clangdFileStatus = true,
                        },
                    })
                end,

                -- Clangd (C/C++)
                ['lua_ls'] = function()
                    lspconfig.lua_ls.setup({
                        capabilities = lsp_capabilities,
                        settings = {
                            Lua = {
                                workspace = { checkThirdParty = false },
                                telemetry = { enable = false },
                                -- NOTE: toggle below to ignore Lua_LS's noisy `missing-fields` warnings
                                diagnostics = {
                                    globals = { "vim" },
                                    disable = { "missing-fields" }
                                },
                            },
                        },
                    })
                end
            }
        })

        -- Autoformat on Save
        vim.api.nvim_create_autocmd("BufWritePre", {
            callback = function(_)
                vim.lsp.buf.format { async = false }
            end
        })
    end,
}
