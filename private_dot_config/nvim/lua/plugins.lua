-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
-- vim.cmd [[packadd packer.nvim]]

function Empty_config()
end

function Lsp_on_attach(client, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set('n', '<leader>cD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', '<leader>cd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', '<leader>ci', vim.lsp.buf.implementation, bufopts)
    vim.keymap.set('n', '<leader>ct', vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, bufopts)
    vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
    vim.keymap.set('n', '<leader>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bufopts)
    vim.keymap.set('n', '<leader>crn', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
    vim.keymap.set('n', '<leader>cr', vim.lsp.buf.references, bufopts)
    vim.keymap.set('n', '<leader>cf', function() vim.lsp.buf.format { async = true } end, bufopts)
    if client.server_capabilities.document_formatting then
        vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            callback = function()
                vim.lsp.buf.format({ bufnr = bufnr })
            end,
        })
    end
end

function Autocomplete_config()
    local cmp = require 'cmp'
    cmp.setup({
        -- Enable LSP snippets
        snippet = {
            expand = function(args)
                vim.fn["vsnip#anonymous"](args.body)
            end,
        },
        mapping = {
            ['<C-p>'] = cmp.mapping.select_prev_item(),
            ['<C-n>'] = cmp.mapping.select_next_item(),
            -- Add tab support
            ['<S-Tab>'] = cmp.mapping.select_prev_item(),
            ['<Tab>'] = cmp.mapping.select_next_item(),
            ['<C-S-f>'] = cmp.mapping.scroll_docs(-4),
            ['<C-f>'] = cmp.mapping.scroll_docs(4),
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<C-e>'] = cmp.mapping.close(),
            ['<CR>'] = cmp.mapping.confirm({
                behavior = cmp.ConfirmBehavior.Insert,
                select = true,
            })
        },
        -- Installed sources:
        sources = {
            { name = 'path' }, -- file paths
            { name = 'nvim_lsp', keyword_length = 3 }, -- from language server
            { name = 'nvim_lsp_signature_help' }, -- display function signatures with current parameter emphasized
            { name = 'nvim_lua', keyword_length = 2 }, -- complete neovim's Lua runtime API such vim.lsp.*
            { name = 'buffer', keyword_length = 2 }, -- source current buffer
            { name = 'vsnip', keyword_length = 2 }, -- nvim-cmp source for vim-vsnip
            { name = 'calc' }, -- source for math calculation
        },
        window = {
            completion = cmp.config.window.bordered(),
            documentation = cmp.config.window.bordered(),
        },
        formatting = {
            fields = { 'menu', 'abbr', 'kind' },
            format = function(entry, item)
                local menu_icon = {
                    nvim_lsp = 'λ',
                    vsnip = '⋗',
                    buffer = 'Ω',
                    path = '🖫',
                }
                item.menu = menu_icon[entry.source.name]
                return item
            end,
        },
    })
end

function Treesitter_config()
    require('nvim-treesitter.configs').setup {
        ensure_installed = { "bash", "lua", "vim", "help", "comment", "python", "vue", "rust", "typescript" },
        sync_install = false,
        auto_install = false,
        highlight = {
            -- `false` will disable the whole extension
            enable = true,
        }
    }
end

return require('packer').startup(function(use)
    use { -- Packer can manage itself
        'wbthomason/packer.nvim',
        config = Empty_config,
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
        config = Empty_config,
    }
    use { -- cursor jump
        'DanilaMihailov/beacon.nvim',
        config = Empty_config,
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
        config = Empty_config,
    }
    use { -- code structure
        'majutsushi/tagbar',
        config = Empty_config,
    }
    use { -- see indentation
        'Yggdroot/indentLine',
        config = Empty_config,
    }
    use { -- commit history
        'junegunn/gv.vim',
        config = Empty_config,
    }
    use { -- auto close brackets, etc.
        'windwp/nvim-autopairs',
        config = function()
            require('nvim-autopairs').setup {}
        end
    }
    use { -- git integration
        'tpope/vim-fugitive',
        config = Empty_config,
    }
    use { -- comment toggle
        'tpope/vim-commentary',
        config = Empty_config,
    }
    use { -- easily surround text
        'tpope/vim-surround',
        config = Empty_config,
    }
    use { -- Session management
        'tpope/vim-obsession',
        config = Empty_config,
    }
    use { -- Rust LSP support
        'simrat39/rust-tools.nvim',
        config = function()
        end
    }
    use { -- LSP install manager
        "williamboman/mason.nvim",
        config = Empty_config,
    }
    use { -- Mason/LSP integration
        "williamboman/mason-lspconfig.nvim",
        config = Empty_config,
    }
    use { -- LSP Configuration and setup
        "neovim/nvim-lspconfig",
        config = function()
            require("mason").setup({
                ui = {
                    icons = {
                        package_installed = "✓",
                        package_pending = "➜",
                        package_uninstalled = "✗",
                    },
                },
            })
            require("mason-lspconfig").setup()
            require("mason-lspconfig").setup_handlers {
                -- default handler.
                function(server_name)
                    require("lspconfig")[server_name].setup {
                        on_attach = Lsp_on_attach,
                    }
                end,
                -- Dedicated handlers
                ["rust_analyzer"] = function()
                    require("rust-tools").setup({
                        server = {
                            on_attach = Lsp_on_attach
                        }
                    })
                end,
                ["sumneko_lua"] = function()
                    require("lspconfig")["sumneko_lua"].setup {
                        on_attach = Lsp_on_attach,
                        settings = {
                            Lua = {
                                diagnostics = {
                                    globals = { "vim" }
                                }
                            }
                        }
                    }
                end,
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
        config = function() vim.notify = require("notify") end
    }
    use { -- Autocomplete
        'hrsh7th/nvim-cmp',
        requires = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-nvim-lua',
            'hrsh7th/cmp-nvim-lsp-signature-help',
            'hrsh7th/cmp-vsnip',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-buffer',
            'hrsh7th/vim-vsnip',
        },
        config = Autocomplete_config,
    }
    use {
        "folke/trouble.nvim",
        requires = "nvim-tree/nvim-web-devicons",
        config = function() require("trouble").setup {} end
    }
    use {
        'nvim-treesitter/nvim-treesitter',
        run = function()
            local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
            ts_update()
        end,
        config = Treesitter_config,
    }
end)
