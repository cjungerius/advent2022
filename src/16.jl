module Day16

using DataStructures
using Memoize

function f(i="data/16.txt")
    nummatch = r"(\d+)"
    valvematch = r"([A-Z]{2})"

    valves = String[]
    flows = Int[]
    connections = Array[]
    for line in eachline(i)
        push!(flows,parse(Int,match(nummatch,line)[1]))
        v = [x[1] for x in eachmatch(valvematch,line)]
        push!(valves,v[1])
        push!(connections, v[2:end])
    end

    flowdict = Dict(valves .=> flows)
    connectiondict = Dict(valves .=> connections)

    flowdict, connectiondict
end


function partone(flowdict, connectiondict)


    mem = Dict{Tuple{Int,String},Int}()

    function g(state)

        time, loc, score, opened = state

        if time == 0
            return score
        end

        get(mem,(time,loc),-1) > score && return -1
        mem[(time,loc)] = score

        score += sum(x->get(flowdict,x,0),opened,init=0)
        nextstates = Int[]

        if flowdict[loc] > 0 && !(loc in opened)
            push!(nextstates,g((time-1,loc,score,[opened...,loc])))
        end
    
        for n in connectiondict[loc]
            push!(nextstates,g((time-1,n,score,opened)))
        end  

        return maximum(nextstates)
    end

    g((30,"AA",0,[]))
end

function parttwo(flowdict, connectiondict)


    mem = Dict()

    function g(state)

        time, loc1, loc2, score, opened = state

        if time == 0
            return score
        end

        get(mem,(time,loc1,loc2),-1) > score && return -1
        mem[(time,loc1,loc2)] = score

        score += sum(x->get(flowdict,x,0),opened,init=0)
        nextstates = Int[]

        if flowdict[loc1] > 0 && !(loc in opened)
            push!(nextstates,g((time-1,loc,score,[opened...,loc1])))
        end
    
        for n in connectiondict[loc]
            push!(nextstates,g((time-1,n,score,opened)))
        end  

        return maximum(nextstates)
    end

    g((26,"AA","AA",0,[]))
end



end