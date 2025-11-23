return {
  -- JSON & YAML schema catalog (used by jsonls / yamlls)
  {
    'b0o/SchemaStore.nvim',
    lazy = true,
    version = false, -- latest; releases are old
  },

  -- Treesitter parsers for JSON
  {
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { 'json', 'json5' })
    end,
  },

  -- JSON formatting via conform.nvim
  {
    'stevearc/conform.nvim',
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}

      -- Use prettierd for JSON / JSONC
      opts.formatters_by_ft.json = { 'prettierd' }
      opts.formatters_by_ft.jsonc = { 'prettierd' }
    end,
  },
}
