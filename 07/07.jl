input = readlines("input.txt")
input = split.(input, " ")

dirs = []
contents = []
cwd = "/"
path = ""

for line in input[2:end]
    if line[2]=="cd" 
        if line[3] != ".."
            path = joinpath(path, line[3])
        else
            path = splitdir(path)[1]
        end
    elseif line[2]=="ls"
        push!(dirs, path)
        push!(contents,[])
    elseif line[1]=="dir"
        push!(contents[end],joinpath(path,line[2]))
    else
        push!(contents[end],parse(Int,line[1]))
    end
end

filesys = Dict(dirs .=> contents)
visited = []

function getvalue(dir, filesys, visited)
    total = 0
        for f in filesys[dir]
            f isa Number ? total += f : total += getvalue(f,filesys, visited)
        end
    push!(visited,(dir, total))
    total 
end


