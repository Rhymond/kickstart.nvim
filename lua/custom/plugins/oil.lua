return {
  'stevearc/oil.nvim',
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {},
  -- Optional dependencies
  dependencies = { { 'echasnovski/mini.icons', opts = {} } },
  -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
  -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
  lazy = false,
  keys = {
    -- Open Oil in the current file's directory
    {
      '<leader>e',
      function()
        require('oil').open(vim.fn.expand '%:h')
      end,
      desc = 'Open Oil in current file directory',
    },
    -- Open Oil in the project root
    {
      '<leader>E',
      function()
        require('oil').open()
      end,
      desc = 'Open Oil in project root directory',
    },
  },
}
