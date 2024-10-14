local plugins = {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "gopls",            -- Go
        "pyright",          -- Python
        -- Adicionando PHP aqui
        "intelephense",     -- PHP LSP
        "php-cs-fixer",     -- PHP Formatter
        "phpmd",            -- PHP Linter
        "php-debug-adapter" -- PHP Debugger
      },
    },
  },
  {
    "mfussenegger/nvim-dap",
    init = function()
      require("core.utils").load_mappings("dap")
    end
  },
  {
    "dreamsofcode-io/nvim-dap-go",
    ft = "go",
    dependencies = "mfussenegger/nvim-dap",
    config = function(_, opts)
      require("dap-go").setup(opts)
      require("core.utils").load_mappings("dap_go")
    end
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"

      require("lspconfig").pyright.setup{}
    end,
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    ft = { "go", "python", "php" },
    opts = function()
      return require "custom.configs.null-ls"
    end,
  },
  {
    "olexsmir/gopher.nvim",
    ft = "go",
    config = function(_, opts)
      require("gopher").setup(opts)
      require("core.utils").load_mappings("gopher")
    end,
    build = function()
      vim.cmd [[silent! GoInstallDeps]]
    end,
  },
  {
    "akinsho/toggleterm.nvim",
    version = '*',
    config = function()
      require("toggleterm").setup{
        open_mapping = [[<c-\>]],  -- Atalho para abrir/fechar o terminal
        direction = 'float',       -- Terminal flutuante (pode ser 'horizontal' ou 'vertical')
      }
    end
  },
  {
    "wintermute-cell/gitignore.nvim", -- Adicionando o plugin gitignore.nvim
    config = function()
      require("gitignore")
    end
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
  
},
}
return plugins
