return {
  {
    -- Set Laravel Pint as the default PHP formatter.
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        php = { "pint" },
      },
    },
  },
  {
    -- Remove phpcs linter.
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        php = {},
      },
    },
  },
  {
    -- Add the Laravel.nvim plugin which gives the ability to run Artisan commands
    -- from Neovim.
    "adalessa/laravel.nvim",
    dependencies = {
      "tpope/vim-dotenv",
      "nvim-telescope/telescope.nvim",
      "MunifTanjim/nui.nvim",
      "kevinhwang91/promise-async",
    },
    cmd = { "Artisan", "Composer", "Npm", "Yarn", "Laravel" },
    keys = {
      { "<leader>la", ":Laravel artisan<cr>" },
      { "<leader>lr", ":Laravel routes<cr>" },
      { "<leader>lm", ":Laravel related<cr>" },
    },
    event = { "VeryLazy" },
    config = true,
    opts = {
      lsp_server = "intelephense",
      features = { null_ls = { enable = false } },
    },
  },
  {
    -- Add a Treesitter parser for Laravel Blade to provide Blade syntax highlighting.
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts = opts or {}
      opts.ensure_installed = type(opts.ensure_installed) == "table" and opts.ensure_installed or {}
      -- On s'assure d'avoir les parsers utiles à Blade
      for _, lang in ipairs({ "php", "php_only", "html", "blade" }) do
        if not vim.tbl_contains(opts.ensure_installed, lang) then
          table.insert(opts.ensure_installed, lang)
        end
      end
      opts.highlight = opts.highlight or {}
      opts.highlight.enable = true
      return opts
    end,
    config = function(_, opts)
      -- Associer *.blade.php au filetype 'blade'
      vim.filetype.add({ pattern = { [".*%.blade%.php"] = "blade" } })

      -- Enregistrer le parser Blade AVANT setup
      local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
      ---@diagnostic disable-next-line: inject-field
      parser_config.blade = {
        install_info = {
          url = "https://github.com/EmranMR/tree-sitter-blade",
          files = { "src/parser.c" },
          branch = "main",
        },
        filetype = "blade",
      }

      -- Optionnel : éviter curl => préférer git
      require("nvim-treesitter.install").prefer_git = true
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
}
