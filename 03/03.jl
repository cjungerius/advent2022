input = readlines("input.txt")

function partone(input)
    priorities = Dict(['a':'z'..., 'A':'Z'...] .=> [1:52...])
    prioritysum = 0
    for line in input
        l = length(line)
        commonitem = Set(line[1:l÷2]) ∩ Set(line[l÷2+1:end])
        prioritysum += priorities[pop!(commonitem)]
    end
    prioritysum
end

function parttwo(input)
    priorities = Dict(['a':'z'..., 'A':'Z'...] .=> [1:52...])
    prioritysum = 0

    input = reshape(input, (3, :))

    for i in 1:size(input)[2]
        commonitem = Set(input[1, i]) ∩ Set(input[2, i]) ∩ Set(input[3, i])
        prioritysum += priorities[pop!(commonitem)]
    end
    prioritysum
end
