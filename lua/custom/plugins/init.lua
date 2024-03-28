-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information

require('which-key').register {
  ['<leader>t'] = { name = '[T]erminal', _ = 'which_key_ignore' },
}
vim.keymap.set('n', '<leader>tt', ':terminal<CR>', { desc = 'Open [T]erminal', silent = true })
vim.keymap.set('n', '<leader>tb', ':20 split term://${SHELL}<CR>', { desc = 'Open [T]erminal bottom', silent = true })

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

      vim.keymap.set('n', '<leader>nc', ':Neotree close<CR>', { desc = '[C]lose Neotree', silent = true })
      vim.keymap.set('n', '<leader>no', ':Neotree source=filesystem reveal=true position=left<CR>', { desc = '[O]pen Neotree', silent = true })
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
  {
    'NeogitOrg/neogit',
    dependencies = {
      'nvim-lua/plenary.nvim', -- required
      'sindrets/diffview.nvim', -- optional - Diff integration

      -- Only one of these is needed, not both.
      'nvim-telescope/telescope.nvim', -- optional
    },
    config = function()
      require('neogit').setup {}

      vim.keymap.set('n', '<leader>g', ':Neogit<CR>', { desc = 'Neo[g]it', silent = true })
    end,
  },
  {
    'nvim-neorg/neorg',
    build = ':Neorg sync-parsers',
    lazy = false, -- specify lazy = false because some lazy.nvim distributions set lazy = true by default
    tag = "v7.0.0",
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('neorg').setup {
        load = {
          ['core.defaults'] = {}, -- Loads default behaviour
          ['core.concealer'] = {
            config = {
              icon_preset = 'varied',
              icons = {
                todo = {
                  undone = {
                    icon = ' ',
                  },
                },
              },
            },
          }, -- Adds pretty icons to your documents
          -- ['core.dirman'] = { -- Manages Neorg workspaces
          -- config = {
          --   workspaces = {
          --     notes = '~/notes',
          --   },
          -- },
          --},
        },
      }
    end,
  },
  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    opts = {
      lsp = {
        progress = {
          enabled = false,
        },
      },
      -- you can enable a preset for easier configuration
      presets = {
        bottom_search = true, -- use a classic bottom cmdline for search
        command_palette = false, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = false, -- add a border to hover docs and signature help
      },
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      'MunifTanjim/nui.nvim',
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      'rcarriga/nvim-notify',
    },
  },
  { -- noice.nvim supports LSP messages but it's doing a mess, because it stacking messages rather than update, this works properly
    'mrded/nvim-lsp-notify',
    dependencies = {
      'rcarriga/nvim-notify',
    },
    config = function()
      require('lsp-notify').setup {
        notify = require 'notify',
      }
    end,
  },
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    opts = {
      open_mapping = [[<c-\>]],
      direction = 'float',
    },
  },
  {
    'onsails/lspkind.nvim',
  },
  {
    'nvimdev/dashboard-nvim',
    event = 'VimEnter',
    config = function()
      require('dashboard').setup {
        theme = 'doom',
        config = {
          header = {
            [[                                                     ]],
            [[                                                     ]],
            [[                                                     ]],
            [[                                                     ]],
            [[  ███▄    █ ▓█████  ▒█████   ██▒   █▓ ██▓ ███▄ ▄███▓ ]],
            [[  ██ ▀█   █ ▓█   ▀ ▒██▒  ██▒▓██░   █▒▓██▒▓██▒▀█▀ ██▒ ]],
            [[ ▓██  ▀█ ██▒▒███   ▒██░  ██▒ ▓██  █▒░▒██▒▓██    ▓██░ ]],
            [[ ▓██▒  ▐▌██▒▒▓█  ▄ ▒██   ██░  ▒██ █░░░██░▒██    ▒██  ]],
            [[ ▒██░   ▓██░░▒████▒░ ████▓▒░   ▒▀█░  ░██░▒██▒   ░██▒ ]],
            [[ ░ ▒░   ▒ ▒ ░░ ▒░ ░░ ▒░▒░▒░    ░ ▐░  ░▓  ░ ▒░   ░  ░ ]],
            [[ ░ ░░   ░ ▒░ ░ ░  ░  ░ ▒ ▒░    ░ ░░   ▒ ░░  ░      ░ ]],
            [[    ░   ░ ░    ░   ░ ░ ░ ▒       ░░   ▒ ░░      ░    ]],
            [[          ░    ░  ░    ░ ░        ░   ░         ░    ]],
            [[                                 ░                   ]],
            [[                                                     ]],
          },
          center = {
            {
              icon = '󱎰 ',
              icon_hl = 'Title',
              desc = 'Search Home Files',
              desc_hl = 'String',
              key = 'F',
              keymap = 'SPC s',
              key_hl = 'Number',
              key_format = ' %s', -- remove default surrounding `[]`
              action = "require'telescope.builtin'.find_files { search_dirs = { vim.env.HOME }, hidden = false }",
            },
            {
              icon = '󱁴 ',
              desc = 'Search Recent Files',
              key = '.',
              keymap = 'SPC s',
              key_format = ' %s', -- remove default surrounding `[]`
              action = 'Telescope oldfiles',
            },
            {
              icon = ' ',
              desc = 'Search Neovim files',
              key = 'n',
              keymap = 'SPC s',
              key_format = ' %s', -- remove default surrounding `[]`
              action = "require'telescope.builtin'.find_files { cwd = vim.fn.stdpath 'config' }",
            },

            {
              icon = '󰟒 ',
              desc = 'Projects',
              key = 'p',
              keymap = 'SPC',
              key_format = ' %s', -- remove default surrounding `[]`
              action = 'Telescope project',
            },

            {
              icon = '󰘥 ',
              desc = 'Search Help',
              key = 'h',
              keymap = 'SPC s',
              key_format = ' %s', -- remove default surrounding `[]`
              action = 'Telescope help_tags',
            },
          },
          --footer = {}, --your footer
        },
      }
    end,
    dependencies = { { 'nvim-tree/nvim-web-devicons' } },
  },
  {
    'folke/zen-mode.nvim',
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
    config = function()
      vim.keymap.set('n', '<leader>z', ':ZenMode<CR>', { desc = '[Z]en Mode', silent = true })
    end,
  },
  -- {
  --   'folke/twilight.nvim',
  --   opts = {
  --     -- your configuration comes here
  --     -- or leave it empty to use the default settings
  --     -- refer to the configuration section below
  --   },
  -- },
}
