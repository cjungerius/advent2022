input = readlines("input.txt")
input = split.(input, " ")

function findspace(input::Vector)

    #build our dictionary of paths and contents
    filesys = Dict{String,Vector{Union{Int,String}}}()
    path = ""

    for line in input[2:end]
        if line[1] == "\$"
            if line[2] == "cd"
                line[3] != ".." ? (path = joinpath(path, line[3])) : (path = splitdir(path)[1])
            else #if line[2]=="ls"
                filesys[path] = Union{Int,String}[]
            end
        else
            line[1] == "dir" ? push!(filesys[path], joinpath(path, line[2])) : push!(filesys[path], parse(Int, line[1]))
        end
    end

    sizes = Int[]

    #function to traverse the path recursively and save all directory sizes
    function getvalue(dir::String, filesys::Dict, sizes::Vector{Int})
        total = 0
        for f in filesys[dir]
            f isa Number ? total += f : total += getvalue(f, filesys, sizes)
        end
        push!(sizes, total)
        total
    end

    #call the function
    totalsize = getvalue("", filesys, sizes)

    #and finally get our solutions
    partone = sum([x ≤ 100000 ? x : 0 for x in sizes])

    target = totalsize - 40000000
    parttwo = minimum(filter(x -> x ≥ target, sizes))

    partone, parttwo
end