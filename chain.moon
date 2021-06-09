-- chain.moon
-- SFZILabs 2021

class Chain
    new: =>
        @Callbacks = {}

    use: (Fn) =>
        table.insert @Callbacks, Fn

    run: (...) =>
        I = 0
        Args = { ... }
        next = ->
            I += 1
            if Fn = @Callbacks[I]
                F = I
                Fn (unpack Args), (E) ->
                    if F == I
                        F = nil
                        assert E == nil, E
                        next!
        next!

    @Thru: (Fn) ->
        (...) ->
            Args = { ... }
            Next = table.remove Args
            Fn unpack Args
            Next!

    @Compose: (...) ->
        C = with Easy.Chain!
            \use F for F in *{...}

        (...) ->
            Args = { ... }
            Next = table.remove Args
            C\use -> Next!
            C\run unpack Args
