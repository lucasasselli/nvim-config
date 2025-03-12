return {

    -- Colorscheme
    {
        'RRethy/base16-nvim',
        config = function(_)
            vim.cmd('colorscheme base16-monokai')
        end,
    },

    -- -- Neotree (file explorer)
    -- {
    --     "nvim-neo-tree/neo-tree.nvim",
    --     branch = "v3.x",
    --     dependencies = {
    --         "nvim-lua/plenary.nvim",
    --         "MunifTanjim/nui.nvim",
    --     },
    --     config = function(_)
    --         vim.keymap.set('n', '<leader>t', "<cmd>Neotree toggle<cr>", { desc = "Open Neotree" })
    --         vim.api.nvim_create_user_command("E", "Neotree position=current <args>",
    --             { nargs = "?", complete = "dir" })
    --     end,
    -- },

    -- Telescope (file search)
    {
        'nvim-telescope/telescope.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' },
        keys = function()
            local builtin = require('telescope.builtin')
            return {
                { "<leader>ff", builtin.find_files,     desc = "Find files" },
                { "<leader>fh", builtin.oldfiles,       desc = "Find old files" },
                { "<leader>fg", builtin.live_grep,      desc = "Grep files" },
                { "<leader>fr", builtin.lsp_references, desc = "Find references" },
                { "<leader>e",  builtin.diagnostics,    desc = "Show errors" },
            }
        end,
        cmd = {
            "Telescope"
        },
        opts = {
            defaults = {
                layout_strategy = "horizontal",
                layout_config = { prompt_position = "top" },
                sorting_strategy = "ascending",
                winblend = 0,
            },
        },
    },


    {
        'alexghergh/nvim-tmux-navigation',
        config = function()
            local nvim_tmux_nav = require('nvim-tmux-navigation')

            nvim_tmux_nav.setup {
                disable_when_zoomed = true -- defaults to false
            }

            vim.keymap.set('n', "<C-h>", nvim_tmux_nav.NvimTmuxNavigateLeft)
            vim.keymap.set('n', "<C-j>", nvim_tmux_nav.NvimTmuxNavigateDown)
            vim.keymap.set('n', "<C-k>", nvim_tmux_nav.NvimTmuxNavigateUp)
            vim.keymap.set('n', "<C-l>", nvim_tmux_nav.NvimTmuxNavigateRight)
            vim.keymap.set('n', "<C-\\>", nvim_tmux_nav.NvimTmuxNavigateLastActive)
            vim.keymap.set('n', "<C-Space>", nvim_tmux_nav.NvimTmuxNavigateNext)
        end
    },

    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            require('lualine').setup()
        end
    },

    {
        'sindrets/diffview.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
    }

}
