local null_ls = require("null-ls")
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

local opts = {
  sources = {
    -- Formatadores para Go
    null_ls.builtins.formatting.gofumpt,
    null_ls.builtins.formatting.goimports_reviser,
    null_ls.builtins.formatting.golines,

    -- Formatadores e linters para Python
    null_ls.builtins.diagnostics.mypy,      -- Linting para Python com Mypy
    null_ls.builtins.formatting.autopep8,   -- Formatação para Python com autopep8
    null_ls.builtins.diagnostics.pylint,    -- Linting para Python com Pylint

    -- Formatadores e linters para PHP
    null_ls.builtins.formatting.stylua.with({
      command = "/usr/local/bin/php-cs-fixer",  -- Caminho correto do PHP CS Fixer
      args = { "fix", "--rules=@PSR12", "$FILENAME" }, -- Argumentos para o PHP CS Fixer
    }),
    null_ls.builtins.diagnostics.phpmd.with({
      command = "phpmd",
      args = { "$FILENAME", "text", "/path/to/ruleset.xml" },  -- Substitua pelo caminho correto do ruleset do PHP MD
    }),
  },
  on_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
      vim.api.nvim_clear_autocmds({
        group = augroup,
        buffer = bufnr,
      })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({ bufnr = bufnr })
        end,
      })
    end
  end,
}

return opts
