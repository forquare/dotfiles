return {
  {
    'mrjosh/helm-ls',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    ft = 'helm',
    config = function()
      require('helm-ls').setup()
    end,
  },
}
