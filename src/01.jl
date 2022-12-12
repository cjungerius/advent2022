module Day01

function solve(io::IO)

    elves = Int[0]
    x::Union{Nothing,Int} = nothing

    for line in eachline(io)
        x = tryparse(Int, line; base=10)
        if !isnothing(x)
            elves[end] += x
        else
            push!(elves, 0)
        end
    end

    maxvals = partialsort!(elves, 1:3, rev=true)
    maxvals[1], sum(maxvals[1:3])
end

function solutions(io::String="data/01.txt")
    partone, parttwo = solve(open(io))
end

end
