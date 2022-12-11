input = readlines("input.txt")

function createstacks(input)

    stacklocs = [2:4:length(input[1])...]
    stacks = [[] for i in 1:length(stacklocs)]
    stackinput = input[end:-1:1]

    for level in stackinput
        for (i, loc) in enumerate(stacklocs)
            isletter(level[loc]) && push!(stacks[i], level[loc])
        end
    end

    stacks
end

function cargocrane(input)
    
    splitidx = findfirst(x->length(x)==0, input)
    stacks = createstacks(input[1:splitidx-1])

    for instruction in input[splitidx+1:end]
        n, source, dest = filter(!isnothing, tryparse.(Int, split(instruction, " ")))
        for i in 1:n
            push!(stacks[dest], pop!(stacks[source]))
        end
    end

    *([s[end] for s in stacks]...)
end

function newcargocrane(input)
    
    splitidx = findfirst(x->length(x)==0, input)
    stacks = createstacks(input[1:splitidx-1])

    for instruction in input[splitidx+1:end]
       n, source, dest = filter(!isnothing, tryparse.(Int, split(instruction, " ")))
        push!(stacks[dest],
            splice!(stacks[source], length(stacks[source])-n+1:length(stacks[source]))...)
    end

    *([s[end] for s in stacks]...)
end

partone, parttwo = (cargocrane(input), newcargocrane(input))
