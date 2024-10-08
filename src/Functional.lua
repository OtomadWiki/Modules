local F = {}

function F.dot(f, g)
    return function(...)
        local args = {...}
        return f(g(unpack(args)))
    end
end

function F.call(f, x) return f(x) end

function F.fmap(f, functor) return functor.fmap(f) end

return F
