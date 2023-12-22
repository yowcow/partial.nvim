local function get_range(f, t)
  return {
    from = { line = f[2], col = f[3] },
    to = { line = t[2], col = t[3] },
  }
end

local function get_input(from, to, lines)
  local before = ""
  local selected = {}
  local after = ""
  for i, v in ipairs(lines) do
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
