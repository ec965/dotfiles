return require("packer").startup(function(use)
    local has_termux = vim.env["TERMUX"] ~= nil
    --- Format my plugin's config to use local or remote
    ---@param config table|string
    ---@param use_local boolean? - if this is true then we will use the local plugin
    ---@return table|string
    local function ec965(config, use_local)
        local function configure_path(plugin_name)
            -- we never want to use local plugins in Termux
            if use_local and not has_termux then
                return "~/code/" .. plugin_name
            else
                return "ec965/" .. plugin_name
            end
        end

        if type(config) == "string" then
            return configure_path(config)
        else
            config[1] = configure_path(config[1])
            return config
        end
    end

    use "wbthomason/packer.nvim"

    -- editing
    use "tpope/vim-obsession"
    use {
        "nmac427/guess-indent.nvim",
        config = function()
            require("guess-indent").setup {}
        end,
    }
    use "tpope/vim-surround"
    use "gpanders/editorconfig.nvim"

    -- themes
    use "navarasu/onedark.nvim"
    use "NTBBloodbath/doom-one.nvim"
    use "folke/tokyonight.nvim"
    use "kaiuri/nvim-juliana"
    use { "EdenEast/nightfox.nvim", run = ":NightfoxCompile" }
    use "rebelot/kanagawa.nvim"

    -- yarn pnp
    use(ec965("nvim-pnp-checker", true))

    -- lsp
    use {
        "neovim/nvim-lspconfig",
        config = function()
            require "enoch.lsp"
        end,
        requires = {
            "jose-elias-alvarez/null-ls.nvim",
            "williamboman/mason.nvim",
            "b0o/schemastore.nvim",
            "onsails/lspkind.nvim",
        },
    }

    use {
        "vigoux/notifier.nvim",
        config = function()
            require("notifier").setup {}
        end,
    }

    -- completion
    use {
        "hrsh7th/nvim-cmp",
        config = function()
            require "enoch.cmp"
        end,
        requires = {
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "f3fora/cmp-spell",
            -- snippets
            {
                "L3MON4D3/LuaSnip",
                requires = {
                    "rafamadriz/friendly-snippets",
                },
                config = function()
                    require("luasnip.loaders.from_vscode").lazy_load()
                end,
            },
            "saadparwaiz1/cmp_luasnip",
        },
    }

    -- fuzzy finder
    use {
        "ibhagwan/fzf-lua",
        config = function()
            require("fzf-lua").register_ui_select()
        end,
    }

    -- tree sitter
    use {
        "nvim-treesitter/nvim-treesitter",
        config = function()
            require "enoch.treesitter"
        end,
        run = ":TSUpdate",
        requires = {
            { "nvim-treesitter/playground", cmd = "TSPlaygroundToggle" },
            "numToStr/Comment.nvim",
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
                end,
                cmd = "Neogen",
            },
            "nvim-treesitter/nvim-treesitter-context",
        },
    }

    -- markdown
    -- code block syntax highlighting
    use {
        "AckslD/nvim-FeMaco.lua",
        ft = "markdown",
        config = function()
            require("femaco").setup()
        end,
    }

    if not has_termux then
        use {
            "iamcco/markdown-preview.nvim",
            ft = { "markdown" },
            run = "cd app && yarn install",
            cmd = "MarkdownPreviewToggle",
            config = function()
                vim.keymap.set(
                    "n",
                    "<CR>",
                    ":MarkdownPreviewToggle<CR>",
                    { noremap = true, silent = true }
                )
            end,
        }
    end

    -- mjml
    use "amadeus/vim-mjml"
    if not has_termux then
        use(ec965({
            "mjml-preview.nvim",
            ft = "mjml",
            run = "cd app && npm install",
            cmd = "MjmlPreviewToggle",
            config = function()
                vim.keymap.set(
                    "n",
                    "<CR>",
                    ":MjmlPreviewToggle<CR>",
                    { noremap = true, silent = true }
                )
            end,
        }, true))
    end

    -- additional language support
    use "pearofducks/ansible-vim"
    use "vim-crystal/vim-crystal"

    -- status line
    use {
        "nvim-lualine/lualine.nvim",
        config = function()
            require "enoch.statusline"
        end,
    }

    -- qol
    use {
        "almo7aya/openingh.nvim",
        cmd = { "OpenInGHFile", "OpenInGHRepo" },
        config = function()
            require("openingh").setup()
        end,
    }
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
        "goolord/alpha-nvim",
        config = function()
            require "enoch.alpha"
        end,
    }
    use {
        "NvChad/nvim-colorizer.lua",
        config = function()
            require("colorizer").setup {
                filetypes = {
                    "javascript",
                    "javascriptreact",
                    "svelte",
                    "astro",
                    "typescript",
                    "typescriptreact",
                    "css",
                    "scss",
                },
                user_default_options = {
                    names = false,
                    mode = "virtualtext",
                },
            }
        end,
        ft = {
            "javascript",
            "javascriptreact",
            "svelte",
            "astro",
            "typescript",
            "typescriptreact",
            "css",
            "scss",
        },
    }

    -- make vim start faster
    use "lewis6991/impatient.nvim"

    use "nvim-tree/nvim-web-devicons"
    use "nvim-lua/plenary.nvim"

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
        end,
    }

    use(ec965("fnlnvim", true))
end)
