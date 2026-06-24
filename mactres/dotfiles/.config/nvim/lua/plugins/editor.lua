-- ~/.config/nvim/lua/plugins/editor.lua
return {
  -- FZF (core binary + vim integration)
  {
    "junegunn/fzf",
    build = "./install --all",   -- This installs the fzf binary
    lazy = false,                -- Usually want this early
  },

  {
    "junegunn/fzf.vim",
    dependencies = { "junegunn/fzf" },
    config = function()
      -- FZF Mappings
      vim.keymap.set("n", "<C-p>", ":Files<CR>", { silent = true })
      vim.keymap.set("n", "<leader>rg", ":Rg<CR>", { silent = true })
      vim.keymap.set("n", "<leader>b", ":Buffers<CR>", { silent = true })

      -- Optional nice defaults
      vim.g.fzf_layout = { window = { width = 0.9, height = 0.9 } }
      vim.g.fzf_preview_window = { 'right', '70%' }
    end,
  },
}
