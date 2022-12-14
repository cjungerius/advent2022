module Day06

function findmarker(io, n)
    input = readline(io)
    for i in 1:length(input)-n+1
        allunique(input[i:i+n-1]) && return i + n - 1
    end
end

function solutions(io::String=joinpath(@__DIR__, "..", "data", "06.txt"))
    partone = ispath(io) ? findmarker(io, 4) : findmarker(IOBuffer(io), 4)
    parttwo = ispath(io) ? findmarker(io, 14) : findmarker(IOBuffer(io), 14)
    partone,parttwo
end

end
