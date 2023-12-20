local api = vim.api
local fn = vim.fn

local config = {}

local function setup(c)
  config = vim.tbl_deep_extend("force", config, c)
end

local function get_range(f, t)
  return {
    from = { line = f[2], col = f[3] },
    to = { line = t[2], col = t[3] },
  }
end

local function get_input(from, to)
  local before = ""
  local selected = {}
  local after = ""
  for i, v in ipairs(api.nvim_buf_get_lines(0, from.line-1, to.line, true)) do
    local curline = from.line+i-1
    if curline == from.line then
      before = string.sub(v, 0, from.col-1)
      table.insert(selected, string.sub(v, from.col))
    elseif curline == to.line then
      table.insert(selected, string.sub(v, 0, to.col))
      if #v > to.col then -- forget the remainder if the line is not as long as col index
        after = string.sub(v, to.col+1)
      end
    else
      table.insert(selected, v)
    end
  end
  return {
    before = before,
    selected = selected,
    after = after,
  }
end

local function string_split(input, sep)
  local output = {}
  for str in string.gmatch(input, "([^"..sep.."]+)") do
    table.insert(output, str)
  end
  return output
end

local function finalize_output(result, selection)
  local count = (result and #result or 0)
  if count > 0 then
    result[1] = selection.before..result[1]
    result[count] = result[count]..selection.after
  end
  return result
end

local function set_output(formatted, from, to)
  api.nvim_buf_set_lines(0, from.line-1, to.line, true, formatted)
end

local function apply(name)
  local range = get_range(fn.getpos("'<"), fn.getpos("'>"))
  local selection = get_input(range.from, range.to)
  local formatted = string_split(fn.system(config[name], table.concat(selection.selected, "\n")), "\r\n")
  set_output(finalize_output(formatted, selection), range.from, range.to)
end

return {
  setup = setup,
  apply = apply,
}
