return {
  {
    "folke/persistence.nvim",
    lazy = false,
    config = function()
      require("persistence").setup({})
      if vim.fn.argc(-1) == 0 then
        vim.schedule(function()
          require("persistence").load()
        end)
      end
    end,
    keys = {
      { "<leader>qs", function() require("persistence").load() end,                desc = "[Q]uit: restore [S]ession for cwd" },
      { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "[Q]uit: restore [L]ast session" },
      { "<leader>qd", function() require("persistence").stop() end,                desc = "[Q]uit: [D]on't save session" },
    },
  },

  { "ellisonleao/glow.nvim", config = true, cmd = "Glow" },

  {
    "numToStr/FTerm.nvim",
    config = function()
      require("FTerm").setup({
        blend = 5,
        dimensions = {
          height = 0.90,
          width = 0.90,
          x = 0.5,
          y = 0.5,
        },
      })
    end,
  },

  {
    "michaelrommel/nvim-silicon",
    lazy = true,
    cmd = "Silicon",
    init = function()
      vim.keymap.set("n", "<leader>cs", "<cmd>Silicon<CR>", { desc = "[C]ode [S]creenshot File (Silicon)" })
      vim.keymap.set("v", "<leader>cs", ":Silicon<CR>", { desc = "[C]ode [S]creenshot (Silicon)" })
    end,
    config = function()
      require("nvim-silicon").setup({
        disable_defaults = true,
        theme = "Nord",
        font = "0xProto=32",
        num_separator = "| ",
        to_clipboard = true,
        language = function()
          return vim.bo.filetype ~= "" and vim.bo.filetype or "bash"
        end,
        window_title = function()
          return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()), ":t")
        end,
        -- output = "test_code.png",
      })
    end,
  },
}
