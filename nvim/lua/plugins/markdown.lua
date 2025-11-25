return {
  {
    'MeanderingProgrammer/render-markdown.nvim',
    ft = 'markdown',
    config = function()
      require('render-markdown').setup {
        enabled = true,
      }
    end,
  },

  -- Markdown editing enhancements
  {
    'tadmccorkle/markdown.nvim',
    ft = 'markdown',
    config = function()
      require('markdown').setup {
        mappings = {
          link_add = 'gl',
          link_follow = 'gx',
        },
      }
    end,
  },
}
