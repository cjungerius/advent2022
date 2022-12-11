input = readline("input.txt")

function findmarker(input,n)
    for i in 1:length(input)-n+1
        allunique(input[i:i+n-1]) && return i+n-1
    end
end

partone, parttwo = findmarker(input, 4), findmarker(input, 14)