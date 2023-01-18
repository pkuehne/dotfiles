-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
-- vim.cmd [[packadd packer.nvim]]

local function empty_config()

end

return require('packer').startup(function(use)
    use { -- Packer can manage itself
        'wbthomason/packer.nvim',
        config = empty_config,
    }
    use { -- filesystem navigation
        'kyazdani42/nvim-tree.lua',
        requires = 'kyazdani42/nvim-web-devicons', -- filesystem icons
        config = function()
            require('nvim-tree').setup()
        end
    }
    use { -- start screen
        'mhinz/vim-startify',
        config = empty_config,
    }
    use { -- cursor jump
        'DanilaMihailov/beacon.nvim',
        config = empty_config,
    }
    use { -- statusline
        'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons', opt = true },
        config = function()
            require('lualine').setup {
                options = {
                    theme = 'dracula-nvim'
                }
            }
        end
    }
    use { -- colorscheme
        'Mofiqul/dracula.nvim',
        config = function()
            vim.api.nvim_command('colorscheme dracula') -- Set colorscheme
        end
    }
    use { -- fuzzy finder
        'nvim-telescope/telescope.nvim',
        requires = { 'nvim-lua/plenary.nvim' },
        config = empty_config,
    }
    use { -- code structure
        'majutsushi/tagbar',
        config = empty_config,
    }
    use { -- see indentation
        'Yggdroot/indentLine',
        config = empty_config,
    }
    use { -- commit history
        'junegunn/gv.vim',
        config = empty_config,
    }
    use { -- auto close brackets, etc.
        'windwp/nvim-autopairs',
        config = function()
            require('nvim-autopairs').setup {}
        end
    }
    use { -- giT integration
        'tpope/vim-fugitive',
        config = empty_config,
    }
    use { -- comment toggle
        'tpope/vim-commentary',
        config = empty_config,
    }
    use { -- easily surround text
        'tpope/vim-surround',
        config = empty_config,
    }
    use { -- Make support
        'tpope/vim-dispatch',
        config = empty_config,
    }
    use { -- Session management
        'tpope/vim-obsession',
        config = empty_config,
    }
    use { -- LSP install manager
        "williamboman/mason.nvim",
        config = empty_config,
    }
    use { -- Mason/LSP integration
        "williamboman/mason-lspconfig.nvim",
        config = empty_config,
    }
    use { -- LSP Configuration and setup
        "neovim/nvim-lspconfig",
        config = function()
            require("mason").setup()
            require("mason-lspconfig").setup()
            require("mason-lspconfig").setup_handlers {
                -- default handler.
                function(server_name)
                    require("lspconfig")[server_name].setup {
                        on_attach = function(client, bufnr)
                            -- Enable completion triggered by <c-x><c-o>
                            vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

                            -- Mappings.
                            -- See `:help vim.lsp.*` for documentation on any of the below functions
                            local bufopts = { noremap = true, silent = true, buffer = bufnr }
                            vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
                            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
                            vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
                            vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
                            vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
                            vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
                            vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
                            vim.keymap.set('n', '<space>wl', function()
                                print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                            end, bufopts)
                            vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
                            vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
                            vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
                            vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
                            vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)
                            vim.api.nvim_create_autocmd("BufWritePre", {
                                buffer = bufnr,
                                callback = function()
                                    -- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
                                    vim.lsp.buf.format({ bufnr = bufnr })
                                end,
                            })
                        end
                    }
                end,
                -- Dedicated handlers
                -- ["rust_analyzer"] = function ()
                --     require("rust-tools").setup {}
                -- end
            }
        end
    }
    use { -- Linter using LSP
        "mfussenegger/nvim-lint",
        config = function()
            require('lint').linters_by_ft = {
                markdown = { 'markdownlint', }
            }
            vim.api.nvim_create_autocmd({ "BufWritePost", "BufRead" }, {
                callback = function()
                    require("lint").try_lint()
                end,
            })
        end
    }
    use { -- Runs common tasks
        'stevearc/overseer.nvim',
        config = function() require('overseer').setup() end
    }
    use { -- Tabs for buffers!
        'akinsho/bufferline.nvim',
        tag = "v3.*",
        requires = 'nvim-tree/nvim-web-devicons',
        config = function() require("bufferline").setup() end
    }
    use { -- Nicer notifications
        'rcarriga/nvim-notify',
        config = function()
            vim.notify = require("notify")
        end
    }
end)
