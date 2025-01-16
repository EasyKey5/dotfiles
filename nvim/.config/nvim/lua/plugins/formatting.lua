return { -- Autoformat
  {
    'stevearc/conform.nvim',
    opts = {},
    config = function()
      local conform = require 'conform'
      conform.setup {
        -- notify_on_error = false,
        format_on_save = {
          async = false,
          timeout_ms = 500,
          lsp_fallback = true,
        },
        formatters_by_ft = {
          lua = { 'stylua' },
          tex = { 'vimtex' },
          c = { 'clang-format' },
        },
      }
      vim.keymap.set({ 'n', 'v' }, '<leader>f', function()
        conform.format {
          async = false,
          timeout_ms = 500,
          lsp_fallback = true,
        }
      end, { desc = '[F]ormat file/range' })
    end,
  },

  {
    'preservim/vim-pencil',
    init = function()
      vim.g['pencil#wrapModeDefault'] = 'soft'
    end,
  },
}
