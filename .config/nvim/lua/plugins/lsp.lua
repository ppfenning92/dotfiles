---@diagnostic disable: missing-fields
vim.lsp.log.set_level(vim.lsp.log.levels.WARN)

return {
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },

  { "qvalentin/helm-ls.nvim", ft = "helm" },
  { "grafana/vim-alloy", ft = "alloy" },

  { "j-hui/fidget.nvim", opts = {} },

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "williamboman/mason.nvim", opts = {} },
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      -- helm-ls.nvim's ftdetect maps every `*/templates/*.yaml` to the `helm`
      -- filetype. GitLab CI component repos also use a `templates/` dir, so only
      -- treat these as helm when an actual chart (`Chart.yaml`) is found upward;
      -- otherwise leave them as plain yaml so the GitLab CI schema applies.
      vim.filetype.add({
        pattern = {
          [".*/templates/.*%.ya?ml"] = {
            priority = 10,
            function(path)
              local found = vim.fs.find("Chart.yaml", { path = vim.fs.dirname(path), upward = true })
              return #found > 0 and "helm" or "yaml"
            end,
          },
        },
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or "n"
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
          map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
          map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
          map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
          map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
          map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
          map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
          map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })
          map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
            local augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              buffer = event.buf,
              group = augroup,
              callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
              buffer = event.buf,
              group = augroup,
              callback = vim.lsp.buf.clear_references,
            })
            vim.api.nvim_create_autocmd("LspDetach", {
              group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds({ group = "lsp-highlight", buffer = event2.buf })
              end,
            })
          end

          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            map("<leader>th", function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
            end, "[T]oggle Inlay [H]ints")
          end
        end,
      })

      if vim.g.have_nerd_font then
        local signs = { ERROR = "", WARN = "", INFO = "", HINT = "" }
        local diagnostic_signs = {}
        for type, icon in pairs(signs) do
          diagnostic_signs[vim.diagnostic.severity[type]] = icon
        end
        vim.diagnostic.config({
          signs = { text = diagnostic_signs, severity = { min = vim.diagnostic.severity.WARN } },
          virtual_text = { prefix = "●", spacing = 4 },
          float = false,
        })
      end

      vim.lsp.config("*", {
        capabilities = vim.tbl_deep_extend(
          "force",
          vim.lsp.protocol.make_client_capabilities(),
          require("cmp_nvim_lsp").default_capabilities()
        ),
      })

      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            hint = { enabled = true },
            completion = { callSnippet = "Replace" },
          },
        },
      })

      vim.lsp.config("yamlls", {
        settings = {
          yaml = {
            schemas = {
              kubernetes = { "*.yaml", "!values*.{yml,yaml}", "!**/values*.{yml,yaml}", "!Chart.{yml,yaml}" },
              ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
              ["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
              ["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/*.{yml,yaml}",
              ["http://json.schemastore.org/prettierrc"] = ".prettierrc.{yml,yaml}",
              ["http://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
              ["http://json.schemastore.org/ansible-playbook"] = "*play*.{yml,yaml}",
              ["http://json.schemastore.org/chart"] = "Chart.{yml,yaml}",
              ["https://json.schemastore.org/dependabot-v2"] = ".github/dependabot.{yml,yaml}",
              ["https://gitlab.com/gitlab-org/gitlab-foss/-/raw/master/app/assets/javascripts/editor/schema/ci.json"] = {
                "*gitlab-ci*.{yml,yaml}",
                "**/templates/**/*.{yml,yaml}",
              },
              ["https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.json"] = "*api*.{yml,yaml}",
              ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "*docker-compose*.{yml,yaml}",
              ["https://raw.githubusercontent.com/argoproj/argo-workflows/master/api/jsonschema/schema.json"] = "*flow*.{yml,yaml}",
            },
          },
        },
      })

      vim.lsp.config("helm_ls", {
        settings = {
          ["helm-ls"] = {
            logLevel = "info",
            valuesFiles = {
              mainValuesFile = "values.yaml",
              lintOverlayValuesFile = "values.lint.yaml",
              additionalValuesFilesGlobPattern = "values*.yaml",
            },
            helmLint = { enabled = true, ignoredMessages = {} },
            yamlls = {
              enabled = true,
              enabledForFilesGlob = "*.{yaml,yml}",
              diagnosticsLimit = 50,
              showDiagnosticsDirectly = false,
              path = "yaml-language-server",
              initTimeoutSeconds = 3,
              config = {
                schemas = { kubernetes = "templates/**" },
                completion = true,
                hover = true,
              },
            },
          },
        },
      })

      vim.lsp.enable({
        "gopls",
        "ts_ls",
        "lua_ls",
        "terraformls",
        "yamlls",
        "helm_ls",
        "bashls",
      })

      require("mason-tool-installer").setup({
        ensure_installed = {
          "gopls",
          "typescript-language-server",
          "lua-language-server",
          "terraform-ls",
          "yaml-language-server",
          "helm-ls",
          "bash-language-server",
          "shfmt",
          "shellcheck",
          "stylua",
          "prettierd",
          "goimports",
          "black",
          "isort",
          "taplo",
        },
      })
    end,
  },
}
