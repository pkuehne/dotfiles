-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
-- vim.cmd [[packadd packer.nvim]]

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
  use { 'tpope/vim-fugitive' }                        -- git integration
  use { 'junegunn/gv.vim' }                           -- commit history
  use { 
      'windwp/nvim-autopairs',                        -- auto close brackets, etc.
      config = function()
        require('nvim-autopairs').setup{}
      end
  }
end)

