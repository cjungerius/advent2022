input = readlines("input.txt")

function partone(input)
    priorities = Dict(['a':'z'...,'A':'Z'...] .=> [1:52...])
    prioritysum = 0
    for line in input
        l = length(line)
        commonitem = intersect(line[1:l÷2], line[l÷2+1:end])[1]
        prioritysum += priorities[commonitem]
    end
    prioritysum
end

function parttwo(input)
    priorities = Dict(['a':'z'...,'A':'Z'...] .=> [1:52...])
    prioritysum = 0

    input = reshape(input,(3,:))

    for i in 1:size(input)[2]
        commonitem = intersect(input[1,i], input[2,i], input[3,i])[1]
        prioritysum += priorities[commonitem]
    end

    prioritysum
end
