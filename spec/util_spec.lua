local util = require("util")

describe("util", function()
  describe("get_range", function()
    it("should convert getpos() inputs into a table", function()
      local actual = util.get_range({1, 2, 3, 4}, {5, 6, 7, 5})
      local expected = {
        from = { line = 2, col = 3 },
        to = { line = 6, col = 7 },
      }
      assert.are.same(expected, actual)
    end)
  end)

  describe("get_input", function()
    it("should get a whole line", function()
      local input = {"select 1"}
      local range = {
        from = {line = 1, col = 1},
        to = {line = 1, col = 2147483647},
      }
      local actual = util.get_input(range, input)
      local expected = {
        before = "",
        selected = {"select 1"},
        after = "",
      }
      assert.are.same(expected, actual)
    end)

    it("should get whole lines", function()
      local input = {"select count(1)", "from foo"}
      local range = {
        from = {line = 1, col = 1},
        to = {line = 2, col = 2147483647},
      }
      local actual = util.get_input(range, input)
      local expected = {
        before = "",
        selected = {"select count(1)", "from foo"},
        after = "",
      }
      assert.are.same(expected, actual)
    end)

    it("should get a part of a line", function()
      local input = {"$v = 'foobar';"}
      local range = {
        from = {line = 1, col = 7},
        to = {line = 1, col = 12},
      }
      local actual = util.get_input(range, input)
      local expected = {
        before = "$v = '",
        selected = {"foobar"},
        after = "';",
      }
      assert.are.same(expected, actual)
    end)

    it("should get a part of multiple lines", function()
      local input = {
        "$v = 'select count(1) from foo",
        "where bar = 1';",
      }
      local range = {
        from = {line = 1, col = 7},
        to = {line = 2, col = 13},
      }
      local actual = util.get_input(range, input)
      local expected = {
        before = "$v = '",
        selected = {
          "select count(1) from foo",
          "where bar = 1",
        },
        after = "';",
      }
      assert.are.same(expected, actual)
    end)
  end)

  describe("split_string", function()
    it("should split a string into a table", function()
      local input = "hoge-fuga-foo-bar"
      local actual = util.split_string(input, "-")
      local expected = {"hoge", "fuga", "foo", "bar"}
      assert.are.same(expected, actual)
    end)
  end)

  describe("finalize_output", function()
    it("should compose a table of output strings", function()
      local applied = {
        "select count(1)",
        "from foo",
      }
      local before = "$v = '"
      local after = "';"
      local actual = util.finalize_output(before, applied, after)
      local expected = {
        "$v = 'select count(1)",
        "from foo';",
      }
      assert.are.same(expected, actual)
    end)
  end)
end)
