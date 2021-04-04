-- chain.moon
-- SFZILabs 2021

class Chain
    new: =>
        @middleware = {} -- {fn, fn, fn}

    use: (Callback) =>
        switch type Callback
            when 'function'
                table.insert @middleware, Callback

            when 'table'
                if Callback.run
                    @use (next, value) -> Callback\run value, -> next!
                else error 'chain: callback table should be a chain!'

            else
                error 'chain: use expects a callback!'

    run: (Payload, Callback) =>
        step = @middleware[1]
        assert step, 'chain: cannot run an empty chain!'

        i = 1
        runNext = nil

        next = (value) ->
            assert value == nil, 'chain: threw ' .. tostring value

            i += 1
            step = @middleware[i]

            if step
                runNext!
            elseif Callback
                Callback Payload

        runNext = -> step next, Payload

        runNext!
