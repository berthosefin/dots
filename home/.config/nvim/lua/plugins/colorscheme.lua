return {
  -- add colorschemes
  { "ellisonleao/gruvbox.nvim" },
  { "shaunsingh/nord.nvim" },
  { "Mofiqul/dracula.nvim" },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    version = "*",
    priority = 1000,
    opts = {
      flavour = "nord",
    },
  },

  -- Configure LazyVim to load colorscheme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "nord",
    },
  },
}
