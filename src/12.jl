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

function dijkstra(io::IO)

    input = preprocess(io)
    distance = fill(Inf,size(input))
    visited = fill(false,size(input))

    elevationDict = Dict(['a':'z'...] .=> [1:26...])

    elevationDict['S'] = 1
    elevationDict['E'] = 26
    
    start = findfirst(x->x=='S', input)
    goal = findfirst(x->x=='E', input)

    distance[start] = 0
    visited[start] = true
    pq = PriorityQueue(start => 0)

    while !isempty(pq)
        u = dequeue!(pq)
        #u == goal && break
        for n in neighbours(input,u)
            a = elevationDict[input[u]]
            b = elevationDict[input[n]]
            b > (a+1) && continue
            dist = distance[u]+1
            distance[n] = min(dist,distance[n])
            if !visited[n]
                visited[n] = true
                pq[n] = distance[n]
            end
        end
    end

    distance[goal]
end

function dijkstraback(io::IO)

    input = preprocess(io)
    distance = fill(Inf,size(input))
    visited = fill(false,size(input))

    elevationDict = Dict(['a':'z'...] .=> [1:26...])

    elevationDict['S'] = 1
    elevationDict['E'] = 26
    
    #start = findfirst(x->x=='S', input)
    start = findfirst(x->x=='E', input)

    distance[start] = 0
    visited[start] = true
    pq = PriorityQueue(start => 0)

    while !isempty(pq)
        u = dequeue!(pq)
        #u == goal && break
        for n in neighbours(input,u)
            a = elevationDict[input[u]]
            b = elevationDict[input[n]]
            b < (a-1) && continue
            dist = distance[u]+1
            distance[n] = min(dist,distance[n])
            if !visited[n]
                visited[n] = true
                pq[n] = distance[n]
            end
        end
    end

    minimum(distance[map(x->x=='a',input)])
end

end