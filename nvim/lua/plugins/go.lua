-- lua/custom/plugins/go.lua
-- All Go-specific plugins live here

return {
  -- Go helpers: tests, doc, struct tags, etc.
  {
    'ray-x/go.nvim',
    ft = { 'go', 'gomod', 'gowork', 'gotmpl' },
    dependencies = { 'ray-x/guihua.lua' },
    config = function()
      require('go').setup {
        gofmt = 'gofumpt', -- use gofumpt if installed
        lsp_cfg = false, -- we configure gopls in init.lua (Kickstart LSP block)
        lsp_inlay_hints = { enable = true },
      }

      -- Optional Go-specific keymaps (feel free to tweak)
      vim.keymap.set('n', '<leader>gt', '<cmd>GoTestFunc<CR>', { desc = '[G]o [T]est func' })
      vim.keymap.set('n', '<leader>gT', '<cmd>GoTestFile<CR>', { desc = '[G]o [T]est file' })
      vim.keymap.set('n', '<leader>gr', '<cmd>GoRun<CR>', { desc = '[G]o [R]un main' })
      vim.keymap.set('n', '<leader>gd', '<cmd>GoDoc<CR>', { desc = '[G]o [D]oc under cursor' })
    end,
  },

  -- golangci-lint via nvim-lint
  {
    'mfussenegger/nvim-lint',
    ft = 'go',
    config = function()
      local lint = require 'lint'

      -- Keep existing mappings if some other file configured nvim-lint
      lint.linters_by_ft = lint.linters_by_ft or {}
      lint.linters_by_ft.go = { 'golangci_lint' }

      -- Lint Go files after write
      vim.api.nvim_create_autocmd('BufWritePost', {
        group = vim.api.nvim_create_augroup('GoLint', { clear = true }),
        pattern = '*.go',
        callback = function()
          require('lint').try_lint()
        end,
      })
    end,
  },
}
