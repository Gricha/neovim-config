return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      local util = require("lspconfig.util")
      opts.servers = opts.servers or {}

      opts.servers.denols = {
        enabled = false,
        root_dir = util.root_pattern("deno.json", "deno.jsonc"),
      }

      opts.servers.vtsls = vim.tbl_deep_extend("force", opts.servers.vtsls or {}, {
        root_dir = function(bufnr, on_dir)
          local fname = vim.api.nvim_buf_get_name(bufnr)
          local found = util.root_pattern("tsconfig.json", "package.json")(fname) or util.find_git_ancestor(fname)
          if found then
            on_dir(found)
          end
        end,
        single_file_support = true,
      })

      opts.servers.eslint = vim.tbl_deep_extend("force", opts.servers.eslint or {}, {
        root_dir = function(bufnr, on_dir)
          local fname = vim.api.nvim_buf_get_name(bufnr)
          local found = util.root_pattern(
            "eslint.config.js",
            "eslint.config.mjs",
            "eslint.config.cjs",
            ".eslintrc",
            ".eslintrc.js",
            ".eslintrc.cjs",
            ".eslintrc.json",
            "package.json"
          )(fname) or util.find_git_ancestor(fname)
          if found then
            on_dir(found)
          end
        end,
        settings = {
          workingDirectories = { mode = "auto" },
          experimental = { useFlatConfig = true },
        },
      })
    end,
  },
}
