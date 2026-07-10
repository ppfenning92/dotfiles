vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- nvim-treesitter's main branch does not auto-enable highlighting; start it per
-- buffer whenever a parser exists. Without this, filetypes that have no built-in
-- Vim syntax file (e.g. `helm`) render with no highlighting at all.
vim.api.nvim_create_autocmd("FileType", {
  desc = "Start Treesitter highlighting when a parser is available",
  group = vim.api.nvim_create_augroup("treesitter-highlight", { clear = true }),
  callback = function(args)
    local ft = vim.bo[args.buf].filetype
    -- Map compound filetypes (e.g. "yaml.helm-values", "yaml.gitlab") to a real
    -- parser; get_lang() returns nil for these so vim.treesitter.start would fail.
    local lang = vim.treesitter.language.get_lang(ft)
    if not lang and ft:find("%.") then
      local base = ft:gsub("%..*$", "")
      lang = vim.treesitter.language.get_lang(base) or base
    end
    pcall(vim.treesitter.start, args.buf, lang)
  end,
})
