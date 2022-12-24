using DataStructures
using Combinatorics
using Random
using StatsBase

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


function partone_mc(distgraph,flowamount)
    maxflow = 0
    

    nodes = Int[1:length(flowamount)...]

    for i in 1:100000

        open = falses(length(flowamount))
        open[1] = true
        t = 30
        flow = 0
        dflow = 0
        loc = 1
        
            while true
                !any(distgraph[loc,:] .< t) && break
                t < 1 && break

                available = .!open .&& distgraph[loc,:] .< t

                weights = Weights(flowamount .* (t .- distgraph[loc,:]) .* available)
                step = sample(nodes,weights)
                
                dist = distgraph[loc,step]
                flow += dflow*(dist+1)
                dflow += flowamount[step]
                open[step] = true
                loc = step
                t -= (dist+1)

            end

            flow += dflow*t
            #flow == 1651 && println("max reached!")
            maxflow = max(flow,maxflow)
        end


    maxflow
end



#idea for valve selection heuristic:
# flowamount .* (t .- distgraph[loc,:])