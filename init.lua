local Chain
do
  local _class_0
  local _base_0 = {
    use = function(self, Fn)
      return table.insert(self.Callbacks, Fn)
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
            return Fn((unpack(Args)), function(E)
              if F == I then
                F = nil
                assert(E == nil, E)
                return next()
              end
            end)
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
      local Next = table.remove(Args)
      Fn(unpack(Args))
      return Next()
    end
  end
  self.Compose = function(...)
    local C
    do
      local _with_0 = Easy.Chain()
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
      local Next = table.remove(Args)
      C:use(function()
        return Next()
      end)
      return C:run(unpack(Args))
    end
  end
  Chain = _class_0
  return _class_0
end
