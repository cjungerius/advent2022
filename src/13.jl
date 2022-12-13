module Day13

using JSON

function compare(a::Int,b::Int)
    sign(a-b)
end

function compare(A::Array,B::Array)
    for (a,b) in zip(A,B)
        c = compare(a,b) 
        c == 0 ? continue : return c
    end
    sign(length(A) - length(B))
end

function compare(A::Array, b::Int)
    compare(A,[b])
end

function compare(a::Int,B::Array)
    compare([a],B)
end

function comparesort(x,y)
    compare(x,y) == -1
end

function findvalid(io::IO)

    indices = Int[]
    index::Int = 1

    input = readlines(io)
    for i in 1:3:length(input)
        compare(JSON.parse(input[i]),JSON.parse(input[i+1])) == -1 && push!(indices,index)
        index += 1
    end
   
   sum(indices)     
end

function sortpackets(io::IO)

    packetlist = []
    for packet in eachline(io)
        length(packet) > 0 && push!(packetlist, JSON.parse(packet))
    end

    push!(packetlist,[[2]],[[6]])

    sort!(packetlist,lt=comparesort)
    findfirst(x->x==[[2]],packetlist) * findfirst(x->x==[[6]],packetlist)
end

end