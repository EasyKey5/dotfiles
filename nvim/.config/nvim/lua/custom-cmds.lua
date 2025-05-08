local function get_class_name()
  local node = vim.treesitter.get_node()
  while node do
    if node:type() == 'class_definition' then
      local name_node = node:field('name')[1]
      if name_node then
        local class_name = vim.treesitter.get_node_text(name_node, 0)
        return class_name
      end
    end
    node = node:parent()
  end
  return nil
end

local function get_cmd(type)
  local class_name = get_class_name()
  if not class_name then
    print 'No class name found at cursor!'
    return
  end

  local file_path = vim.fn.expand '%:p'
  local dir_name = vim.fn.expand '%:p:h'
  local file_name = vim.fn.expand '%:t:r'
  local media_path = dir_name .. '/media'
  local path
  if type == 'video' then
    path = media_path .. '/videos/' .. file_name .. '/' .. class_name .. '.mp4'
  else
    if type == 'image' then
      path = media_path .. '/images/' .. file_name .. '/' .. class_name .. '.png'
    else
      if type == 'interactive' then
        local cmd = string.format("manim render --renderer=opengl -p '%s' '%s'", file_path, class_name)
        return cmd
      end
    end
  end

  local cmd = string.format("manim -qh '%s' '%s' -o %s && open '%s'", file_path, class_name, path, path)
  -- return "tmux popup -w 90% -h 80% -d '#{pane_current_path}' " .. cmd
  return cmd
end

local function run_cmd(type)
  local cmd = get_cmd(type)
  require('toggleterm.terminal').Terminal:new({ close_on_exit = false, cmd = cmd }):toggle()
  print(cmd)
  -- os.execute(cmd)
  -- print(cmd)
  -- os.execute(cmd)
end

vim.keymap.set('n', '<leader>mv', function()
  run_cmd 'video'
end, { noremap = false, silent = true })

vim.keymap.set('n', '<leader>mm', function()
  run_cmd 'image'
end, { noremap = false, silent = true })

vim.keymap.set('n', '<leader>mi', function()
  run_cmd 'interactive'
end, { noremap = false, silent = true })
