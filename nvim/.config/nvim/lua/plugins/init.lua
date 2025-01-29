-- [[ Configure and install plugins ]]
return {
  -- {
  --   'embark-theme/vim',
  --   as = 'embark',
  --   config = function()
  --     vim.cmd 'colorscheme embark'
  --   end,
  -- },
  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd [[colorscheme tokyonight]]
    end,
  },
  {
    'xiyaowong/transparent.nvim',
    lazy = false,
    config = function()
      -- Optional, you don't have to run setup.
      require('transparent').setup {
        -- table: default groups
        groups = {
          'Normal',
          'NormalNC',
          'Comment',
          'Constant',
          'Special',
          'Identifier',
          'Statement',
          'PreProc',
          'Type',
          'Underlined',
          'Todo',
          'String',
          'Function',
          'Conditional',
          'Repeat',
          'Operator',
          'Structure',
          'LineNr',
          'NonText',
          'SignColumn',
          'CursorLine',
          'CursorLineNr',
          'StatusLine',
          'StatusLineNC',
          'EndOfBuffer',
        },
        -- table: additional groups that should be cleared
        extra_groups = {
          'NormalFloat', -- plugins which have float panel such as Lazy, Mason, LspInfo
          'NvimTreeNormal', -- NvimTree
        },
        -- table: groups you don't want to clear
        exclude_groups = {},
        -- function: code to be executed after highlight groups are cleared
        -- Also the user event "TransparentClear" will be triggered
        on_clear = function() end,
      }
    end,
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      theme = 'embark',
    },
  },

  { -- Useful plugin to show you pending keybinds.
    -- This is the plugin that shows you keybinds in a
    'folke/which-key.nvim',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    config = function() -- This is the function that runs, AFTER loading
      require('which-key').setup()

      -- Document existing key chains
      require('which-key').add {
        { '<leader>c', group = '[C]ode' },
        { '<leader>d', group = '[D]ocument' },
        { '<leader>r', group = '[R]ename' },
        { '<leader>s', group = '[S]earch' },
        { '<leader>w', group = '[W]orkspace' },
        { '<leader>h', group = '[H]arpoon' },
      }
    end,
  },
  -- {
  --   'zbirenbaum/copilot.lua',
  --   event = 'InsertEnter',
  --   cmd = 'Copilot',
  --   config = function()
  --     require('copilot').setup {
  --       panel = {
  --         enabled = true,
  --         auto_refresh = false,
  --         keymap = {
  --           jump_prev = '<C-p>',
  --           jump_next = '<C-n>',
  --           accept = '<CR>',
  --           refresh = 'gr',
  --           open = '<C-CR>',
  --         },
  --         layout = {
  --           position = 'bottom', -- | top | left | right
  --           ratio = 0.4,
  --         },
  --       },
  --       suggestion = {
  --         enabled = true,
  --         auto_trigger = false,
  --         hide_during_completion = true,
  --         debounce = 75,
  --         keymap = {
  --           accept = '<C-l>',
  --           accept_word = '<C-S-l>',
  --           accept_line = false,
  --           next = false,
  --           prev = false,
  --           dismiss = '<C-t>',
  --         },
  --       },
  --       filetypes = {
  --         yaml = false,
  --         markdown = false,
  --         help = false,
  --         gitcommit = false,
  --         gitrebase = false,
  --         hgcommit = false,
  --         svn = false,
  --         cvs = false,
  --         ['.'] = false,
  --       },
  --       copilot_node_command = 'node', -- Node.js version must be > 18.x
  --       server_opts_overrides = {},
  --     }
  --   end,
  -- },
  --
  -- {
  --   'oxfist/night-owl.nvim',
  --   lazy = false, -- make sure we load this during startup if it is your main colorscheme
  --   priority = 1000, -- make sure to load this before all the other start plugins
  --   -- config = function()
  --   --   -- load the colorscheme here
  --   --   vim.cmd.colorscheme 'night-owl'
  --   -- end,
  -- },

  {
    'mbbill/undotree',
    config = function()
      vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle, { desc = 'Toggle [U]ndotree' })
    end,
  },

  { 'lervag/vimtex', ft = { 'tex', 'md' } },

  'tpope/vim-surround',

  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },

  -- See `:help gitsigns` to understand what the configuration keys do
  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup {
        signs = {
          add = { text = '+' },
          change = { text = '~' },
          delete = { text = '_' },
          topdelete = { text = '‾' },
          changedelete = { text = '~' },
        },
      }
      vim.keymap.set('n', ']g', ':Gitsigns next_hunk<CR>', { desc = 'Next hunk' })
      vim.keymap.set('n', '[g', ':Gitsigns prev_hunk<CR>', { desc = 'Previous hunk' })
      vim.keymap.set('n', '<leader>hp', ':Gitsigns preview_hunk<CR>', { desc = 'Preview hunk' })
      vim.keymap.set('n', '<leader>hs', ':Gitsigns stage_hunk<CR>', { desc = 'Stage hunk' })
    end,
  },
  -- Highlight todo, notes, etc in comments
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },
  {
    'Zeioth/compiler.nvim',
    config = function()
      require('compiler').setup {}
      vim.keymap.set('n', '<leader>cpo', '<cmd>CompilerOpen<CR>', { desc = 'Open Compiler window' })
      vim.keymap.set('n', '<leader>cpr', '<cmd>CompilerRedo<CR>', { desc = 'Redo Last Compilation Task' })
      vim.keymap.set('n', '<leader>cpt', '<cmd>CompilerToggleResults<CR>', { desc = 'Toggle Results Window' })
    end,
    dependencies = {
      {
        'stevearc/overseer.nvim',
        opts = {
          task_list = { -- this refers to the window that shows the result
            direction = 'bottom',
            min_height = 25,
            max_height = 25,
            default_detail = 1,
            bindings = {
              ['q'] = function()
                vim.cmd 'OverseerClose'
              end,
              ['C-J'] = function()
                vim.cmd 'wincmd j'
              end,
              ['C-K'] = function()
                vim.cmd 'wincmd k'
              end,
            },
          },
        },
        config = function(_, opts)
          require('overseer').setup(opts)
        end,
      },
    },
    cmd = { 'CompilerOpen', 'CompilerToggleResults', 'CompilerRedo' },
    opts = {},
  },
  { -- The task runner we use
    'stevearc/overseer.nvim',
    commit = '6271cab7ccc4ca840faa93f54440ffae3a3918bd',
    cmd = { 'CompilerOpen', 'CompilerToggleResults', 'CompilerRedo' },
    opts = {
      task_list = {
        direction = 'bottom',
        min_height = 25,
        max_height = 25,
        default_detail = 1,
      },
    },
  },
  'brennier/quicktex',
  'ThePrimeagen/vim-be-good',

  {
    'NeogitOrg/neogit',
    dependencies = {
      'nvim-lua/plenary.nvim', -- required
      'sindrets/diffview.nvim', -- optional - Diff integration

      -- Only one of these is needed.
      'nvim-telescope/telescope.nvim', -- optional
      'ibhagwan/fzf-lua', -- optional
      'echasnovski/mini.pick', -- optional
    },
    config = function()
      require('neogit').setup {}
      vim.keymap.set('n', '<leader>g', '<cmd>Neogit<CR>')
    end,
  },

  {
    'https://git.sr.ht/~detegr/nvim-bqn',

    config = function()
      local bqn_group = vim.api.nvim_create_augroup('bqn', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, { pattern = '*.bqn', group = bqn_group, command = 'setf bqn' })
      vim.api.nvim_create_autocmd(
        { 'BufRead', 'BufNewFile' },
        { pattern = '*', group = bqn_group, command = 'if getline(1) =~ "^#!.*bqn$" | setf bqn | endif' }
      )
    end,
  },
  {
    'nvimdev/dashboard-nvim',
    event = 'VimEnter',
    config = function()
      require('dashboard').setup {
        -- config
      }
    end,
    dependencies = { { 'nvim-tree/nvim-web-devicons' } },
  },
}
