module Day01

input = readlines("input.txt")

function calories(input)

    input = tryparse.(Int, input)
    elves = [0]

    for line in input
        if !isnothing(line)
            elves[end] += line
        else
            push!(elves, 0)
        end
    end

    maxvals = partialsort!(elves,1:3,rev=true)
    partone = maxvals[1]
    parttwo = sum(maxvals)

    (partone, parttwo)
end

partone, parttwo = calories(input)

end