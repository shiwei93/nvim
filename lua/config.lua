local servers = {
  bashls = {
    format = false,
  },
  jsonls = {
    format = false,
  },
  sumneko_lua = {
    format = false, -- disable formatting all together
  },
  html = false,
  graphql = false,
  tsserver = {
    format = false, -- disable formatting all together
  },
  cssls = {
    format = false,
  },
  tailwindcss = {
    forma = false,
  },
}

local user_servers = vim.tbl_keys(servers)

local config = {
  border = 'rounded',
  theme = 'tokyonight',
  lsp = {
    format_on_save = true, -- true/false or table of filetypes {'.ts', '.js',}
    rename_notification = true,
    can_client_format = function(client_name)
      if servers[client_name] == true then
        return true
      end
      if vim.tbl_contains(user_servers, client_name) and servers[client_name] then
        return servers[client_name].format
      end
      return true
    end,
    -- vim.diagnostic.config settiings
    servers = servers,
  },
}

return config
