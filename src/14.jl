module Day14

function makecave(io)
    coords = []
    xmax = 501
    ymax = 0
    for line in eachline(io)
        line = split(line, " -> ")
        line = [parse.(Int, split(c, ",")) .+ 1 for c in line]
        for (x, y) in line
            xmax = max(xmax, x)
            ymax = max(ymax, y)
        end
        push!(coords, line)
    end
    cave = falses(xmax, ymax)

    for line in coords
        for step in zip(line, line[2:end])
            xrange = min(step[1][1], step[2][1]):max(step[1][1], step[2][1])
            yrange = min(step[1][2], step[2][2]):max(step[1][2], step[2][2])
            cave[xrange, yrange] .= true
        end
    end
    cave
end

function sand(cave)

    partone = 0
    parttwo = 0

    cave = hcat(cave, falses(size(cave)[1], 1))
    cave = hcat(cave, trues(size(cave)[1], 1))
    extension = falses((1, size(cave)[2]))
    extension[end] = true

    grainpath = [[501, 1]]
    while !cave[501, 1]

        settled = false

        while !settled

            grainx = grainpath[end][1]
            grainy = grainpath[end][2]

            if grainx == 1
                cave = vcat(extension, cave)
                map(x -> x[1] += 1, grainpath)
                grainx += 1
            elseif grainx == size(cave)[1]
                cave = vcat(cave, extension)
            end

            if grainy == size(cave)[2] - 2 && partone == 0
                partone = parttwo
            end

            if !cave[grainx, grainy+1]
                push!(grainpath, [grainx, grainy + 1])
            elseif !cave[grainx-1, grainy+1]
                push!(grainpath, [grainx - 1, grainy + 1])
            elseif !cave[grainx+1, grainy+1]
                push!(grainpath, [grainx + 1, grainy + 1])
            else
                settled = true
                parttwo += 1
                cave[grainx, grainy] = true
                pop!(grainpath)
            end
        end
    end

    partone, parttwo
end

function solutions(io::String=joinpath(@__DIR__, "..", "data", "14.txt"))
    ispath(io) || (io = IOBuffer(io))
    cave = makecave(io)
    partone, parttwo = sand(cave)
end

end