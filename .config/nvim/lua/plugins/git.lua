return {
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        add = { text = "│" },
        change = { text = "" },
        delete = { text = "󰍵" },
        topdelete = { text = "‾" },
        changedelete = { text = "󰜥" },
        untracked = { text = "󰇙" },
      },
    },
  },

  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
    keys = {
      { "<leader>gv", "<cmd>DiffviewOpen<cr>",                                         desc = "[G]it diff[V]iew" },
      { "<leader>gf", "<cmd>DiffviewFileHistory %<cr>",                                desc = "[G]it [F]ile history" },
      { "<leader>gF", "<cmd>DiffviewFileHistory<cr>",                                  desc = "[G]it [F]ull repo history" },
      { "<leader>gC", "<cmd>DiffviewOpen HEAD^!<cr>",                                  desc = "[G]it [C]urrent commit" },
      { "<leader>gc", function()
          vim.ui.input({ prompt = "Commit: " }, function(commit)
            if commit and commit ~= "" then
              vim.cmd("DiffviewOpen " .. commit .. "^!")
            end
          end)
        end,                                                                            desc = "[G]it open [c]ommit diff" },
      { "<leader>gx", "<cmd>DiffviewClose<cr>",                                        desc = "[G]it close diff [X]" },
    },
  },

  {
    "FabijanZulj/blame.nvim",
    lazy = false,
    config = function()
      require("blame").setup({})
    end,
    opts = {
      blame_options = { "-w" },
    },
  },
}
