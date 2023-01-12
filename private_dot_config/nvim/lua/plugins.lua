-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
-- vim.cmd [[packadd packer.nvim]]

local vim = vim

return require('packer').startup(function(use)
  -- Packer can manage itself
  use { 'wbthomason/packer.nvim' }
  use {
      'kyazdani42/nvim-tree.lua',                     -- filesystem navigation
      requires = 'kyazdani42/nvim-web-devicons',      -- filesystem icons
      config = function()
        require('nvim-tree').setup()
      end
  }
  use { 'mhinz/vim-startify' }                       -- start screen
  use { 'DanilaMihailov/beacon.nvim' }               -- cursor jump
  use {
      'nvim-lualine/lualine.nvim',                   -- statusline
      requires = {'kyazdani42/nvim-web-devicons', opt = true},
      config = function()
        require('lualine').setup{
          options = {
            theme = 'dracula-nvim'
          }
        }
      end
  }
  use {
      'Mofiqul/dracula.nvim',                         -- colorscheme
      config = function()
        local cmd = vim.api.nvim_command
        cmd('colorscheme dracula')    -- Set colorscheme
      end
  }
  use {
      'nvim-telescope/telescope.nvim',                 -- fuzzy finder
      requires = { 'nvim-lua/plenary.nvim' }
  }
	use { 'majutsushi/tagbar' }                         -- code structure
  use { 'Yggdroot/indentLine' }                       -- see indentation
  use { 'junegunn/gv.vim' }                           -- commit history
  use {
      'windwp/nvim-autopairs',                        -- auto close brackets, etc.
      config = function()
        require('nvim-autopairs').setup{}
      end
  }
  use { 'tpope/vim-fugitive' }                        -- git integration
  use { 'tpope/vim-commentary' }                    -- comment toggle
  use { 'tpope/vim-surround' }                      -- easily surround text
  use { 'tpope/vim-dispatch' }                      -- Make support
  use { "williamboman/mason.nvim" }
  use { "williamboman/mason-lspconfig.nvim" }
  use {
        "neovim/nvim-lspconfig",
        config = function()
            require("mason").setup()
            require("mason-lspconfig").setup()
            require("mason-lspconfig").setup_handlers {
                -- default handler.
                function (server_name)
                    require("lspconfig")[server_name].setup {
                        on_attach = function(_, bufnr)
                            -- Enable completion triggered by <c-x><c-o>
                            vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

                            -- Mappings.
                            -- See `:help vim.lsp.*` for documentation on any of the below functions
                            local bufopts = { noremap=true, silent=true, buffer=bufnr }
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
  use {
        "mfussenegger/nvim-lint",
        config = function()
            require('lint').linters_by_ft = {
                markdown = {'markdownlint',}
            }
            vim.api.nvim_create_autocmd({ "BufWritePost", "BufRead" }, {
                callback = function()
                    require("lint").try_lint()
                end,
            })
        end
  }
end)

