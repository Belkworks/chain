local Chain
do
  local _class_0
  local _base_0 = {
    use = function(self, Callback)
      local _exp_0 = type(Callback)
      if 'function' == _exp_0 then
        return table.insert(self.middleware, Callback)
      elseif 'table' == _exp_0 then
        if Callback.run then
          return self:use(function(next, value)
            return Callback:run(value, function()
              return next()
            end)
          end)
        else
          return error('chain: callback table should be a chain!')
        end
      else
        return error('chain: use expects a callback!')
      end
    end,
    run = function(self, Payload, Callback)
      local step = self.middleware[1]
      assert(step, 'chain: cannot run an empty chain!')
      local i = 1
      local next
      next = function(value)
        assert(value == nil, 'chain: threw ' .. tostring(value))
        i = i + 1
        step = self.middleware[i]
        if step then
          return step(next, Payload)
        elseif Callback then
          return Callback(Payload)
        end
      end
      return step(next, Payload)
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self)
      self.middleware = { }
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
  Chain = _class_0
  return _class_0
end
