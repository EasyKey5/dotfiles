return {
  name = 'harpoon',
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local harpoon = require 'harpoon'
    harpoon:setup {}
    vim.keymap.set('n', '<leader>ha', function()
      harpoon:list():add()
    end, { desc = '[A]dd mark' })

    vim.keymap.set('n', '<leader>hh', function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end, { desc = 'Toggle Menu' })

    vim.keymap.set('n', '<C-h>', function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end)

    vim.keymap.set('n', '<C-J>', function()
      harpoon:list():select(1)
    end)

    vim.keymap.set('n', '<C-K>', function()
      harpoon:list():select(2)
    end)

    vim.keymap.set('n', '<C-L>', function()
      harpoon:list():select(3)
    end)

    vim.keymap.set('n', '<C-H>', function()
      harpoon:list():select(4)
    end)

    -- Toggle previous & next buffers stored within Harpoon list
    vim.keymap.set('n', '<C-P>', function()
      harpoon:list():prev()
    end)

    vim.keymap.set('n', '<C-N>', function()
      harpoon:list():next()
    end)
  end,
}
