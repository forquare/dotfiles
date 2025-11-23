return {
  {
    'zbirenbaum/copilot.lua',
    cmd = { 'Copilot', 'CopilotAuth' },
    event = 'InsertEnter', -- lazy-load when you start typing
    build = ':Copilot auth', -- run once to set up auth (optional, but handy)
    config = function()
      require('copilot').setup {
        panel = {
          enabled = false, -- I find the side panel noisy; enable if you like
        },
        suggestion = {
          enabled = true,
          auto_trigger = true, -- show suggestions as you type
          debounce = 75,
          -- These keymaps are for *inline* ghost text suggestions
          keymap = {
            accept = '<C-l>', -- accept full suggestion
            accept_word = '<C-Right>',
            accept_line = '<C-Down>',
            next = '<M-]>',
            prev = '<M-[>',
            dismiss = '<C-]>',
          },
        },
        -- You can control which filetypes get Copilot here
        filetypes = {
          -- enable for everything by default:
          ['*'] = true,
          -- and then selectively disable if you want:
          gitcommit = false,
          gitrebase = false,
          ['.'] = false, -- just in case for scratch buffers
        },
      }

      -- Optional: quick toggle for suggestions
      vim.keymap.set('n', '<leader>tc', function()
        require('copilot.suggestion').toggle_auto_trigger()
      end, { desc = '[T]oggle [C]opilot auto suggestions' })
    end,
  },
}
