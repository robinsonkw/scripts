-- ~/.config/nvim/lua/config/autocmds.lua
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "html", "xml" },
  command = "setlocal foldmethod=indent",
})
