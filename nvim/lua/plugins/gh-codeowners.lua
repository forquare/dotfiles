return {
  'comatory/gh-co.nvim',
  config = function()
    vim.keymap.set('n', '<leader>gg', ':GhCoWho<CR>', { desc = 'Show CODEOWNERS for current file' })
  end,
}
