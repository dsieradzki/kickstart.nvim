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

      require('which-key').register {
        ['<leader>f'] = { name = '[F]iles', _ = 'which_key_ignore' },
      }

      vim.keymap.set('n', '<leader>fc', ':Neotree close<CR>', { desc = '[C]lose file tree' })
      vim.keymap.set('n', '<leader>ft', ':Neotree source=filesystem reveal=true position=left<CR>', { desc = 'File [T]ree' })
      vim.keymap.set('n', '<leader>t', ':terminal<CR>', { desc = '[T]erminal' })
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
}
