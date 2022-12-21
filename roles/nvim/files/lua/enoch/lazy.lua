local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system {
        "git",
        "clone",
        "--filter=blob:none",
        "--single-branch",
        "https://github.com/folke/lazy.nvim.git",
        lazypath,
    }
end
vim.opt.runtimepath:prepend(lazypath)

local has_termux = vim.env["TERMUX"] ~= nil

require("lazy").setup("enoch.plugins", {
    performance = {
        rtp = {
            disabled_plugins = {
                "tutor",
                "tohtml",
            },
        },
    },
    dev = {
        path = "~/code",
        patterns = { "ec965" },
    },
})
