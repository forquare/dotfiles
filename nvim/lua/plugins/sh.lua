-- POSIX shell formatting & linting integration

return {
  -- Add shfmt to conform.nvim
  {
    'stevearc/conform.nvim',
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}

      -- Format POSIX shell scripts with shfmt
      -- You can tweak args to be stricter POSIX-wise:
      --   -i 2  : indent 2 spaces
      --   -ci   : switch-case indentation
      --   -sr   : redirect operators on the right
      opts.formatters_by_ft.sh = { 'shfmt' }

      opts.formatters = opts.formatters or {}
      opts.formatters.shfmt = {
        prepend_args = { '-i', '0', '-ci', '-sr' },
      }
    end,
  },

  -- Add shellcheck to nvim-lint
  {
    'mfussenegger/nvim-lint',
    config = function()
      local lint = require 'lint'

      lint.linters_by_ft = lint.linters_by_ft or {}
      lint.linters_by_ft.sh = { 'shellcheck' }

      -- Optionally force POSIX mode:
      -- local shellcheck = lint.linters.shellcheck
      -- shellcheck.args = { "--format=gcc", "--shell=sh" }

      -- Lint on save
      vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
        group = vim.api.nvim_create_augroup('lint-sh', { clear = true }),
        pattern = '*.sh',
        callback = function()
          require('lint').try_lint()
        end,
      })
    end,
  },
}
