require("core.options")
require("core.keymaps")
require("core.autocmds")

-- Bootstrap plugins using Neovim's native package manager.
-- Wrapped in VimEnter because vim.pack is sometimes not yet available
-- at the very top level in some 0.12-dev builds.
vim.api.nvim_create_autocmd("VimEnter", {
    once = true,
    callback = function()
        vim.pack.add({
            -- Core
            { src = "https://github.com/nvim-lua/plenary.nvim" },
            { src = "https://github.com/nvim-tree/nvim-web-devicons" },

            -- Navigation
            { src = "https://github.com/nvim-telescope/telescope.nvim" },
            { src = "https://github.com/stevearc/oil.nvim" },
            { src = "https://github.com/ThePrimeagen/harpoon" },
            { src = "https://github.com/folke/flash.nvim" },

            -- LSP & Completion
            { src = "https://github.com/neovim/nvim-lspconfig", version = "v2.9.0" },
            { src = "https://github.com/williamboman/mason.nvim" },
            { src = "https://github.com/hrsh7th/nvim-cmp" },
            { src = "https://github.com/hrsh7th/cmp-nvim-lsp" },
            { src = "https://github.com/hrsh7th/cmp-buffer" },

            { src = "https://github.com/dnlhc/glance.nvim" },

            -- Treesitter
            { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },

            -- Git
            { src = "https://github.com/lewis6991/gitsigns.nvim" },
            { src = "https://github.com/tpope/vim-fugitive" },

            -- UI
            { src = "https://github.com/folke/which-key.nvim" },
            { src = "https://github.com/sphamba/smear-cursor.nvim" },
            { src = "https://github.com/ember-theme/nvim", name = "ember" },

            -- Editing
            { src = "https://github.com/nvim-mini/mini.surround" },
        })

        vim.cmd("packloadall")

        require("plugins")
    end,
})
