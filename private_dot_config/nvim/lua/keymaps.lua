local map = vim.api.nvim_set_keymap

map('n', '<F9>',          ':NvimTreeToggle<CR>', {})
map('n', '<F10>',         ':TagbarToggle<CR>', {})
map('n', '<Leader>l',     ':IndentLinesToggle<CR>', {})
map('n', '<Leader>ff',    ':Telescope find_files<CR>', {})
