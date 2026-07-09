return {
    -- add colorschemes
    { "folke/tokyonight.nvim" },
    {
        "RRethy/base16-nvim",
        init = function()
            vim.api.nvim_create_autocmd("ColorScheme", {
                pattern = "*",
                group = vim.api.nvim_create_augroup("matugen-colors", { clear = true }),
                callback = function()
                    local f = vim.fn.expand("~/.config/nvim/generated.lua")
                    if vim.fn.filereadable(f) == 1 then
                        pcall(dofile, f)
                    end
                end,
            })
        end,
    },

    -- Configure LazyVim to load colorscheme
    {
        "LazyVim/LazyVim",
        opts = {
            colorscheme = "tokyonight",
        },
    },
}
