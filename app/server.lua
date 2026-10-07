exports = {}
local function read_count()
  local ok, record = ctx.store.get("counter", nil)
  if not ok then error(record) end
  return record and record.data.count or 0
end
function exports.read()
  return { count = read_count() }
end
function exports.increment()
  local ok, record = ctx.store.put("counter", { count = read_count() + 1 }, nil)
  if not ok then error(record) end
  return { count = record.data.count }
end
