return {
  {
    "folke/which-key.nvim",
    event = "VimEnter",
    opts = {
      delay = 750,
      icons = {
        mappings = vim.g.have_nerd_font,
        keys = vim.g.have_nerd_font and {} or {
          Up = "<Up> ",
          Down = "<Down> ",
          Left = "<Left> ",
          Right = "<Right> ",
          C = "<C-…> ",
          M = "<M-…> ",
          D = "<D-…> ",
          S = "<S-…> ",
          CR = "<CR> ",
          Esc = "<Esc> ",
          ScrollWheelDown = "<ScrollWheelDown> ",
          ScrollWheelUp = "<ScrollWheelUp> ",
          NL = "<NL> ",
          BS = "<BS> ",
          Space = "<Space> ",
          Tab = "<Tab> ",
          F1 = "<F1>",
          F2 = "<F2>",
          F3 = "<F3>",
          F4 = "<F4>",
          F5 = "<F5>",
          F6 = "<F6>",
          F7 = "<F7>",
          F8 = "<F8>",
          F9 = "<F9>",
          F10 = "<F10>",
          F11 = "<F11>",
          F12 = "<F12>",
        },
      },
      spec = {
        { "<leader>c", group = "[C]ode", mode = { "n", "x" } },
        { "<leader>d", group = "[D]ocument" },
        { "<leader>r", group = "[R]ename" },
        { "<leader>s", group = "[S]earch" },
        { "<leader>w", group = "[W]orkspace" },
        { "<leader>t", group = "[T]oggle" },
        { "<leader>h", group = "Git [H]unk", mode = { "n", "v" } },
      },
    },
  },

  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    commit = "8edd468",
    cond = function()
      return not (vim.env.DOTFILES_ENV or ""):match("^ssh%-")
    end,
    config = function()
      local flavours = { mac = "mocha", wsl = "frappe" }
      require("catppuccin").setup({ flavour = flavours[vim.env.DOTFILES_ENV] or "mocha" })
      vim.cmd.colorscheme("catppuccin")
    end,
  },

  {
    "rebelot/kanagawa.nvim",
    priority = 1000,
    cond = function()
      return vim.env.DOTFILES_ENV == "ssh-ubuntu"
    end,
    config = function()
      require("kanagawa").setup({ theme = "wave" })
      vim.cmd.colorscheme("kanagawa-wave")
    end,
  },

  {
    "folke/tokyonight.nvim",
    priority = 1000,
    cond = function()
      return vim.env.DOTFILES_ENV == "ssh-arch"
    end,
    config = function()
      require("tokyonight").setup({ style = "night" })
      vim.cmd.colorscheme("tokyonight-night")
    end,
  },

  {
    "shaunsingh/nord.nvim",
    priority = 1000,
    cond = function()
      local env = vim.env.DOTFILES_ENV or ""
      return env ~= "mac" and env ~= "wsl" and env ~= "ssh-ubuntu" and env ~= "ssh-arch"
    end,
    config = function()
      vim.cmd.colorscheme("nord")
    end,
  },

  {
    "echasnovski/mini.nvim",
    config = function()
      require("mini.ai").setup({ n_lines = 500 })

      local notify = require("mini.notify")
      notify.setup()
      vim.keymap.set("n", "<leader>nh", MiniNotify.show_history, { desc = "[N]otification [H]istory" })
      vim.notify = notify.make_notify({
        DEBUG = { duration = 5000 },
        INFO = { duration = 5000 },
        WARN = { duration = 5000 },
        ERROR = { duration = 5000 },
      })
      --[[
      -- working shortcut modifier on macos and ghostty with tmux
      --
      -- Ctrl <C-...>
      -- Alt/Option <M-...>
      -- Alt+Shift <MS-...>
      -- Ctrl+Alt <CM-...>
      -- Shift <S-...>
      --]]

      local tabline = require("mini.tabline")
      tabline.setup({
        format = function(buf_id, label)
          local suffix = vim.bo[buf_id].modified and " " or ""
          return tabline.default_format(buf_id, label) .. suffix
        end,
      })

      vim.keymap.set("n", "<tab>", "<cmd>bnext<CR>")
      vim.keymap.set("n", "<S-tab>", "<cmd>bprevious<CR>")
      vim.keymap.set("n", "<leader>bn", "<cmd>badd new file|blast<CR>", { desc = "[B]uffer [N]ew" })
      vim.keymap.set("n", "<leader>x", "<cmd>bdelete<CR>", { desc = "Close current buffer" })

      require("mini.starter").setup()

      local map = require("mini.map")
      map.setup({
        integrations = {
          map.gen_integration.builtin_search(),
          map.gen_integration.diff(),
          map.gen_integration.diagnostic(),
        },
      })

      vim.keymap.set("n", "<Leader>mt", map.toggle, { desc = "Toggle minimap" })
      vim.keymap.set("n", "<Leader>mc", map.close, { desc = "Close minimap" })
      vim.keymap.set("n", "<Leader>mf", map.toggle_focus, { desc = "Focus minimap" })
      vim.keymap.set("n", "<Leader>mo", map.open, { desc = "Open minimap" })
      vim.keymap.set("n", "<Leader>mr", map.refresh, { desc = "Refresh minimap" })
      vim.keymap.set("n", "<Leader>ms", map.toggle_side, { desc = "Toggle minimap side" })

      require("mini.move").setup({
        {
          mappings = {
            left = "<M-h>",
            right = "<M-l>",
            down = "<M-j>",
            up = "<M-k>",
            line_left = "<M-h>",
            line_right = "<M-l>",
            line_down = "<M-j>",
            line_up = "<M-k>",
          },
          options = { reindent_linewise = true },
        },
      })

      local files = require("mini.files")
      files.setup({
        mappings = {
          go_in = "L",
          go_in_plus = "l",
        },
        windows = {
          preview = true,
          width_focus = 30,
          width_nofocus = 15,
          width_preview = 80,
        },
      })

      vim.keymap.set("n", "<M-n>", files.open, { desc = "Open MiniFiles" })

      require("mini.surround").setup()
      require("mini.jump").setup()
      require("mini.bracketed").setup()
      -- require("mini.folds").setup()
      require("mini.pairs").setup()
      require("mini.comment").setup()
      require("mini.operators").setup()
      require("mini.indentscope").setup()

      local statusline = require("mini.statusline")
      statusline.setup({ use_icons = vim.g.have_nerd_font })

      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return "%2l:%-2v"
      end
    end,
  },

  {
    "folke/noice.nvim",
    event = "VeryLazy",
    config = function()
      require("noice").setup({
        messages = { enabled = false },
        notify = { enabled = false },
        cmdline = {
          format = {
            filter = { lang = "zsh" },
          },
        },
        views = {
          cmdline_popup = { win_options = { winblend = 0 } },
          popupmenu = { win_options = { winblend = 0 } },
        },
        -- routes = {
        --   {
        --     view = "notify",
        --     filter = { event = "msg_showmode" },
        --   },
        -- },
      })
    end,
  },

  "xiyaowong/nvim-transparent",

  {
    "HiPhish/rainbow-delimiters.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },

  {
    "brenoprata10/nvim-highlight-colors",
    opts = {
      render = "virtual",
      enable_named_colors = false,
      virtual_symbol_position = "eol",
    },
  },
}
