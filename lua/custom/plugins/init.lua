-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'nvim-neo-tree/neo-tree.nvim',
    version = '*',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
      'MunifTanjim/nui.nvim',
    },
    config = function()
      require('neo-tree').setup {
        filesystem = {
          follow_current_file = {
            enabled = true, -- This will find and focus the file in the active buffer every time
            --               -- the current file is changed while the tree is open.
            leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
          },
          group_empty_dirs = true, -- when true, empty folders will be grouped together
        },
      }

      require('which-key').add {
        { '<leader>n', desc = '[N]eo tree' },
      }

      vim.keymap.set('n', '<leader>nc', ':Neotree close<CR>', { desc = '[C]lose Neotree', silent = true })
      vim.keymap.set('n', '<leader>no', ':Neotree source=filesystem reveal=true position=left<CR>', { desc = '[O]pen Neotree', silent = true })
    end,
  },

  {
    'ggandor/leap.nvim',
    opts = {
      case_sensitive = false,
      safe_labels = {}, -- disable auto-jumping to the first match; doesn't work on one unique target
      max_phase_one_targets = 0, -- first char won't show possible matches
      max_highlighted_traversal_targets = 10,
    },
    config = function(_, opts)
      local leap = require 'leap'
      leap.setup(opts)

      -- TODO: add which key description
      vim.keymap.set('n', 'f', '<Plug>(leap-forward)')
      vim.keymap.set('n', 'F', '<Plug>(leap-backward)')
    end,
  },
}
