local treesitter = require "nvim-treesitter.configs"
local langs = {
    "astro",
    "bash",
    "c",
    "comment",
    "cpp",
    "css",
    "dockerfile",
    "dot",
    "fennel",
    "go",
    "gomod",
    "gowork",
    "graphql",
    "hcl",
    "help",
    "html",
    "javascript",
    "jsdoc",
    "json",
    "jsonc",
    "julia",
    "lua",
    "markdown",
    "markdown_inline",
    "prisma",
    "query",
    "regex",
    "regex",
    "rust",
    "scss",
    "sql",
    "svelte",
    "toml",
    "tsx",
    "typescript",
    "vim",
    "yaml",
    "zig",
}

treesitter.setup {
    ensure_installed = langs,
    sync_install = false,
    highlight = { enable = true, additional_vim_regex_highlighting = false },
    autotag = {
        enable = true,
        filetypes = {
            "astro",
            "glimmer",
            "handlebars",
            "hbs",
            "html",
            "javascript",
            "javascriptreact",
            "jsx",
            "markdown",
            "php",
            "rescript",
            "svelte",
            "tsx",
            "typescript",
            "typescriptreact",
            "vue",
            "xml",
        },
    },
    context_commentstring = {
        enable = true,
    },
}
