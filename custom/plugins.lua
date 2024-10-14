local plugins = {{
  "williamboman/mason.nvim",
  opts = {
      ensure_installed = {"gopls", -- Go
      "pyright", -- Python
      -- Adicionando PHP aqui
      "intelephense", -- PHP LSP
      "php-cs-fixer", -- PHP Formatter
      "phpmd", -- PHP Linter
      "php-debug-adapter" -- PHP Debugger
      }
  }
}, {
  "mfussenegger/nvim-dap",
  init = function()
      require("core.utils").load_mappings("dap")
  end
}, {
  "dreamsofcode-io/nvim-dap-go",
  ft = "go",
  dependencies = "mfussenegger/nvim-dap",
  config = function(_, opts)
      require("dap-go").setup(opts)
      require("core.utils").load_mappings("dap_go")
  end
}, {
  "neovim/nvim-lspconfig",
  config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"

      require("lspconfig").pyright.setup {}
  end
}, {
  "jose-elias-alvarez/null-ls.nvim",
  ft = {"go", "python", "php"},
  opts = function()
      return require "custom.configs.null-ls"
  end
}, {
  "olexsmir/gopher.nvim",
  ft = "go",
  config = function(_, opts)
      require("gopher").setup(opts)
      require("core.utils").load_mappings("gopher")
  end,
  build = function()
      vim.cmd [[silent! GoInstallDeps]]
  end
}, {
  "akinsho/toggleterm.nvim",
  version = '*',
  config = function()
      require("toggleterm").setup {
          open_mapping = [[<c-\>]], -- Atalho para abrir/fechar o terminal
          direction = 'float' -- Terminal flutuante (pode ser 'horizontal' ou 'vertical')
      }
  end
}, {
  "wintermute-cell/gitignore.nvim", -- Adicionando o plugin gitignore.nvim
  config = function()
      require("gitignore")
  end
}, {
  'MeanderingProgrammer/render-markdown.nvim',
  dependencies = {'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim'},
  opts = {
      style = {
          code_block = {
              border = 'rounded' -- Set the border style for code blocks
          },
          heading = {
              highlight = 'Comment', -- Highlight headings with a specific style
              bold = true -- Enable bold headings
          },
          bullet_list = {
              highlight = 'Keyword' -- Set a highlight for bullet list items
          },
          numbered_list = {
              highlight = 'Keyword' -- Set a highlight for numbered list items
          },
          table = {
              border = 'single' -- Set the border style for tables
          }
      },
      -- Custom render functions for specific Markdown elements
      renderers = {
          code_block = function(language, content)
              -- Custom function to render code blocks differently based on language
              return string.format("```%s\n%s\n```", language, content)
          end,
          table = function(headers, rows)
              -- Custom rendering for tables
              return vim.fn.join(headers, " | ") .. "\n" .. vim.fn.join(rows, "\n")
          end
      },
      -- Key bindings to toggle and interact with the Markdown renderer
      keymaps = {
          toggle = "<leader>mr", -- Toggle the Markdown rendering on and off
          next_heading = "]h", -- Jump to the next heading
          prev_heading = "[h" -- Jump to the previous heading
      }
  },
  config = function(_, opts)
      require('render-markdown').setup(opts)
  end
}}
return plugins
