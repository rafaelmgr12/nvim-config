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
  dependencies = {'nvim-treesitter/nvim-treesitter', -- Treesitter for syntax highlighting
  'echasnovski/mini.nvim' -- Optional, mini.nvim for additional features
  },
  config = function()
      require('render-markdown').setup({
          -- Setup options for rendering
          style = {
              code_block = {
                  border = 'rounded', -- Customize the style of code blocks with rounded borders
                  background = '#1e1e1e', -- Set a background color for code blocks
                  padding = {1, 1} -- Padding around code blocks (top-bottom, left-right)
              },
              heading = {
                  highlight = 'Comment', -- Apply the Comment highlight group to headings
                  bold = true, -- Make headings bold
                  underline = true -- Underline headings
              },
              bullet_list = {
                  highlight = 'Keyword', -- Highlight for bullet lists using the Keyword highlight group
                  symbol = '•' -- Custom bullet symbol
              },
              numbered_list = {
                  highlight = 'Keyword', -- Highlight for numbered lists using the Keyword highlight group
                  format = '%d.' -- Numbered list format, e.g., '1.' or '1)'
              },
              table = {
                  border = 'single', -- Set single-line borders for tables
                  padding = {0, 1}, -- Padding around table cells (top-bottom, left-right)
                  header_highlight = 'Title', -- Highlight table headers
                  row_highlight = 'Normal' -- Highlight table rows
              },
              blockquote = {
                  border = 'double', -- Double border for blockquotes
                  highlight = 'Comment' -- Highlight blockquotes using the Comment highlight group
              }
          },
          renderers = {
              -- Custom rendering functions for different elements
              code_block = function(language, content)
                  return string.format("```%s\n%s\n```", language, content)
              end,
              table = function(headers, rows)
                  -- Custom rendering for tables
                  return vim.fn.join(headers, " | ") .. "\n" .. vim.fn.join(rows, "\n")
              end,
              heading = function(level, text)
                  -- Custom rendering for headings
                  return string.rep("#", level) .. " " .. text
              end,
              bullet_list_item = function(symbol, content)
                  -- Custom rendering for bullet list items
                  return string.format("%s %s", symbol, content)
              end,
              numbered_list_item = function(index, content)
                  -- Custom rendering for numbered list items
                  return string.format("%d. %s", index, content)
              end
          },
          keymaps = {
              toggle = "<leader>mr", -- Toggle Markdown rendering with Ctrl + Shift + V
              next_heading = "]h", -- Jump to the next heading
              prev_heading = "[h", -- Jump to the previous heading
              jump_table = "<leader>jt", -- Custom keybinding to jump between tables
              jump_code_block = "<leader>jc" -- Custom keybinding to jump between code blocks
          },
          autocommands = {
              enable = true, -- Enable autocommands for automatically rendering Markdown
              events = {"BufRead", "BufWritePost"} -- Trigger rendering on reading or writing a Markdown file
          },
          filetypes = {"markdown", "md"}, -- Filetypes to apply the Markdown rendering to
          performance = {
              throttle_rendering = 100 -- Throttle rendering updates to improve performance (in milliseconds)
          },
          hooks = {
              before_render = function()
                  -- Custom logic to run before rendering starts
                  print("Starting Markdown rendering...")
              end,
              after_render = function()
                  -- Custom logic to run after rendering completes
                  print("Markdown rendering complete.")
              end
          }
      })
  end
}, {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  config = function()
      require('nvim-treesitter.configs').setup {
          ensure_installed = {'markdown', 'markdown_inline'}, -- Ensure markdown support is enabled
          highlight = {
              enable = true -- Enable Treesitter highlighting
          }
      }
  end
}, {
  'iamcco/markdown-preview.nvim',
  build = function()
      vim.fn['mkdp#util#install']() -- Build the plugin on installation
  end,
  ft = {'markdown', 'md'}, -- Load for Markdown files
  config = function()
      -- Customize markdown-preview.nvim
      vim.g.mkdp_auto_start = 0 -- Don't auto-start preview when opening a Markdown file
      vim.g.mkdp_auto_close = 1 -- Auto-close preview when closing the Markdown buffer
      vim.g.mkdp_refresh_slow = 0 -- Refresh as you type
      vim.g.mkdp_command_for_global = 0 -- Use browser commands locally instead of globally
      vim.g.mkdp_browser = '' -- Let the plugin pick the default browser
      vim.g.mkdp_open_to_the_world = 0 -- Open in the local network (set 1 to access from other devices)
      vim.g.mkdp_open_ip = '127.0.0.1' -- Only local IP for opening
      vim.g.mkdp_preview_options = {
          mkit = {}, -- Markdown-it options
          katex = {}, -- KaTeX options for rendering math
          uml = {}, -- PlantUML options
          maid = {}, -- Mermaid options for diagrams
          disable_sync_scroll = 0, -- Disable synchronized scrolling between preview and editor
          sync_scroll_type = 'middle', -- How scroll synchronization works
          hide_yaml_meta = 1, -- Hide YAML metadata in the preview
          sequence_diagrams = {}, -- Sequence diagram options
          flowchart_diagrams = {}, -- Flowchart options
          content_editable = false, -- Enable content editing in the preview window
          disable_filename = 0 -- Display the filename in the preview window
      }
      vim.g.mkdp_markdown_css = '' -- Custom CSS for Markdown preview
      vim.g.mkdp_highlight_css = '' -- Custom CSS for code highlighting
      vim.g.mkdp_port = '8080' -- Port for the preview server
  end,
  keys = {{
      '<leader>mp',
      ':MarkdownPreview<CR>',
      desc = "Start Markdown Preview"
  }, -- Start Markdown Preview with <leader>mp
  {
      '<leader>ms',
      ':MarkdownPreviewStop<CR>',
      desc = "Stop Markdown Preview"
  }, -- Stop Markdown Preview with <leader>ms
  {
      '<leader>mt',
      ':MarkdownPreviewToggle<CR>',
      desc = "Toggle Markdown Preview"
  } -- Toggle Markdown Preview with <leader>mt
  }
}}
return plugins
