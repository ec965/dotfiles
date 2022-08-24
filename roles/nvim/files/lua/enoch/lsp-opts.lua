local pnp_checker = require "nvim-pnp-checker"
local schemastore = require "schemastore"
local telescope_builtin = require "telescope.builtin"
local nmap = require("enoch.helpers").nmap
local xmap = require("enoch.helpers").xmap
local fmt = require "enoch.format"
local cmp_nvim_lsp = require "cmp_nvim_lsp"

local M = {}

function M.common_on_attach(client, bufnr)
    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

    nmap("gd", telescope_builtin.lsp_definitions)
    nmap("K", vim.lsp.buf.hover)
    nmap("gi", telescope_builtin.lsp_implementations)
    nmap("gy", telescope_builtin.lsp_type_definitions)
    nmap("gr", telescope_builtin.lsp_references)
    nmap("gs", telescope_builtin.lsp_document_symbols)

    xmap("<leader>f", ":<C-U>lua vim.lsp.buf.range_formatting()<CR>")
    nmap("<leader>f", function()
        vim.lsp.buf.format {
            filter = function(fmt_client)
                if client.name == "astro" then
                    return fmt.format_filter(fmt.astro_fmt_omit)(
                        fmt_client.name
                    )
                end
                return fmt.format_filter(fmt.default_fmt_omit)(fmt_client.name)
            end,
        }
    end)

    nmap("[g", vim.diagnostic.goto_prev)
    nmap("g]", vim.diagnostic.goto_next)
    nmap("ga", function()
        telescope_builtin.diagnostics { bufnr = 0 }
    end)
    nmap("gw", telescope_builtin.diagnostics)

    nmap("<leader>a", vim.lsp.buf.code_action)
    xmap("<leader>a", ":<C-U>lua vim.lsp.buf.range_code_action()<CR>")
    nmap("<leader>rn", vim.lsp.buf.rename)
end

--- create cmp-nvim-lsp client capabilities
---@param opts table?
local function create_capabilities(opts)
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    if opts and opts.add_snippet_support then
        capabilities.textDocument.completion.completionItem.snippetSupport =
            true
    end
    return cmp_nvim_lsp.update_capabilities(capabilities)
end

---create default lsp client opts
---@param opts table?
---@return table
function M.create_default_opts(opts)
    return {
        on_attach = M.common_on_attach,
        capabilities = create_capabilities(opts),
    }
end

function M.sumneko_lua()
    local function get_runtime_path()
        local runtime_path = vim.split(package.path, ";")
        table.insert(runtime_path, "lua/?.lua")
        table.insert(runtime_path, "lua/?/init.lua")
        return runtime_path
    end

    local root = vim.fn.getcwd()
    local opts = M.create_default_opts {}

    if string.match(root, "nvim") then
        opts.settings = {
            Lua = {
                runtime = { version = "LuaJIT", path = get_runtime_path() },
                diagnostics = { globals = { "vim" } },
                workspace = {
                    library = vim.api.nvim_get_runtime_file("", true),
                },
                telemetry = { enable = false },
            },
        }
    elseif string.match(root, "hammerspoon") then
        opts.settings = {
            Lua = {
                diagnostics = { globals = { "hs" } },
                workspace = {
                    library = {
                        "/Applications/Hammerspoon.app/Contents/Resources/extensions/hs/",
                    },
                },
                telemetry = { enable = false },
            },
        }
    else
        opts.settings = {
            Lua = {
                telemetry = { enable = false },
            },
        }
    end

    return opts
end

function M.eslint()
    local opts = M.create_default_opts()

    opts.on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = true
        M.common_on_attach(client, bufnr)
    end

    local pnp_path = pnp_checker.find_pnp()
    if pnp_path then
        opts.cmd = pnp_checker.get_eslint_pnp_cmd(pnp_path)
    end

    opts.filetypes = {
        "javascript",
        "javascriptreact",
        "javascript.jsx",
        "typescript",
        "typescriptreact",
        "typescript.tsx",
        "vue",
        "astro",
        "svelte",
    }

    return opts
end

function M.html()
    local opts = M.create_default_opts { add_snippet_support = true }
    return opts
end

function M.cssls()
    local opts = M.create_default_opts { add_snippet_support = true }
    return opts
end

function M.jsonls()
    local opts = M.create_default_opts {
        add_snippet_support = true,
    }

    opts.settings = {
        json = {
            schemas = schemastore.json.schemas(),
            validate = { enable = true },
        },
    }

    return opts
end

function M.yammls()
    local opts = M.create_default_opts {}

    local jsonls_schemas = schemastore.json.schemas()
    local schemas = {}
    for _, schema in ipairs(jsonls_schemas) do
        schemas[schema.url] = schema.fileMatch
    end

    opts.settings = { schemas }
    return opts
end

function M.tsserver()
    local opts = M.create_default_opts {}

    local inlayHints = {
        includeInlayParameterNameHints = "all",
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
    }
    opts.settings = {
        typescript = { inlayHints = inlayHints },
        javascript = { inlayHints = inlayHints },
    }

    return opts
end

return M
