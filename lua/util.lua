local function get_range(f, t)
  return {
    from = { line = f[2], col = f[3] },
    to = { line = t[2], col = t[3] },
  }
end

local function get_input(range, lines)
  local before = ""
  local selected = {}
  local after = ""
  for i, v in ipairs(lines) do
    local curline = range.from.line+(i-1)
    if curline == range.to.line then
      if #v > range.to.col then -- forget the remainder if the line is not as long as col index
        after = string.sub(v, range.to.col+1)
      end
      v = string.sub(v, 0, range.to.col)
    end
    if curline == range.from.line then
      before = string.sub(v, 0, range.from.col-1)
      v = string.sub(v, range.from.col)
    end
    table.insert(selected, v)
  end
  return {
    before = before,
    selected = selected,
    after = after,
  }
end

local function split_string(input, sep)
  local output = {}
  for str in string.gmatch(input, "([^"..sep.."]+)") do
    table.insert(output, str)
  end
  return output
end

local function finalize_output(before, applied, after)
  local count = (applied and #applied or 0)
  if count > 0 then
    applied[1] = before..applied[1]
    applied[count] = applied[count]..after
  end
  return applied
end

return {
  get_range = get_range,
  get_input = get_input,
  split_string = split_string,
  finalize_output = finalize_output,
}
