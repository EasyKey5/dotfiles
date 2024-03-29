return {
  name = 'harpoon',
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local harpoon = require 'harpoon'
    harpoon:setup {}
    vim.keymap.set('n', '<leader>ha', function()
      harpoon:list():append()
    end, { desc = '[A]dd mark' })

    vim.keymap.set('n', '<leader>hm', function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end, { desc = 'Toggle [M]enu' })

    vim.keymap.set('n', '<C-e>', function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end)

    vim.keymap.set('n', '<C-S-J>', function()
      harpoon:list():select(1)
    end)

    vim.keymap.set('n', '<C-S-K>', function()
      harpoon:list():select(2)
    end)

    vim.keymap.set('n', '<C-S-L>', function()
      harpoon:list():select(3)
    end)

    vim.keymap.set('n', '<C-S-H>', function()
      harpoon:list():select(4)
    end)

    -- Toggle previous & next buffers stored within Harpoon list
    vim.keymap.set('n', '<C-S-P>', function()
      harpoon:list():prev()
    end)

    vim.keymap.set('n', '<C-S-N>', function()
      harpoon:list():next()
    end)
  end,
}
