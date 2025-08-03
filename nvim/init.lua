-- Leader key
vim.g.mapleader = " "

-- Options
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wrap = false
vim.opt.tabstop = 4
vim.opt.swapfile = false
vim.opt.syntax = "enable"
vim.opt.termguicolors = true
vim.opt.winborder = "rounded"
vim.opt.list = true
vim.opt.listchars = "tab:..,trail:.,nbsp:_,space:·"
vim.opt.scrolloff = 20
vim.opt.clipboard = "unnamedplus"
vim.opt.signcolumn = 'yes'
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.undofile = true

-- Plugins
vim.pack.add({
	{ src = "https://github.com/namrabtw/rusty.nvim" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/echasnovski/mini.pick" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/williamboman/mason.nvim" },
	{ src = "https://github.com/lewis6991/gitsigns.nvim" },
	{ src = "https://github.com/hrsh7th/nvim-cmp" },
	{ src = "https://github.com/hrsh7th/cmp-nvim-lsp" },
	{ src = "https://github.com/hrsh7th/cmp-buffer" },
	{ src = "https://github.com/folke/flash.nvim" },
})

vim.cmd('packloadall')

-- Plugin configuration
require("mini.pick").setup()
require("oil").setup()
require("mason").setup()
require("gitsigns").setup({
	current_line_blame = true,
})

require("flash").setup({
	labels = "asdfghjklqwertyuiopzxcvbnm",
	search = {
		multi_window = true,
		forward = true,
	},
	jump = {
		jumplist = true,
		pos = "start",
		history = false,
		register = false,
	},
	modes = {
		search = {
			enabled = true,
		},
		char = {
			enabled = true,
			jump_labels = true,
		},
	},
})

local cmp = require('cmp')
cmp.setup({
	completion = {
		autocomplete = { cmp.TriggerEvent.TextChanged },
	},
	sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
		{ name = 'buffer' },
	}),
	mapping = cmp.mapping.preset.insert({
		['<Tab>'] = cmp.mapping.select_next_item(),
		['<S-Tab>'] = cmp.mapping.select_prev_item(),
		['<CR>'] = cmp.mapping.confirm({ select = true }),
		['<C-Space>'] = cmp.mapping.complete(),
	}),
})

-- LSP setup
local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()

lspconfig.lua_ls.setup({ capabilities = capabilities })
lspconfig.ts_ls.setup({ capabilities = capabilities })
lspconfig.eslint.setup({ capabilities = capabilities })
lspconfig.clangd.setup({ capabilities = capabilities })

-- General keymaps
vim.keymap.set('n', '<leader>o', ':update<CR> :source<CR>')
vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format)

-- File navigation
vim.keymap.set('n', '<leader>pf', ":Pick files<CR>")
vim.keymap.set('n', '<leader>pg', ":Pick files tool='git'<CR>")
vim.keymap.set('n', '<leader>h', ":Pick help<CR>")
vim.keymap.set('n', '<leader>e', ":Oil<CR>")

-- Movement
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')

-- Visual mode
vim.keymap.set("v", "<leader>rn", "\"hy:%s/<C-r>h//g<left><left>")
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set('v', '<', '<gv')
vim.keymap.set('v', '>', '>gv')

-- Window management
vim.keymap.set('n', '<C-Up>', ':resize +2<CR>')
vim.keymap.set('n', '<C-Down>', ':resize -2<CR>')
vim.keymap.set('n', '<C-Left>', ':vertical resize -2<CR>')
vim.keymap.set('n', '<C-Right>', ':vertical resize +2<CR>')
vim.keymap.set('n', '<C-h>', '<C-w>h')
vim.keymap.set('n', '<C-j>', '<C-w>j')
vim.keymap.set('n', '<C-k>', '<C-w>k')
vim.keymap.set('n', '<C-l>', '<C-w>l')

-- Flash navigation
vim.keymap.set({ "n", "x", "o" }, "s", function() require("flash").jump() end)
vim.keymap.set({ "n", "x", "o" }, "S", function() require("flash").treesitter() end)
vim.keymap.set({ "o", "x" }, "r", function() require("flash").treesitter_search() end)
vim.keymap.set({ "c" }, "<c-s>", function() require("flash").toggle() end)

