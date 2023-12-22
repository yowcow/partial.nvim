partial.nvim
============

Applies arbitrary command to a buffer/visual selection.

HOW TO USE
----------

Set up like:

```lua
require "partial".setup {
  json = {"jq", "."},
  sql = {"sql-formatter", "--config", vim.fn.expand("~/.config/sql-formatter/config.json")},
  xml = {"xmllint", "--format", "-"},
  yml = {"yamlfmt"},
}
```

When formatting a JSON string section in a file, visual select the section and do:

```
:'<,'>lua require("partial").apply("json")
```

or call an alias to the function as:

```
:'<,'>Partial json
```
