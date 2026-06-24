-- ~/.config/nvim/lua/plugins/ui.lua
return {
  -- 1. Colorscheme
  { "folke/tokyonight.nvim", lazy = false, priority = 1000 },

  -- 2. Statusline
  { "vim-airline/vim-airline", dependencies = { "vim-airline/vim-airline-themes" } },

  -- 3. File explorer
  { 
    "preservim/nerdtree",
    config = function()
      vim.g.NERDTreeShowHidden = 1
      vim.g.NERDTreeQuitOnOpen = 1
      vim.g.NERDTreeAutoDeleteBuffer = 1
      vim.keymap.set("n", "<C-n>", ":NERDTreeToggle<CR>", { silent = true })
    end
  },

  -- 4. Indent guides
  { 
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function()
      require("ibl").setup({})
    end
  },

  -- 5. Which-key
  { 
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      require("which-key").setup({})
    end
  },

  -- 6. Zen Mode (Fixed and properly merged)
  {
    "folke/zen-mode.nvim",
    opts = {
      window = {
        width = 80, -- Forces your coding view to be strictly 80 characters wide!
      },
    },
    config = function(_, opts)
      -- Setup the plugin with your width configurations
      require("zen-mode").setup(opts)
      
      -- Set the hotkey safely inside the configuration loading window
      vim.keymap.set("n", "<leader>z", "<cmd>ZenMode<cr>", { desc = "Toggle Zen Mode (80 Columns)" })
    end,
  },
}