-- Terminal
vim.keymap.set('n', '<leader>tf', function()
	local buf = vim.api.nvim_create_buf(false, true)
	local width = math.floor(vim.o.columns * 0.8)
	local height = math.floor(vim.o.lines * 0.8)
	local row = math.floor((vim.o.lines - height) / 2)
	local col = math.floor((vim.o.columns - width) / 2)

	vim.api.nvim_open_win(buf, true, {
		relative = 'editor',
		width = width,
		height = height,
		row = row,
		col = col,
		style = 'minimal',
		border = 'rounded',
	})

	vim.cmd('terminal')
	vim.cmd('startinsert')
end)

-- Autocmds
vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(ev)
		local opts = { buffer = ev.buf }
		vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
		vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
		vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, opts)
		vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
		vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
		vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)
	end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
	callback = function()
		vim.lsp.buf.format()
	end,
})

vim.api.nvim_create_autocmd('VimEnter', {
	callback = function()
		local root_markers = { '.git', 'package.json', 'Cargo.toml', 'go.mod' }
		local root = vim.fs.dirname(vim.fs.find(root_markers, { upward = true })[1])
		if root then vim.cmd('cd ' .. root) end
	end
})

vim.api.nvim_create_autocmd({ 'FocusLost', 'BufLeave' }, {
	callback = function()
		if vim.bo.modified and vim.bo.buftype == '' then
			vim.cmd('silent! write')
		end
	end
})

-- Colorscheme
vim.cmd("colorscheme rusty")

-- Cheatsheet function
local function show_cheatsheet()
	local cheatsheet = {
		"━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━",
		"                              🚀 NEOVIM CHEATSHEET 🚀                              ",
		"━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━",
		"",
		"📁 FILE NAVIGATION",
		"  <leader>pf     Pick files",
		"  <leader>pg     Pick git files",
		"  <leader>h      Pick help",
		"  <leader>e      Oil file explorer",
		"",
		"⚡ FLASH NAVIGATION",
		"  s              Flash jump anywhere",
		"  S              Flash treesitter (functions, classes)",
		"  r              Flash treesitter search",
		"  <C-s>          Toggle flash in search mode",
		"",
		"🔧 GENERAL",
		"  <leader>o      Update & source config",
		"  <leader>lf     Format buffer",
		"  <leader>tf     Floating terminal",
		"",
		"🚀 MOVEMENT",
		"  <C-d>          Page down (centered)",
		"  <C-u>          Page up (centered)",
		"",
		"👁️ VISUAL MODE",
		"  <leader>rn     Search/replace selection",
		"  J              Move selection down",
		"  K              Move selection up",
		"  <              Indent left (stay in visual)",
		"  >              Indent right (stay in visual)",
		"",
		"🪟 WINDOW MANAGEMENT",
		"  <C-h/j/k/l>    Navigate windows",
		"  <C-↑/↓/←/→>    Resize windows",
		"",
		"🔍 LSP (when attached)",
		"  K              Hover info",
		"  gd             Go to definition",
		"  <leader>d      Show diagnostics",
		"  ]d / [d        Next/prev diagnostic",
		"  <leader>q      Diagnostics list",
		"",
		"💡 COMPLETION",
		"  <Tab>          Next completion",
		"  <S-Tab>        Previous completion",
		"  <CR>           Confirm completion",
		"  <C-Space>      Trigger completion",
		"",
		"━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━",
		"                              Press 'q' or <Esc> to close                              ",
		"━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━",
	}

	-- Create buffer
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, cheatsheet)
	vim.api.nvim_buf_set_option(buf, 'modifiable', false)
	vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')

	-- Calculate window size
	local width = 80
	local height = #cheatsheet + 2
	local row = math.floor((vim.o.lines - height) / 2)
	local col = math.floor((vim.o.columns - width) / 2)

	-- Create window
	local win = vim.api.nvim_open_win(buf, true, {
		relative = 'editor',
		width = width,
		height = height,
		row = row,
		col = col,
		style = 'minimal',
		border = 'rounded',
		title = ' Cheatsheet ',
		title_pos = 'center',
	})

	vim.api.nvim_win_set_option(win, 'winhl', 'Normal:Normal,FloatBorder:FloatBorder')

	vim.api.nvim_buf_set_keymap(buf, 'n', 'q', ':close<CR>', { noremap = true, silent = true })
	vim.api.nvim_buf_set_keymap(buf, 'n', '<Esc>', ':close<CR>', { noremap = true, silent = true })
end

-- Command to show cheatsheet
vim.api.nvim_create_user_command('Cheatsheet', show_cheatsheet, {})

-- Keymap to show cheatsheet
vim.keymap.set('n', '<leader>?', show_cheatsheet, { desc = 'Show cheatsheet' })
