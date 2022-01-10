local M = {}

M.setup = function()
    local treesitter = require "nvim-treesitter.configs"

    treesitter.setup {
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
            disable = { "latex" },
        },
        ensure_installed = "maintained",
        autotag = {
            enable = true,
        },
        rainbow = {
            enable = true,
            extended_mode = false,
            max_file_lines = nil,
        },
    }
end

return M
