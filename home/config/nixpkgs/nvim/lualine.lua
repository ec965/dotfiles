local theme = vim.g.colors_name
if theme == "one" then
  theme = "onedark"
end
if theme == "github_dark" then
  theme = "github"
end

require("lualine").setup({
  sections = {
    lualine_b = {
      "branch",
      "b:gitsigns_status",
      {
        "diagnostics",
        sources = {
          "nvim_diagnostic",
        },
      },
    },
    lualine_c = {
      "%{ObsessionStatus('', '')}",
      "filename",
    },
  },
  options = {
    theme = theme,
    section_separators = "",
    component_separators = "│",
  },
  extensions = {
    "nvim-tree",
    "toggleterm",
  },
})
