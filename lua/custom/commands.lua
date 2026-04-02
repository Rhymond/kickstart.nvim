-- Custom commands and keymaps

-- Markdown todo keymaps (only active in markdown files)
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('markdown-todo', { clear = true }),
  pattern = 'markdown',
  callback = function(event)
    -- <leader>td: Toggle checkbox done/undone
    vim.keymap.set('n', '<leader>td', function()
      local line = vim.api.nvim_get_current_line()
      if line:match '%- %[ %]' then
        vim.api.nvim_set_current_line((line:gsub('%- %[ %]', '- [x]', 1)))
      elseif line:match '%- %[x%]' then
        vim.api.nvim_set_current_line((line:gsub('%- %[x%]', '- [ ]', 1)))
      end
    end, { buffer = event.buf, desc = '[T]odo [D]one - toggle checkbox' })

    -- <leader>tc: Create a new todo (on empty line, reuse it; otherwise insert below)
    vim.keymap.set('n', '<leader>tc', function()
      local row = vim.api.nvim_win_get_cursor(0)[1]
      local line = vim.api.nvim_get_current_line()
      local indent = line:match '^(%s*)' or ''
      if line:match '^%s*$' then
        vim.api.nvim_set_current_line(indent .. '- [ ] ')
        vim.api.nvim_win_set_cursor(0, { row, #indent + 6 })
      else
        vim.api.nvim_buf_set_lines(0, row, row, false, { indent .. '- [ ] ' })
        vim.api.nvim_win_set_cursor(0, { row + 1, #indent + 6 })
      end
      vim.cmd 'startinsert!'
    end, { buffer = event.buf, desc = '[T]odo [C]reate - new checkbox below' })

    -- <leader>tc in visual mode: wrap selected lines as todos
    vim.keymap.set('v', '<leader>tc', function()
      local start_row = vim.fn.line 'v'
      local end_row = vim.fn.line '.'
      if start_row > end_row then
        start_row, end_row = end_row, start_row
      end
      for row = start_row, end_row do
        local line = vim.api.nvim_buf_get_lines(0, row - 1, row, false)[1]
        if not line:match '%- %[.%]' then
          local indent, text = line:match '^(%s*)(.*)'
          vim.api.nvim_buf_set_lines(0, row - 1, row, false, { indent .. '- [ ] ' .. text })
        end
      end
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', false)
    end, { buffer = event.buf, desc = '[T]odo [C]reate - wrap selection as todos' })
  end,
})

-- Highlight #hashtags and @(time) annotations in markdown files
vim.api.nvim_set_hl(0, 'MarkdownHashtag', { link = 'Special' })
vim.api.nvim_set_hl(0, 'MarkdownTimestamp', { link = 'DiagnosticError' })
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('markdown-highlights', { clear = true }),
  pattern = 'markdown',
  callback = function()
    vim.fn.matchadd('MarkdownHashtag', [[\s\zs#\a\w*]])
    vim.fn.matchadd('MarkdownTimestamp', [[@([^)]\+)]])
  end,
})
