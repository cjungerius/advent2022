module Day12

using DataStructures

function preprocess(io::IO)

    input = []


    for line in eachline(io)
        push!(input,[c for c in line])
    end
    
    input = vcat(permutedims.(input)...)
end

function neighbours(input,idx)
    y = idx[1]
    x = idx[2]
    candidates = [(y-1,x),(y+1,x),(y,x-1),(y,x+1)]
    neighbourlist = []	
    for (a,b) in candidates
        if 0 < a <= size(input)[1] && 0 < b <= size(input)[2]
            push!(neighbourlist,CartesianIndex(a,b))
        end
    end
    neighbourlist
end

function bfs(io::IO)

    input = preprocess(io)
    distance = fill(Inf,size(input))
    visited = fill(false,size(input))

    elevationDict = Dict(['a':'z'...] .=> [1:26...])
    elevationDict['S'] = 1
    elevationDict['E'] = 26
    
    # we go backwards because that makes part two easier
    start = findfirst(x->x=='E', input)
    goalone = findfirst(x->x=='S', input)
    goaltwo = findall(x->x=='a', input)

    distance[start] = 0
    visited[start] = true
    q = Queue{CartesianIndex}()
    enqueue!(q,start)

    #populate the whole map: no early stopping so we can do partone and parttwo simultaneously
    while !isempty(q)
        u = dequeue!(q)
        for n in neighbours(input,u)
            a = elevationDict[input[u]]
            b = elevationDict[input[n]]
            # this is the only thing you have to change to go backwards: we invert the rule about elevation
            b < (a-1) && continue
            dist = distance[u]+1
            distance[n] = min(dist,distance[n])
            if !visited[n]
                visited[n] = true
                enqueue!(q,n)
            end
        end
    end

    partone = distance[goalone]
    parttwo = minimum([distance[coord] for coord in goaltwo])

    partone, parttwo
end

function solutions(io::String=joinpath(@__DIR__, "..", "data", "12.txt"))
    partone, parttwo = bfs(open(io))
end

end