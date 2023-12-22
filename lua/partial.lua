local util = require("util")

local api = vim.api
local fn = vim.fn
local config = {}

local function setup(c)
  config = vim.tbl_deep_extend("force", config, c)
end

local function apply(name)
  local range = util.get_range(fn.getpos("'<"), fn.getpos("'>"))
  local selection = util.get_input(range, api.nvim_buf_get_lines(0, range.from.line-1, range.to.line, true))
  local applied = util.split_string(fn.system(config[name], table.concat(selection.selected, "\n")), "\r\n")
  local formatted = util.finalize_output(selection.before, applied, selection.after)
  api.nvim_buf_set_lines(0, range.from.line-1, range.to.line, true, formatted)
end

return {
  setup = setup,
  apply = apply,
}
