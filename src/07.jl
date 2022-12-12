module Day07

function findspace(io::IO)::Tuple{Int,Int}

    filesys = Dict{String,Int}()
    path::String = "root"
    stack = String[]

    for line in eachline(io)
        line = split(line)

        if line[1] == "\$"
            if line[2] == "cd"
                if line[3] != ".."
                    push!(stack, path)
                    line[3] == "/" || (path *= "/" * line[3])
                else
                    filesys[stack[end]] += filesys[path]
                    path = pop!(stack)
                end
            else #if line[2]=="ls"
                filesys[path] = 0
            end
        else
            line[1] != "dir" && (filesys[path] += parse(Int, line[1]))
        end
    end

    # return to root if we haven't yet, so we've gathered all values:
    while !isempty(stack)
        filesys[stack[end]] += filesys[path]
        path = pop!(stack)
    end

    sizes = collect(values(filesys))

    partone = sum([x ≤ 100000 ? x : 0 for x in sizes])

    target = filesys["root"] - 40000000
    parttwo = minimum(filter(x -> x ≥ target, sizes))

    partone, parttwo
end

function solutions(io::String="data/07.txt")
    partone, parttwo = findspace(open(io))
end

end
