return {
  -- {
  --   'dsieradzki/nvim-runner',
  -- },
  {
    dir = '/home/damian/Dev/nvim-runner',
    config = function()
      require('runner').setup {
        telescope = true,
      }

      require('which-key').register {
        ['<leader>m'] = { name = 'Task runner', _ = 'which_key_ignore' },
      }

      vim.keymap.set('n', '<leader>mr', ':Telescope runner run_task<CR>', { desc = '[R]un task', silent = true })
      vim.keymap.set('n', '<leader>mg', ':Telescope runner run_group<CR>', { desc = 'Run [G]roup of tasks', silent = true })
      vim.keymap.set('n', '<leader>ml', ':Telescope runner list<CR>', { desc = '[L]ist running tasks', silent = true })
      vim.keymap.set('n', '<leader>ms', ':Telescope runner stop<CR>', { desc = '[S]op task', silent = true })
      vim.keymap.set('n', '<leader>mS', ':RunnerStopAll<CR>', { desc = '[S]op all tasks', silent = true })
    end,
  },
}
