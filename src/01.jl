module Day01

function solve(io::IO)

    #input = tryparse.(Int, input)

    elves = Int[0]
    x::Union{Nothing,Int} = nothing

    for line in eachline(io)
        x = tryparse(Int,line;base=10)
        if !isnothing(x)
            elves[end] += x
        else
            push!(elves, 0)
        end
    end

    maxvals = partialsort!(elves,1:3,rev=true)
end

partone(io::IO=open("data/01.txt")) = solve(io)[1]
parttwo(io::IO=open("data/01.txt")) = sum(solve(io))

end
