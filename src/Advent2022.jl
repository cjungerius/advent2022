module Advent2022

using BenchmarkTools

solvedDays = 1:24

#include and export all solved days
for day in solvedDays
    d = string(day, pad=2)
    include(string(day, pad=2) * ".jl")
    global modSymbol = Symbol("Day" * d)
    @eval begin
        export $modSymbol
    end
end

function benchmark(days=solvedDays)
    results = []
    for day in days
        d = string(day, pad=2)
        modSymbol = Symbol("Day" * d)
        fSymbol = Symbol("solutions")
        @eval begin
            bresult = @benchmark(Advent2022.$modSymbol.$fSymbol())
        end
        push!(results, (day, time(bresult), memory(bresult)))
    end
    return results
end

end
