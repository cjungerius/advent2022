module Day13

using JSON

function compare(a,b)::Int
    a isa Int && b isa Int && return sign(a-b)
    if a isa Vector && b isa Vector
        for (x,y) in zip(a,b)
            c = compare(x,y)
            c == 0 ? continue : return c
        end
        return sign(length(a) - length(b))
    elseif a isa Int
        return compare([a],b)
    elseif b isa Int
        return compare(a,[b])
    end
    error("Input types not valid!")
end

function comparesort(x,y)
    compare(x,y) == -1
end

function findvalid(io)

    indices = Int[]
    index = 1

    input = readlines(io)
    for i in 1:3:length(input)
        compare(JSON.parse(input[i]),JSON.parse(input[i+1])) == -1 && push!(indices,index)
        index += 1
    end
   
   sum(indices)     
end

function sortpackets(io)

    packetlist = []
    for packet in eachline(io)
        length(packet) > 0 && push!(packetlist, JSON.parse(packet))
    end

    sort!(packetlist,lt=comparesort)

    (searchsortedfirst(packetlist,[[2]],lt=comparesort)+1) * (searchsortedfirst(packetlist,[[6]],lt=comparesort)+1)
end

function solutions(io::String=joinpath(@__DIR__,"..","data","13.txt"))
    ispath(io) || (io = IOBuffer(io))
    partone = findvalid(io)
    parttwo = sortpackets(io)

    partone, parttwo
end

end