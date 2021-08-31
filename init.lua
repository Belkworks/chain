local matcher
matcher = function(T)
  return function(next, skip, payload)
    if not (payload) then
      payload = skip
    end
    for i, v in pairs(T) do
      if payload[i] ~= v then
        if skip then
          return skip()
        end
      end
    end
    return next()
  end
end
local Chain
do
  local _class_0
  local _base_0 = {
    use = function(self, ...)
      local Args = {
        ...
      }
      assert(Args[1], 'chain: use expects a callback!')
      return table.insert(self.Callbacks, (function(...)
        if #Args == 1 then
          return Args[1]
        else
          return Chain.Compose(...)
        end
      end)(...))
    end,
    run = function(self, ...)
      local I = 0
      local Args = {
        ...
      }
      local next
      next = function()
        I = I + 1
        do
          local Fn = self.Callbacks[I]
          if Fn then
            local F = I
            if 'table' == type(Fn) then
              Fn = matcher(Fn)
            end
            local callback
            callback = function(E)
              if F == I then
                F = nil
                assert(E == nil, E)
                return next()
              end
            end
            return Fn(callback, unpack(Args))
          end
        end
      end
      return next()
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self)
      self.Callbacks = { }
    end,
    __base = _base_0,
    __name = "Chain"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  local self = _class_0
  self.Thru = function(Fn)
    return function(...)
      local Args = {
        ...
      }
      local Next = table.remove(Args, 1)
      Fn(unpack(Args))
      return Next()
    end
  end
  self.Compose = function(...)
    local C
    do
      local _with_0 = Chain()
      local _list_0 = {
        ...
      }
      for _index_0 = 1, #_list_0 do
        local F = _list_0[_index_0]
        _with_0:use(F)
      end
      C = _with_0
    end
    return function(...)
      local Args = {
        ...
      }
      local Next = table.remove(Args, 1)
      C:use(function()
        return Next()
      end)
      return C:run(Next, unpack(Args))
    end
  end
  Chain = _class_0
  return _class_0
end
