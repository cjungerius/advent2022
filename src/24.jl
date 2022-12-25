module Day24

using DataStructures

function make_map(io="data/24.txt")

    input = readlines(io)
    valleyheight = length(input) - 2
    valleywidth = length(input[1]) - 2
    timesteps = lcm(valleyheight, valleywidth)
    accessible = trues(length(input), length(input[1]), timesteps)
    xs = Int[]
    ys = Int[]


    for (y, line) in enumerate(input)
        for (x, c) in enumerate(line)
            if c == '#'
                accessible[y, x, :] .= false
            elseif c == '>'
                xs = 1 .+ mod1.(x - 1 .+ [0:timesteps-1...], valleywidth)
                for (t, i) in enumerate(xs)
                    accessible[y, i, t] = false
                end
            elseif c == '<'
                xs = 1 .+ mod1.(x - 1 .- [0:timesteps-1...], valleywidth)
                for (t, i) in enumerate(xs)
                    accessible[y, i, t] = false
                end
            elseif c == 'v'
                ys = 1 .+ mod1.(y - 1 .+ [0:timesteps-1...], valleyheight)
                for (t, i) in enumerate(ys)
                    accessible[i, x, t] = false
                end
            elseif c == '^'
                ys = 1 .+ mod1.(y - 1 .- [0:timesteps-1...], valleyheight)
                for (t, i) in enumerate(ys)
                    accessible[i, x, t] = false
                end
            end
        end
    end
    accessible
end

function bfs(accessible, start=(1, 2, 1), finish=(size(accessible)[1], size(accessible)[2] - 1))
    distances = fill(-1, size(accessible))
    distances[start...] = 0

    q = Queue{Tuple{Int,Int,Int}}()
    enqueue!(q, start)

    neighbours = [(-1, 0), (1, 0), (0, 0), (0, 1), (0, -1)]

    while !isempty(q)

        y, x, t = dequeue!(q)
        tnext = mod1(t + 1, size(accessible)[3])
        y == finish[1] && break
        for (dy, dx) in neighbours
            y + dy == 0 && continue
            y + dy > size(accessible)[1] && continue
            if distances[y+dy, x+dx, tnext] < 0 && accessible[y+dy, x+dx, tnext]
                distances[y+dy, x+dx, tnext] = distances[y, x, t] + 1
                enqueue!(q, (y + dy, x + dx, tnext))
            end
        end
    end
    argmax(distances[finish..., :]), maximum(distances[finish..., :])
end

function back_and_forth(accessible)
    fy, fx = size(accessible)[1], size(accessible)[2] - 1
    phase_a, steps_a = bfs(accessible, (1, 2, 1), (fy, fx))
    phase_b, steps_b = bfs(accessible, (fy, fx, phase_a), (1, 2))
    phase_c, steps_c = bfs(accessible, (1, 2, phase_b), (fy, fx))
    steps_a, +(steps_a, steps_b, steps_c)
end

function solutions(io::String=joinpath(@__DIR__, "..", "data", "24.txt"))
    ispath(io) || (io = IOBuffer(io))
    accessible = make_map(io)
    partone, parttwo = back_and_forth(accessible)
end

end