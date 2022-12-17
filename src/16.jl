module Day16

using DataStructures

function makedicts(io)
    nummatch = r"(\d+)"
    valvematch = r"([A-Z]{2})"

    valves = String[]
    flows = Int[]
    connections = Array[]
    for line in eachline(io)
        push!(flows, parse(Int, match(nummatch, line)[1]))
        v = [x[1] for x in eachmatch(valvematch, line)]
        push!(valves, v[1])
        push!(connections, v[2:end])
    end

    flowdict = Dict(valves .=> flows)
    connectiondict = Dict(valves .=> connections)

    flowdict, connectiondict
end

function partone(flowdict, connectiondict)

    stack = Tuple[]
    maxscore = 0
    mem = Dict{Tuple{Int,String},Int}()
    push!(stack, (1, "AA", 0, []))

    while !isempty(stack)

        (time, loc, score, opened) = pop!(stack)

        score += sum([flowdict[o] for o in opened], init=0)

        if time == 30
            if score > maxscore
                maxscore = score
            end
            continue
        end

        get(mem, (time, loc), -1) >= score && continue
        mem[(time, loc)] = score


        if flowdict[loc] > 0 && !(loc in opened)
            push!(stack, (time + 1, loc, score, [opened..., loc]))
        else
            for n in connectiondict[loc]
                push!(stack, (time + 1, n, score, opened))
            end
        end
    end

    return maxscore
end

function parttwo(flowdict, connectiondict)

    memory = Dict()
    maxscore = 0
    stack = Tuple[(1, "AA", "AA", 0, [])]


    while !(isempty(stack))

        time, locA, locB, score, opened = pop!(stack)

        score += sum([flowdict[loc] for loc in opened], init=0)

        if time == 26
            maxscore = max(score, maxscore)
            continue
        end

        if get(memory, (time, locA, locB), -1) >= score || get(memory, (time, locB, locA), -1) >= score
            continue
        end


        memory[(time, locA, locB)] = score
        memory[(time, locB, locA)] = score


        canopenA = flowdict[locA] > 0 && !(locA in opened)
        canopenB = locB != locA && flowdict[locB] > 0 && !(locB in opened)

        if canopenA
            if canopenB
                push!(stack, (time + 1, locA, locB, score, [opened..., locA, locB]))
            end

            for nextB in connectiondict[locB]
                push!(stack, (time + 1, locA, nextB, score, [opened..., locA]))
            end

        end

        if canopenB
            for nextA in connectiondict[locA]
                push!(stack, (time + 1, nextA, locB, score, [opened..., locB]))
            end
        end

        if !canopenA && !canopenB
            for nextA in connectiondict[locA], nextB in connectiondict[locB]
                push!(stack, (time + 1, nextA, nextB, score, opened))
            end
        end
    end

    return maxscore
end

function solutions(io::String=joinpath(@__DIR__, "..", "data", "16.txt"))
    ispath(io) || (io = IOBuffer(io))
    f,c = makedicts(io)
    partone(f,c), parttwo(f,c)
end

end

