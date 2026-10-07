local t = require("test")
local subject = require("cococo.subject")
local saved, failure, writes = nil, nil, 0

t.mock.host("ctx.store.get"):using(function(name, schema)
  t.expect(name):eq("counter")
  t.expect(schema):is_nil()
  if failure == "read" then return false, nil end
  return true, saved
end)
t.mock.host("ctx.store.put"):using(function(name, data, schema)
  t.expect(name):eq("counter")
  t.expect(schema):is_nil()
  writes = writes + 1
  if failure == "write" then return false, nil end
  saved = { name = name, data = { count = data.count } }
  return true, saved
end)

t.describe("persistent counter API", function()
  t.it("starts at zero without writing on a read", function()
    saved, failure, writes = nil, nil, 0
    t.expect(subject.load().read().count):eq(0)
    t.expect(writes):eq(0)
  end)
  t.it("persists increments across fresh API instances", function()
    saved, failure, writes = nil, nil, 0
    t.expect(subject.load().increment().count):eq(1)
    t.expect(subject.load().read().count):eq(1)
    t.expect(subject.load().increment().count):eq(2)
    t.expect(subject.load().read().count):eq(2)
    t.expect(writes):eq(2)
  end)
  t.it("does not overwrite state when reading fails", function()
    saved, failure, writes = { name = "counter", data = { count = 7 } }, "read", 0
    local ok = pcall(function() return subject.load().increment() end)
    t.expect(ok):eq(false)
    t.expect(writes):eq(0)
    t.expect(saved.data.count):eq(7)
  end)
  t.it("reports save failures instead of claiming success", function()
    saved, failure, writes = { name = "counter", data = { count = 7 } }, "write", 0
    local ok = pcall(function() return subject.load().increment() end)
    t.expect(ok):eq(false)
    t.expect(writes):eq(1)
    t.expect(saved.data.count):eq(7)
  end)
end)
