module Day06

function findmarker(io::IO, n)
    input = readline(io)
    for i in 1:length(input)-n+1
        allunique(input[i:i+n-1]) && return i + n - 1
    end
end

function solutions(io::String="data/06.txt")
    partone, parttwo = findmarker(open(io), 4), findmarker(open(io), 14)
end

end
