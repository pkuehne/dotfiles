local map = vim.api.nvim_set_keymap

map('n', '<F9>',            ':NvimTreeToggle<CR>', {})
map('n', '<F10>',           ':TagbarToggle<CR>', {})

-- Basic leader commands
map('n', '<Leader>l',       ':lua require("lint").try_lint()<CR>', {})
map('n', '<Leader>f',       ':Telescope find_files<CR>', {})
map('n', '<Leader>b',       ':Telescope buffers<CR>', {})
map('n', '<Leader>g',       ':Git<CR>', {})
map('n', '<Leader>r',       ':OverseerRun<CR>', {})
map('n', '<Leader>o',       ':OverseerToggle<CR>', {})

-- Map Ctrl+hjkl to move between splits
map('n', '<C-H>',           '<C-W><C-H>', {})
map('n', '<C-J>',           '<C-W><C-J>', {})
map('n', '<C-K>',           '<C-W><C-K>', {})
map('n', '<C-L>',           '<C-W><C-L>', {})

