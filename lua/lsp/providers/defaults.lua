local config = require('config')
local M = {}

local auto_format_lock = false

function M.on_attach(client, bufnr)
  local function buf_set_option(...)
    vim.api.nvim_buf_set_option(bufnr, ...)
  end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  if config.lsp.can_client_format(client.name) then
    client.resolved_capabilities.document_formatting = true
    client.resolved_capabilities.document_range_formatting = true
    -- check user config to see if we can format on save
    if config.lsp.format_on_save and not auto_format_lock then
      auto_format_lock = true -- just run autocommand once
      local format_filetypes = ''
      if vim.tbl_islist(config.lsp.format_on_save) then
        for _, ft in pairs(config.lsp.format_on_save) do
          format_filetypes = format_filetypes .. '*' .. ft
        end
      else
        format_filetypes = '*'
      end
      vim.cmd(([[
          augroup LspFormat
          autocmd!
          autocmd BufWritePre %s lua vim.lsp.buf.formatting_sync(nil, 2000)
          augroup END
        ]]):format(format_filetypes))
    end
  else
    client.resolved_capabilities.document_formatting = false
    client.resolved_capabilities.document_range_formatting = false
  end

  require('lsp.mappings').init(client, bufnr)
end

M.flags = {
  debounce_text_changes = 150,
}

local function make_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  if pcall(require, 'cmp_nvim_lsp') then
    capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
  end
  return capabilities
end

M.capabilities = make_capabilities()

M.root_dir = function(fname)
  local util = require('lspconfig').util
  return util.root_pattern('.git')(fname)
    or util.root_pattern('tsconfig.base.json')(fname)
    or util.root_pattern('package.json')(fname)
    or util.root_pattern('.eslintrc.js')(fname)
    or util.root_pattern('tsconfig.json')(fname)
end

M.autostart = true

M.single_file_mode = true

return M
