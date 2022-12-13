module Day05

function createstacks(stackinput)

    stacklocs = [2:4:length(stackinput[1])...]
    stacks = [[] for i in 1:length(stacklocs)]
    
    for level in reverse(stackinput)
        for (i, loc) in enumerate(stacklocs)
            isletter(level[loc]) && push!(stacks[i], level[loc])
        end
    end

    stacks
end

function cargocrane(io, new=false)

    stackinput = String[]
    el = eachline(io)

    for line in el
        length(line) == 0 && break
        push!(stackinput, line)
    end

    stacks = createstacks(stackinput)

    for instruction in el
        n, source, dest = filter(!isnothing, tryparse.(Int, split(instruction, " ")))
        if new
            push!(stacks[dest],
                splice!(stacks[source], length(stacks[source])-n+1:length(stacks[source]))...)
        else
            for i in 1:n
                push!(stacks[dest], pop!(stacks[source]))
            end
        end
    end

    *([s[end] for s in stacks]...)
end

function solutions(io::String=joinpath(@__DIR__, "..", "data", "05.txt"))
    ispath(io) || (io = IOBuffer(io))
    partone = cargocrane(io)
    parttwo = cargocrane(io, true)
    partone, parttwo
end

end
