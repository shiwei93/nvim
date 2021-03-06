---@diagnostic disable: different-requires
local present, custom_packer = pcall(require, 'packer_install')

if not present then
  return false
end

local packer = custom_packer.packer
local use = packer.use

local config = require('config')

return packer.startup(function()
  use({
    'wbthomason/packer.nvim',
    'lewis6991/impatient.nvim',
    'nathom/filetype.nvim',
    'nvim-lua/plenary.nvim',
    'tpope/vim-surround',
    'terryma/vim-multiple-cursors',
  })

  -- theme
  require('theme.plugins').init(use)

  use({
    'glepnir/dashboard-nvim',
    config = function()
      require('plugins.dashboard')
    end,
  })

  use({
    'rcarriga/nvim-notify',
    config = function()
      require('plugins.notify')
    end,
    after = config.theme,
  })

  use({
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true },
    config = function()
      require('plugins.statusline')
    end,
    after = config.theme,
  })

  -- bufferline
  use({
    'akinsho/bufferline.nvim',
    require = { 'nvim-web-devicons', opt = true },
    opt = true,
    event = 'BufRead',
    config = function()
      require('plugins.buffer_line')
    end,
  })

  -- file explorer
  use({
    'kyazdani42/nvim-tree.lua',
    config = function()
      require('plugins.nvimtree')
    end,
    opt = true,
    cmd = {
      'NvimTreeClipboard',
      'NvimTreeClose',
      'NvimTreeFindFile',
      'NvimTreeOpen',
      'NvimTreeRefresh',
      'NvimTreeToggle',
    },
  })

  -- git column signs
  use({
    'lewis6991/gitsigns.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    opt = true,
    event = 'BufRead',
    config = function()
      require('plugins.gitsigns')
    end,
  })

  -- lang/syntax stuff
  use({
    'nvim-treesitter/nvim-treesitter',
    requires = {
      'windwp/nvim-ts-autotag',
      'JoosepAlviste/nvim-ts-context-commentstring',
      'nvim-treesitter/nvim-treesitter-refactor',
      'nvim-treesitter/nvim-tree-docs',
    },
    run = ':TSUpdate',
    config = function()
      require('plugins.treesitter')
    end,
  })

  use({
    'nvim-treesitter/nvim-treesitter-textobjects',
    after = 'nvim-treesitter',
  })

  -- highlight brackets
  use({
    'p00f/nvim-ts-rainbow',
    opt = true,
    after = 'nvim-treesitter',
    event = 'BufRead',
  })

  -- colorizer
  use({
    'norcalli/nvim-colorizer.lua',
    config = function()
      require('plugins.colorizer')
    end,
    opt = true,
    event = 'BufRead',
  })

  -- comments
  use({
    'numToStr/Comment.nvim',
    config = function()
      require('plugins.comments')
    end,
    event = 'BufWinEnter',
  })

  -- highlighting indent
  use({
    'lukas-reineke/indent-blankline.nvim',
    config = function()
      require('plugins.blankline')
    end,
    opt = true,
    event = 'BufRead',
  })

  -- todo highlights
  use({
    'folke/todo-comments.nvim',
    requires = 'nvim-lua/plenary.nvim',
    config = function()
      require('plugins.todo_comments')
    end,
    opt = true,
    event = 'BufWinEnter',
  })

  -- tools

  -- startuptime
  use({
    'dstein64/vim-startuptime',
    opt = true,
    cmd = 'StartupTime',
  })

  -- telescope
  -- for fuzzy finding
  use({
    'nvim-telescope/telescope.nvim',
    requires = {
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-lua/popup.nvim' },
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        run = 'make',
      },
    },
    config = function()
      require('plugins.telescope')
    end,
    event = 'BufWinEnter',
  })

  -- lsp
  use({
    'neovim/nvim-lspconfig',
    config = function()
      require('lsp')
    end,
    requires = {
      { 'b0o/SchemaStore.nvim' },
      { 'williamboman/nvim-lsp-installer' },
      { 'jose-elias-alvarez/nvim-lsp-ts-utils' },
      {
        'jose-elias-alvarez/null-ls.nvim',
        config = function()
          require('lsp.providers.null_ls')
        end,
        after = 'nvim-lspconfig',
      },
      {
        'ray-x/lsp_signature.nvim',
        config = function()
          require('plugins.lspsignature.init')
        end,
        after = 'nvim-lspconfig',
      },
    },
  })

  -- autocompletion
  use({
    'hrsh7th/nvim-cmp',
    config = function()
      require('plugins.nvim_cmp')
    end,
    requires = {
      {
        'L3MON4D3/LuaSnip',
        config = function()
          require('plugins.luasnip.init')
        end,
        requires = {
          'rafamadriz/friendly-snippets',
        },
      },
      { 'hrsh7th/cmp-nvim-lsp', after = 'nvim-cmp' },
      { 'saadparwaiz1/cmp_luasnip', after = 'nvim-cmp' },
      { 'hrsh7th/cmp-buffer', after = 'nvim-cmp' },
      { 'hrsh7th/cmp-nvim-lua', after = 'nvim-cmp' },
      { 'hrsh7th/cmp-path', after = 'nvim-cmp' },
      {
        'windwp/nvim-autopairs',
        config = function()
          require('plugins.auto_pairs')
        end,
        after = 'nvim-cmp',
      },
    },
    event = 'InsertEnter',
  })

  -- lsp code action
  use({
    'tami5/lspsaga.nvim',
    cmd = 'Lspsaga',
    config = function()
      require('plugins.saga')
    end,
  })

  -- term
  use({
    'akinsho/toggleterm.nvim',
    config = function()
      require('plugins.term')
    end,
    opt = true,
    event = 'BufWinEnter',
  })

  -- markdown previewer
  use({
    'davidgranstrom/nvim-markdown-preview',
    opt = true,
    config = function()
      require('plugins.markdown')
    end,
    cmd = 'MarkdownPreview',
  })

  -- which-key
  use({
    'folke/which-key.nvim',
    config = function()
      require('plugins.which_key')
    end,
    event = 'BufWinEnter',
  })

  -- Diffview
  use({
    'sindrets/diffview.nvim',
    requires = 'nvim-lua/plenary.nvim',
    opt = true,
    cmd = {
      'DiffviewOpen',
      'DiffviewFileHistory',
    },
    config = function()
      require('plugins.diffview')
    end,
  })

  -- neoscroll
  use({
    'karb94/neoscroll.nvim',
    event = 'BufWinEnter',
    disable = true,
    config = function()
      require('plugins.neoscroll')
    end,
  })

  if packer.first_install then
    packer.sync()
  end
end)
