if vim.g.loaded_partial then
  return
end
vim.g.loaded_partial = true

vim.cmd([[command -range -nargs=1 Partial lua require("partial").apply(<f-args>)]])
