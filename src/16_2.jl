using DataStructures
using Combinatorics

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
    indexdict = Dict(valves .=> 1:length(valves))
    connectionmat = falses((length(valves),length(valves)))
    openvalves = Int[indexdict["AA"]]
    flowamount = Int[flowdict["AA"]]

    for (i,v) in enumerate(valves)
        for n in connectiondict[v]
            connectionmat[i,indexdict[n]] = true
            connectionmat[indexdict[n],i] = true
        end
        if flowdict[v] > 0
            push!(openvalves,i)
            push!(flowamount,flowdict[v])
        end
    end

    function bfs(n)
        distvec = fill(-1,length(valves))
        distvec[n] = 0
        q = Queue{Int}()
        enqueue!(q,n)

        while !isempty(q)
            current = dequeue!(q)
            neighbours = findall(connectionmat[current,:])
            for n in neighbours
                if distvec[n] < 0
                    distvec[n] = distvec[current]+1
                    enqueue!(q,n)
                end
            end
        end
    distvec[openvalves]
    end

    hcat(map(bfs,openvalves)...), flowamount
end


function partone(distgraph, flowamount,start=1,time=30)
    maxscore = 0
    states = Stack{Tuple}()
    push!(states,(start,time,0,Int[start]))

    mem = Dict()

    while !isempty(states)
        loc, time, score, opened = pop!(states)

        if time == 0
            maxscore = max(score,maxscore)
            continue
        end

        get(mem,(time,loc),-1) > score && continue
        mem[(time,loc)] = score

        dscore = sum(flowamount[opened])
       
        for v in eachindex(distgraph[loc,:])
            if !(v in opened) && time - distgraph[loc,v] > 0
                push!(states,(v, time-distgraph[loc,v]-1, score+dscore*(distgraph[loc,v]+1), [opened..., v]))
            end
        end
        push!(states,(loc,time-1,score+dscore,opened))
    end

maxscore
end

function parttwo(distgraph, flowamount)

    maxscore = 0
    states = Stack{Tuple}()
    push!(states,(1,1,26,0,Int[start]))

    mem = Dict()

    while !isempty(states)
        locA, locB, time, score, opened = pop!(states)

        if time == 0
            maxscore = max(score,maxscore)
            continue
        end

        get(mem,(time,loc),-1) > score && continue
        mem[(time,loc)] = score

        dscore = sum(flowamount[opened])
       
        for v in eachindex(distgraph[locA,:]), u in eachindex[locB,:]
            if !(v in opened) && time - distgraph[loc,v] > 0
                push!(states,(v, time-distgraph[loc,v]-1, score+dscore*(distgraph[loc,v]+1), [opened..., v]))
            end
        end
        push!(states,(loc,time-1,score+dscore,opened))
    end



maxscore
end