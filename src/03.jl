module Day03

function commoncompartment(io)
    priorities = Dict(['a':'z'..., 'A':'Z'...] .=> [1:52...])
    prioritysum = 0
    for line in eachline(io)
        commonitem = pop!(Set(line[1:end÷2]) ∩ Set(line[end÷2+1:end]))
        prioritysum += priorities[commonitem]
    end
    prioritysum
end

function findbadge(io)
    priorities = Dict(['a':'z'..., 'A':'Z'...] .=> [1:52...])
    prioritysum = 0
    input = String[]

    for line in eachline(io)
        if length(input) == 3
            commonitem = Set(input[1]) ∩ Set(input[2]) ∩ Set(input[3])
            prioritysum += priorities[pop!(commonitem)]
            input = String[line]
        else
            push!(input, line)
        end
    end

    #if no newline at end of file:
    if length(input) == 3
        commonitem = Set(input[1]) ∩ Set(input[2]) ∩ Set(input[3])
        prioritysum += priorities[pop!(commonitem)]
    end

    prioritysum
end

function solutions(io::String=joinpath(@__DIR__, "..", "data", "03.txt"))
    partone = ispath(io) ? commoncompartment(io) :  commoncompartment(IOBuffer(io))
    parttwo = ispath(io) ? findbadge(io) :  findbadge(IOBuffer(io))
    partone, parttwo
end

end
