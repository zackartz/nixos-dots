-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

if vim.g.neovide then
  -- Put anything you want to happen only in Neovide here
  vim.o.guifont = "Iosevka,Noto_Color_Emoji:h14:b"
end

-- in this case.
vim.g.lazyvim_blink_main = true

vim.o.termguicolors = true

vim.g.lazyvim_python_lsp = "basedpyright"
