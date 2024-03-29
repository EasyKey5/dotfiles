return { -- Autocompletion
  'hrsh7th/nvim-cmp',
  event = 'InsertEnter',
  dependencies = {
    -- Snippet Engine & its associated nvim-cmp source
    {
      'L3MON4D3/LuaSnip',
      build = (function()
        -- Build Step is needed for regex support in snippets
        -- This step is not supported in many windows environments
        -- Remove the below condition to re-enable on windows
        if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
          return
        end
        return 'make install_jsregexp'
      end)(),
      dependencies = { 'rafamadriz/friendly-snippets', { 'evesdropper/luasnip-latex-snippets.nvim', ft = 'tex' } },
      config = function()
        --[[
          local ls = require 'luasnip'

          require('luasnip.loaders.from_vscode').lazy_load()
          local s = ls.snippet
          local sn = ls.snippet_node
          local t = ls.text_node
          local i = ls.insert_node
          local f = ls.function_node
          local d = ls.dynamic_node
          local c = ls.choice_node
          local fmt = require('luasnip.extras.fmt').fmt
          local fmta = require('luasnip.extras.fmt').fmta
          local rep = require('luasnip.extras').rep
          local types = require 'luasnip.util.types'

          ls.setup {
            keep_roots = true,
            link_roots = true,
            link_children = true,

            -- Update more often, :h events for more info.
            update_events = 'TextChanged,TextChangedI',
            -- Snippets aren't automatically removed if their text is deleted.
            -- `delete_check_events` determines on which events (:h events) a check for
            -- deleted snippets is performed.
            -- This can be especially useful when `history` is enabled.
            delete_check_events = 'TextChanged',
            ext_opts = {
              [types.choiceNode] = {
                active = {
                  virt_text = { { 'choiceNode', 'Comment' } },
                },
              },
            },
            -- treesitter-hl has 100, use something higher (default is 200).
            ext_base_prio = 300,
            -- minimal increase in priority.
            ext_prio_increase = 1,
            enable_autosnippets = true,
            -- mapping for cutting selected text so it's usable as SELECT_DEDENT,
            -- SELECT_RAW or TM_SELECTED_TEXT (mapped via xmap).
            store_selection_keys = '<Tab>',
            -- luasnip uses this function to get the currently active filetype. This
            -- is the (rather uninteresting) default, but it's possible to use
            -- eg. treesitter for getting the current filetype by setting ft_func to
            -- require("luasnip.extras.filetype_functions").from_cursor (requires
            -- `nvim-treesitter/nvim-treesitter`). This allows correctly resolving
            -- the current filetype in eg. a markdown-code block or `vim.cmd()`.
            ft_func = function()
              return require('luasnip.extras.filetype_functions').from_cursor_pos()
            end,
          }

          ls.add_snippets {
            'all',
            {
              s('trigger', {
                t { 'After expanding, the cursor is here ->' },
                i(1),
                t { '', 'After jumping forward once, cursor is here ->' },
                i(2),
                t { '', 'After jumping once more, the snippet is exited there ->' },
                i(0),
              }),
            },
          } ]]
        local ls = require 'luasnip'
        -- some shorthands...
        local s = ls.snippet
        local sn = ls.snippet_node
        local t = ls.text_node
        local i = ls.insert_node
        local f = ls.function_node
        local c = ls.choice_node
        local d = ls.dynamic_node
        local r = ls.restore_node
        local l = require('luasnip.extras').lambda
        local rep = require('luasnip.extras').rep
        local p = require('luasnip.extras').partial
        local m = require('luasnip.extras').match
        local n = require('luasnip.extras').nonempty
        local dl = require('luasnip.extras').dynamic_lambda
        local fmt = require('luasnip.extras.fmt').fmt
        local fmta = require('luasnip.extras.fmt').fmta
        local types = require 'luasnip.util.types'
        local conds = require 'luasnip.extras.conditions'
        local conds_expand = require 'luasnip.extras.conditions.expand'
        local autosnippet = ls.extend_decorator.apply(s, { snippetType = 'autosnippet' })

        -- If you're reading this file for the first time, best skip to around line 190
        -- where the actual snippet-definitions start.

        -- Every unspecified option will be set to the default.
        ls.setup {
          keep_roots = true,
          link_roots = true,
          link_children = true,

          -- Update more often, :h events for more info.
          update_events = 'TextChanged,TextChangedI',
          -- Snippets aren't automatically removed if their text is deleted.
          -- `delete_check_events` determines on which events (:h events) a check for
          -- deleted snippets is performed.
          -- This can be especially useful when `history` is enabled.
          delete_check_events = 'TextChanged',
          ext_opts = {
            [types.choiceNode] = {
              active = {
                virt_text = { { 'choiceNode', 'Comment' } },
              },
            },
          },
          -- treesitter-hl has 100, use something higher (default is 200).
          ext_base_prio = 300,
          -- minimal increase in priority.
          ext_prio_increase = 1,
          enable_autosnippets = true,
          -- mapping for cutting selected text so it's usable as SELECT_DEDENT,
          -- SELECT_RAW or TM_SELECTED_TEXT (mapped via xmap).
          store_selection_keys = '<Tab>',
          -- luasnip uses this function to get the currently active filetype. This
          -- is the (rather uninteresting) default, but it's possible to use
          -- eg. treesitter for getting the current filetype by setting ft_func to
          -- require("luasnip.extras.filetype_functions").from_cursor (requires
          -- `nvim-treesitter/nvim-treesitter`). This allows correctly resolving
          -- the current filetype in eg. a markdown-code block or `vim.cmd()`.
          ft_func = function()
            return vim.split(vim.bo.filetype, '.', true)
          end,
        }

        -- Make sure to not pass an invalid command, as io.popen() may write over nvim-text.
        local function bash(_, _, command)
          local file = io.popen(command, 'r')
          local res = {}
          for line in file:lines() do
            table.insert(res, line)
          end
          return res
        end

        local rec_ls
        rec_ls = function()
          return sn(
            nil,
            c(1, {
              -- Order is important, sn(...) first would cause infinite loop of expansion.
              t '',
              sn(nil, { t { '', '\t\\item ' }, i(1), d(2, rec_ls, {}) }),
            })
          )
        end

        --NOTE: SNIPPETS

        -- snippets are added via ls.add_snippets(filetype, snippets[, opts]), where
        -- opts may specify the `type` of the snippets ("snippets" or "autosnippets",
        -- for snippets that should expand directly after the trigger is typed).
        --
        -- opts can also specify a key. By passing an unique key to each add_snippets, it's possible to reload snippets by
        -- re-`:luafile`ing the file in which they are defined (eg. this one).
        ls.add_snippets('all', {
          -- Shorthand for repeating the text in a given node.
          s('repeat', { i(1, 'text'), t { '', '' }, rep(1) }),
        })

        ls.add_snippets('java', {
          -- Very long example for a java class.
        }, {
          key = 'java',
        })

        ls.add_snippets('lua', {
          s(
            'myreq',
            fmta(
              [[
              local <var> = require("<mod>")
              ]],
              {
                mod = i(1),
                var = f(function(text)
                  local segments = vim.split(text[1][1], '.', true)
                  print(vim.inspect(segments))
                  return segments[#segments] or ''
                end, { 1 }),
              }
            )
          ),
        })

        ls.add_snippets('tex', {

          -- Integration by parts 'DI' method

          s(
            'ibp',
            fmta(
              [[
                \begin{table*}[h]
                    \begin{tabular}{ccc}
                          & \textbf{D} & \textbf{I} \\[\parskip]
                        + & $<>$ & $<>$ \\[\parskip]
                        - & $<>$ & $<>$ \\[\parskip]
                    \end{tabular}
                \end{table*}
                <>
                ]],
              { i(1), i(2), i(3), i(4), i(0) }
            ),
            {
              -- condition = require('luasnip-latex-snippets.luasnippets.tex.utils.conditions').in_text(),
            }
          ),

          -- Copyright (c) 2024 Author. All Rights Reserved.
          s('cr', {
            t 'Copyright ~\\copyright~ ',
            f(function()
              return os.time()
            end),
          }),

          -- rec_ls is self-referencing. That makes this snippet 'infinite' eg. have as many
          -- \item as necessary by utilizing a choiceNode.
          s('itemize', {
            t { '\\begin{itemize}', '\t\\item ' },
            i(1),
            d(2, rec_ls, {}),
            t { '', '\\end{itemize}' },
          }),
        }, {
          key = 'tex',
        })

        -- set type to "autosnippets" for adding autotriggered snippets.
        -- ls.add_snippets('all', {
        --   s('autotrigger', {
        --     t 'autosnippet',
        --   }),
        -- }, {
        --   type = 'autosnippets',
        --   key = 'all_auto',
        -- })

        -- in a lua file: search lua-, then c-, then all-snippets.
        ls.filetype_extend('lua', { 'c' })
        -- in a cpp file: search c-snippets, then all-snippets only (no cpp-snippets!!).
        ls.filetype_set('cpp', { 'c' })

        -- Beside defining your own snippets you can also load snippets from "vscode-like" packages
        -- that expose snippets in json files, for example <https://github.com/rafamadriz/friendly-snippets>.

        require('luasnip.loaders.from_vscode').load { include = { 'python' } } -- Load only python snippets

        -- The directories will have to be structured like eg. <https://github.com/rafamadriz/friendly-snippets> (include
        -- a similar `package.json`)
        -- require('luasnip.loaders.from_vscode').load { paths = { './my-snippets' } } -- Load snippets from my-snippets folder

        -- You can also use lazy loading so snippets are loaded on-demand, not all at once (may interfere with lazy-loading luasnip itself).
        require('luasnip.loaders.from_vscode').lazy_load() -- You can pass { paths = "./my-snippets/"} as well

        -- You can also use snippets in snipmate format, for example <https://github.com/honza/vim-snippets>.
        -- The usage is similar to vscode.

        -- One peculiarity of honza/vim-snippets is that the file containing global
        -- snippets is _.snippets, so we need to tell luasnip that the filetype "_"
        -- contains global snippets:
        ls.filetype_extend('all', { '_' })

        -- require('luasnip.loaders.from_snipmate').load { include = { 'c' } } -- Load only snippets for c.

        -- Load snippets from my-snippets folder
        -- The "." refers to the directory where of your `$MYVIMRC` (you can print it
        -- out with `:lua print(vim.env.MYVIMRC)`.
        -- NOTE: It's not always set! It isn't set for example if you call neovim with
        -- the `-u` argument like this: `nvim -u yeet.txt`.
        --
        -- require('luasnip.loaders.from_snipmate').load { path = { './my-snippets' } }
        --
        -- If path is not specified, luasnip will look for the `snippets` directory in rtp (for custom-snippet probably
        -- `~/.config/nvim/snippets`).

        require('luasnip.loaders.from_snipmate').lazy_load() -- Lazy loading

        -- see DOC.md/LUA SNIPPETS LOADER for some details.
        require('luasnip.loaders.from_lua').load { include = { 'c' } }
        require('luasnip.loaders.from_lua').lazy_load { include = { 'all', 'cpp' } }
      end,
    },

    'saadparwaiz1/cmp_luasnip',

    -- Adds other completion capabilities.
    --  nvim-cmp does not ship with all sources by default. They are split
    --  into multiple repos for maintenance purposes.
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-path',

    -- If you want to add a bunch of pre-configured snippets,
    --    you can use this plugin to help you. It even has snippets
    --    for various frameworks/libraries/etc. but you will have to
    --    set up the ones that are useful for you.
    -- 'rafamadriz/friendly-snippets',
  },
  config = function()
    -- See `:help cmp`
    local cmp = require 'cmp'
    local ls = require 'luasnip'
    cmp.setup {
      snippet = {
        expand = function(args)
          ls.lsp_expand(args.body)
        end,
      },
      completion = { completeopt = 'menu,menuone,noinsert' },

      -- For an understanding of why these mappings were
      -- chosen, you will need to read `:help ins-completion`
      --
      -- No, but seriously. Please read `:help ins-completion`, it is really good!
      mapping = cmp.mapping.preset.insert {
        -- Select the [n]ext item
        ['<C-n>'] = cmp.mapping.select_next_item(),
        -- Select the [p]revious item
        ['<C-p>'] = cmp.mapping.select_prev_item(),

        -- Accept ([y]es) the completion.
        --  This will auto-import if your LSP supports it.
        --  This will expand snippets if the LSP sent a snippet.
        ['<C-i>'] = cmp.mapping.confirm { select = true },

        -- Manually trigger a completion from nvim-cmp.
        --  Generally you don't need this, because nvim-cmp will display
        --  completions whenever it has completion options available.
        ['<C-Space>'] = cmp.mapping.complete {},

        ['<C-k>'] = cmp.mapping(function()
          if ls.expand_or_locally_jumpable() then
            ls.expand_or_jump()
          else
            cmp.mapping.confirm { select = true }
          end
        end, { 'i', 's' }),
        ['<C-j>'] = cmp.mapping(function()
          if ls.locally_jumpable(-1) then
            ls.jump(-1)
          end
        end, { 'i', 's' }),
        ['<C-l>'] = cmp.mapping(function()
          if ls.choice_active() then
            ls.change_choice(1)
          end
        end),
        ['<C-h>'] = cmp.mapping(function()
          if ls.choice_active() then
            ls.change_choice(-1)
          end
        end),
      },
      sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'path' },
      },
    }
  end,
}, 
{ -- You can easily change to a different colorscheme.
  -- Change the name of the colorscheme plugin below, and then
  -- change the command in the config to whatever the name of that colorscheme is
  --
  -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`
  'oxfist/night-owl.nvim',
  lazy = false, -- make sure we load this during startup if it is your main colorscheme
  priority = 1000, -- make sure to load this before all the other start plugins
  config = function()
    -- load the colorscheme here
    vim.cmd.colorscheme 'night-owl'
  end,
}
