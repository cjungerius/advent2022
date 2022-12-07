input = readlines("input.txt")
input = split.(input, " ")

function findspace(input::Vector)

    filesys = Dict{String,Int}()
    path = "root"
    stack = String[]
    
    for line in input[2:end]
        if line[1] == "\$"
            if line[2] == "cd"
                if line[3] != ".." 
                    push!(stack,path)
                    path = joinpath(path, line[3])
                else 
                    filesys[stack[end]] += filesys[path]
                    path = pop!(stack)
                end
            else #if line[2]=="ls"
                filesys[path] = 0
            end
        else
            line[1] != "dir" && (filesys[path] += parse(Int,line[1]))
        end
    end

    # return to root if we haven't yet, so we've gathered all values:
    while !isempty(stack)
        filesys[stack[end]] += filesys[path]
        path = pop!(stack)
    end
    
    sizes = collect(values(filesys))

    partone = sum([x ≤ 100000 ? x : 0 for x in sizes])

    target = maximum(sizes) - 40000000
    parttwo = minimum(filter(x -> x ≥ target, sizes))

    partone, parttwo
end

partone, parttwo = findspace(input)