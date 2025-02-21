vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- relative line numbers for easier nav
vim.opt.number = true
vim.opt.relativenumber = true

-- spaces instead of tabs
vim.opt.expandtab = true

-- we are not in 1950 use color B)
vim.opt.syntax = "enable"
vim.opt.termguicolors = true

-- smart indent 
vim.opt.smartindent = true
vim.opt.autoindent = true

-- line wrapping so we dont scroll vertically
vim.opt.wrap = true

-- Ignore case if the search pattern is all lowercase, be case-sensitive otherwise
vim.opt.smartcase = true
vim.opt.ignorecase = true

-- list all chars like spaces, tabs, whitespaces and etc.
vim.opt.list = true
vim.opt.listchars = "tab:.>,trail:.,nbsp:_,space:·"

-- always have at least 20 rows visible
vim.opt.scrolloff = 20

-- use same copy paste buffer as system
vim.opt.clipboard = "unnamedplus"

vim.opt.signcolumn = 'yes'

-- if it's a js related use 4, instead of 8
vim.api.nvim_create_autocmd({"FileType"}, {
        pattern = {"javascript", "typescript", "typescriptreact", "javascriptreact"},
        callback = function()
                vim.opt.tabstop = 4
                vim.opt.shiftwidth = 4
                vim.opt.softtabstop = 4
        end,
})

require("nvim-tree").setup({
        view={
                side="left"
        }
})

require("gitsigns").setup {
        current_line_blame = true,
}

require('nightfox').setup({
        options = {
                styles = {
                        comments = "italic",
                        keywords = "bold",
                       types = "italic,bold",
              }
     }
})


require'nvim-treesitter.configs'.setup {
        ensure_installed = { "c", "lua", "vim", "vimdoc", "javascript","typescript", "markdown", "markdown_inline" },

        sync_install = false,

        auto_install = true,

        highlight = {
                enable = true
        },
}

-- Reserve a space in the gutter
-- This will avoid an annoying layout shift in the screen
vim.opt.signcolumn = 'yes'

vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
        -- colorscheme 
        use "EdenEast/nightfox.nvim"
        use "ashen-org/ashen.nvim"
        use 'cryptomilk/nightcity.nvim'

        -- status bar
        use({
                "arsham/arshamiser.nvim",
                requires = {
                        "arsham/arshlib.nvim",
                        "famiu/feline.nvim",
                        "rebelot/heirline.nvim",
                        "kyazdani42/nvim-web-devicons",
                        "lewis6991/gitsigns.nvim",
                },
                config = function()
                        require("arshamiser.feliniser")
                        vim.cmd("colorscheme nordfox")
                        --vim.cmd("colorscheme ashen")
                        --vim.cmd.colorscheme('nightcity')

                        _G.custom_foldtext = require("arshamiser.folding").foldtext
                        vim.opt.foldtext = "v:lua.custom_foldtext()"

                        vim.api.nvim_set_option("tabline", [[%{%v:lua.require("arshamiser.tabline").draw()%}]])
                end,
        })

        -- nvim v0.7.2
        use({
                "kdheepak/lazygit.nvim",
                -- optional for floating window border decoration
                requires = {
                        "nvim-lua/plenary.nvim",
                },
        })

        -- telescope 
        use {
                'nvim-telescope/telescope.nvim', tag = '0.1.8',
                requires = { {'nvim-lua/plenary.nvim'} }
        }

        -- git blame line changes
        use "lewis6991/gitsigns.nvim"

        -- treesitter
        use(
        "nvim-treesitter/nvim-treesitter", {run = ":TSUpdate"}
        )

        -- :TSPlaygroundToggle get ast 
        use "nvim-treesitter/playground"

        use "theprimeagen/harpoon"

        use "mbbill/undotree"
        use({'neovim/nvim-lspconfig'})
        use({'hrsh7th/nvim-cmp'})
        use({'hrsh7th/cmp-nvim-lsp'})

        use {
                'nvim-tree/nvim-tree.lua',
                requires = {
                        'nvim-tree/nvim-web-devicons', -- optional
                },
        }

        use {
                'VonHeikemen/lsp-zero.nvim',
                branch = 'v2.x',
                requires = {
                        {'neovim/nvim-lspconfig'},
                        {'williamboman/mason.nvim'},
                        {'williamboman/mason-lspconfig.nvim'},
                        {'hrsh7th/nvim-cmp'},
                        {'hrsh7th/cmp-buffer'},
                        {'hrsh7th/cmp-path'},
                        {'saadparwaiz1/cmp_luasnip'},
                        {'hrsh7th/cmp-nvim-lsp'},
                        {'hrsh7th/cmp-nvim-lua'},
                        {'rafamadriz/friendly-snippets'},
                        {'L3MON4D3/LuaSnip'},
                }
        }
end)
