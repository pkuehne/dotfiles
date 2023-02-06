local map = vim.api.nvim_set_keymap
local opts = { silent = true, noremap = true }

-- Function keys
map('n', '<F9>', ':NvimTreeToggle<CR>', opts)
map('n', '<F10>', ':TagbarToggle<CR>', opts)

-- Map Ctrl+hjkl to move between splits
map('n', '<C-H>', '<C-W><C-H>', opts)
map('n', '<C-J>', '<C-W><C-J>', opts)
map('n', '<C-K>', '<C-W><C-K>', opts)
map('n', '<C-L>', '<C-W><C-L>', opts)

-- Plugins --
-------------
-- Code actions - <leader>c? - Reserved in LSP

-- Telescope - <leader>f?
map('n', '<Leader>ff', ':Telescope find_files<CR>', opts)
map('n', '<Leader>fb', ':Telescope buffers<CR>', opts)

-- Git - <leader>g?
map('n', '<Leader>g', ':Git<CR>', opts)

-- Overseer - <leader>o?
map('n', '<Leader>or', ':OverseerRun<CR>', opts)
map('n', '<Leader>ot', ':OverseerToggle<CR>', opts)

-- Trouble - <leader>t?
map("n", "<leader>tt", "<cmd>TroubleToggle document_diagnostics<cr>", opts)
map("n", "<leader>tw", "<cmd>TroubleToggle workspace_diagnostics<cr>", opts)
map("n", "<leader>tl", "<cmd>TroubleToggle loclist<cr>", opts)

-- Worspace actions - <leader>w? - Reserved in LSP
