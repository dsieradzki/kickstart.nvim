-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information

require('which-key').register {
  ['<leader>t'] = { name = '[T]erminal', _ = 'which_key_ignore' },
}
vim.keymap.set('n', '<leader>tt', ':terminal<CR>', { desc = 'Open [T]erminal' })
vim.keymap.set('n', '<leader>tb', ':20 split term://${SHELL}<CR>', { desc = 'Open [T]erminal in split' })

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

      require('which-key').register {
        ['<leader>n'] = { name = '[N]eo tree', _ = 'which_key_ignore' },
      }

      vim.keymap.set('n', '<leader>nc', ':Neotree close<CR>', { desc = '[C]lose Neotree' })
      vim.keymap.set('n', '<leader>no', ':Neotree source=filesystem reveal=true position=left<CR>', { desc = '[O]pen Neotree' })
    end,
  },

  {
    'nvim-neotest/neotest',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'antoinemadec/FixCursorHold.nvim',
      'nvim-treesitter/nvim-treesitter',
      'rouge8/neotest-rust',
      'nvim-neotest/neotest-go',
      'rcasia/neotest-java',
    },
    config = function()
      require('neotest').setup {
        adapters = {
          require 'neotest-rust' {
            args = { '--no-capture' },
          },
          require 'neotest-go' {},
          require 'neotest-java' {},
        },
      }

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('custom-lsp-attach', { clear = true }),
        callback = function(event)
          -- NOTE: Remember that lua is a real programming language, and as such it is possible
          -- to define small helper and utility functions so you don't have to repeat yourself
          -- many times.

          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          require('which-key').register {
            ['<leader>ct'] = { name = 'LSP: [C]ode [T]ests', _ = 'which_key_ignore' },
          }

          map('<leader>ctr', require('neotest').run.run, '[R]un the nearest test')
          map('<leader>cts', require('neotest').run.stop, '[S]top the nearest test')
          map('<leader>cto', function()
            require('neotest').output.open { enter = true }
          end, '[O]pen output')
          map('<leader>cti', require('neotest').summary.toggle, '[S]ummary')
          map('<leader>ctf', function()
            require('neotest').run.run(vim.fn.expand '%')
          end, 'Run the current [F]ile')
        end,
      })
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
      vim.keymap.set('n', 'f', '<Plug>(leap-forward)')
      vim.keymap.set('n', 'F', '<Plug>(leap-backward)')
    end,
  },
}
