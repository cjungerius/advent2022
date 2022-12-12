module Day09

function longropephysics(io::IO)
    x = ones(Int, 10)
    y = ones(Int, 10)

    visitedone = Set([(1, 1)])
    visitedtwo = Set([(1, 1)])

    for line in eachline(io)

        dir, steps = split(line)

        for i in 1:parse(Int, steps)
            dir == "U" && (y[1] += 1)
            dir == "D" && (y[1] -= 1)
            dir == "R" && (x[1] += 1)
            dir == "L" && (x[1] -= 1)

            for j in eachindex(x)[2:end]

                if abs(x[j-1] - x[j]) > 1 || abs(y[j-1] - y[j]) > 1
                    y[j] += sign(y[j-1] - y[j])
                    x[j] += sign(x[j-1] - x[j])
                end

            end

            push!(visitedone, (x[2], y[2]))
            push!(visitedtwo, (x[end], y[end]))

        end
    end

    (length(visitedone), length(visitedtwo))
end

function solutions(io::String="data/09.txt")
    partone, parttwo = longropephysics(open(io))
end


end