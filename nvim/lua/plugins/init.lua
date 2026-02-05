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
    { src = "https://github.com/neovim/nvim-lspconfig" },
    { src = "https://github.com/williamboman/mason.nvim" },
    { src = "https://github.com/hrsh7th/nvim-cmp" },
    { src = "https://github.com/hrsh7th/cmp-nvim-lsp" },
    { src = "https://github.com/hrsh7th/cmp-buffer" },
    { src = "https://github.com/supermaven-inc/supermaven-nvim" },
    { src = "https://github.com/dnlhc/glance.nvim" },

    -- Treesitter
    { src = "https://github.com/nvim-treesitter/nvim-treesitter" },

    -- Git
    { src = "https://github.com/lewis6991/gitsigns.nvim" },
    { src = "https://github.com/tpope/vim-fugitive" },

    -- UI
    { src = "https://github.com/folke/which-key.nvim" },
    { src = "https://github.com/sphamba/smear-cursor.nvim" },

    -- Editing
    { src = "https://github.com/nvim-mini/mini.surround" },

    -- AI
    { src = "https://github.com/folke/snacks.nvim" },
    { src = "https://github.com/NickvanDyke/opencode.nvim" },
    { src = "https://github.com/ThePrimeagen/99" },

    { src = "https://github.com/datsfilipe/vesper.nvim" },
})

vim.cmd("packloadall")

require("plugins.icons")
require("plugins.telescope")
require("plugins.oil")
require("plugins.harpoon")
require("plugins.flash")
require("plugins.treesitter")
require("plugins.lsp")
require("plugins.completion")
require("plugins.git")
require("plugins.whichkey")
require("plugins.ui")
require("plugins.surround")
require("plugins.opencode")
require("plugins.99")
