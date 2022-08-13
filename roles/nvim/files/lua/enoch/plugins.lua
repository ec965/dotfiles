vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]]

return require("packer").startup(function(use)
    use "wbthomason/packer.nvim"

    -- editing
    use "tpope/vim-obsession"
    use {
        "nmac427/guess-indent.nvim",
        config = function()
            require("guess-indent").setup {}
        end,
    }
    use "kylechui/nvim-surround"
    use "gpanders/editorconfig.nvim"

    -- comments
    use "numToStr/Comment.nvim"

    -- themes
    use "navarasu/onedark.nvim"
    use "NTBBloodbath/doom-one.nvim"
    use "folke/tokyonight.nvim"
    use "kaiuri/nvim-juliana"
    use "B4mbus/oxocarbon-lua.nvim"

    use "xiyaowong/nvim-transparent"

    -- preview
    use {
        "iamcco/markdown-preview.nvim",
        ft = { "markdown" },
        run = "cd app && yarn install",
        config = function()
            require("enoch.helpers").nmap("<CR>", ":MarkdownPreviewToggle<CR>")
        end,
    }
    use {
        "~/code/mjml-preview.nvim",
        ft = "mjml",
        run = "cd app && npm install && npm run build",
        config = function()
            require("enoch.helpers").nmap("<CR>", ":MjmlPreviewToggle<CR>")
        end,
    }

    -- yarn pnp
    use {
        "lbrayner/vim-rzip",
        ft = {
            "javascript",
            "typescript",
            "typescriptreact",
            "javascriptreact",
        },
    }
    use "ec965/nvim-pnp-checker"

    -- lsp
    use {
        "neovim/nvim-lspconfig",
        requires = {
            "jose-elias-alvarez/null-ls.nvim",
            "jose-elias-alvarez/nvim-lsp-ts-utils",
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            {
                "j-hui/fidget.nvim",
                config = function()
                    require("fidget").setup()
                end,
            },
            "b0o/schemastore.nvim",
            "onsails/lspkind.nvim",
            "lvimuser/lsp-inlayhints.nvim",
        },
    }

    -- completion
    use {
        "hrsh7th/nvim-cmp",
        requires = {
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "f3fora/cmp-spell",
            -- snippets
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
        },
    }

    -- fuzzy finder
    use {
        "nvim-telescope/telescope.nvim",
        requires = {
            "nvim-lua/plenary.nvim",
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                run = "make",
            },
            "nvim-telescope/telescope-ui-select.nvim",
        },
    }

    -- tree sitter
    use {
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate",
        requires = {
            {
                "windwp/nvim-autopairs",
                config = function()
                    require("nvim-autopairs").setup { check_ts = true }
                end,
            },
            "windwp/nvim-ts-autotag",
            "JoosepAlviste/nvim-ts-context-commentstring",
            {
                "danymat/neogen",
                config = function()
                    require("neogen").setup {}
                    require("enoch.helpers").nmap(
                        "<leader>nf",
                        require("neogen").generate
                    )
                end,
            },
        },
    }

    -- markdown code block syntax highlighting
    use {
        "AckslD/nvim-FeMaco.lua",
        config = function()
            require("femaco").setup()
        end,
    }

    -- additional language support
    use "amadeus/vim-mjml"
    use "pearofducks/ansible-vim"

    -- status line
    use "nvim-lualine/lualine.nvim"

    -- qol
    use {
        "lukas-reineke/indent-blankline.nvim",
        config = function()
            vim.g.indent_blankline_filetype_exclude = {
                "alpha",
                "lspinfo",
                "packer",
                "checkhealth",
                "help",
                "man",
                "",
            }
            require("indent_blankline").setup {
                space_char_blankline = " ",
                show_current_context = true,
            }
        end,
    }
    use {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup { current_line_blame = true }
        end,
    }
    use "goolord/alpha-nvim"
    use "akinsho/toggleterm.nvim"
    use {
        "ggandor/leap.nvim",
        config = function()
            require("leap").set_default_keymaps()
        end,
    }
    use {
        "NvChad/nvim-colorizer.lua",
        config = function()
            require("colorizer").setup({
                "javascript",
                "javascriptreact",
                "svelte",
                "astro",
                "typescript",
                "typescriptreact",
                "css",
                "scss",
            }, { names = false })
        end,
    }

    -- make vim start faster
    use "lewis6991/impatient.nvim"
    use "nathom/filetype.nvim"

    -- file tree
    use {
        "kyazdani42/nvim-tree.lua",
        requires = { "kyazdani42/nvim-web-devicons" },
    }

    -- window picker
    use {
        "https://gitlab.com/yorickpeterse/nvim-window.git",
        config = function()
            local nvim_window = require "nvim-window"
            nvim_window.setup {
                chars = {
                    "f",
                    "j",
                    "d",
                    "k",
                    "s",
                    "l",
                    "a",
                    ";",
                    "c",
                    "m",
                    "r",
                    "u",
                    "e",
                    "i",
                    "w",
                    "o",
                    "q",
                    "p",
                },
            }
            require("enoch.helpers").nmap("<leader>w", function()
                nvim_window.pick()
            end)
        end,
    }
end)
