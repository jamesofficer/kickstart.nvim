return {
  'stevearc/conform.nvim',
  opts = {},
  config = function()
    local conform = require 'conform'

    conform.setup {
      formatters_by_ft = {
        lua = { 'stylua' },
        -- Conform will run multiple formatters sequentially
        python = { 'isort', 'black' },
        -- You can customize some of the format options for the filetype (:help conform.format)
        rust = { 'rustfmt', lsp_format = 'fallback' },
        -- Conform will run the first available formatter
        javascript = { 'biome', 'prettierd', 'prettier', stop_after_first = true },
      },
      format_on_save = function(bufnr)
        -- Disable autoformat for files in a certain path ("node_modules" in this case).
        local bufname = vim.api.nvim_buf_get_name(bufnr)

        if bufname:match '/node_modules/' then
          return
        end

        return {
          timeout_ms = 500,
          lsp_fallback = 'fallback',
        }
      end,
    }

    vim.api.nvim_create_autocmd('BufWritePre', {
      pattern = '*',
      callback = function(args)
        require('conform').format { bufnr = args.buf }
      end,
    })
  end,
}
