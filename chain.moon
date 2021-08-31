-- chain.moon
-- SFZILabs 2021

matcher = (T) ->
    (next, skip, payload) ->
        unless payload
            payload = skip

        for i, v in pairs T
            if payload[i] != v
                return if skip
                    skip!
        
        next!

class Chain
    new: =>
        @Callbacks = {}

    use: (...) =>
        Args = { ... }
        assert Args[1], 'chain: use expects a callback!'
        table.insert @Callbacks, if #Args == 1
            Args[1]
        else Chain.Compose ...

    run: (...) =>
        I = 0
        Args = { ... }
        next = ->
            I += 1
            if Fn = @Callbacks[I]
                F = I
                Fn = matcher Fn if 'table' == type Fn

                callback = (E) ->
                    if F == I -- prevent double execution
                        F = nil
                        assert E == nil, E
                        next!

                Fn callback, unpack Args
        next!

    @Thru: (Fn) ->
        (...) ->
            Args = { ... }
            Next = table.remove Args, 1
            Fn unpack Args
            Next!

    @Compose: (...) ->
        C = with Chain!
            \use F for F in *{...}

        (...) ->
            Args = {...}
            Next = table.remove Args, 1
            C\use -> Next!
            C\run Next, unpack Args
