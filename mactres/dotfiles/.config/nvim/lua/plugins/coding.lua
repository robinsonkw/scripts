return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      -- The new way to ensure parsers are loaded
      -- (Note: 'ensure_installed' is now handled differently or via global vim options)
      
      -- Enable modern native Neovim treesitter highlighting automatically
      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          pcall(vim.treesitter.start)
        end,
      })
    end,
  },
}
