local opt = vim.opt
local api = vim.api

opt.colorcolumn = '80' -- Highlight column 80
opt.number = true -- Show line numbers
opt.relativenumber = true -- Show relative numbers
opt.termguicolors = true -- Use terminal colors
opt.syntax = 'on' -- Enable syntax highlighting
opt.tabstop = 4 -- Tabs are 4 spaces wide
opt.softtabstop = 4 -- Soft tabs are 4 spaces
opt.shiftwidth = 4 -- How many spaces to delete for indents
opt.expandtab = true -- Soft tabs!
opt.signcolumn = 'yes' -- Show sign column
opt.encoding = 'utf8' -- Default encoding to use
opt.fileencoding = 'utf8' -- File encoding to use
opt.ignorecase = true -- Search without case by default
opt.smartcase = true -- Search with case if using Capital letter
opt.incsearch = true -- Use incremental search
opt.hlsearch = true -- Highlight search matches
opt.splitright = true -- Place new windows to the right
opt.splitbelow = true -- Place new windows to the bottom
opt.completeopt = { 'menuone', 'noselect', 'noinsert' }
opt.shortmess = vim.opt.shortmess + { c = true }
api.nvim_set_option('updatetime', 300)

opt.completeopt = { 'menuone', 'noselect', 'noinsert' }
opt.shortmess = vim.opt.shortmess + { c = true }
api.nvim_set_option('updatetime', 300)

vim.cmd([[
set signcolumn=yes
autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })
]])

api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    command = "set fo+=a"
})
