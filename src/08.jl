module Day08

using Pipe: @pipe

function preprocess(io::IO)
    input = readlines(io)
    output = @pipe input |> split.(_, "") |> [parse.(Int, line) for line in _] |> vcat(transpose.(_)...)
    output
end

function visible(input)

    vismat = zeros(Int, size(input))

    function viewline(i, line, rev=false, flip=false)
        treeline = -1
        for (j, tree) in enumerate(line)
            if tree > treeline
                treeline = tree
                rev && (j = size(vismat)[1] + 1 - j)
                flip ? vismat[i, j] = 1 : vismat[j, i] = 1
            end
        end
    end

    for i in 1:size(input)[1]
        viewline(i, @view(input[i, :]), false, false)
        viewline(i, reverse(@view(input[i, end:-1:1])), true, false)
    end

    for i in 1:size(input)[2]
        viewline(i, @view(input[:, i]), false, true)
        viewline(i, reverse(@view(input[:, i])), true, true)
    end

    sum(vismat)
end

function scenicscore(input)

    scoremat = zeros(Int, size(input))

    function scoreline(height, line)
        x = 0
        for tree in line
            x += 1
            tree ≥ height && break
        end
        x
    end

    for i in 2:size(input)[1]-1, j in 2:size(input)[1]-1

        height = input[i, j]

        line = @view input[i-1:-1:1, j]
        a = scoreline(height, line)
        a == 0 && continue

        line = @view input[i+1:end, j]
        b = scoreline(height, line)
        b == 0 && continue

        line = @view input[i, j-1:-1:1]
        c = scoreline(height, line)
        c == 0 && continue

        line = @view input[i, j+1:end]
        d = scoreline(height, line)
        d == 0 && continue

        scoremat[i, j] = *(a, b, c, d)
    end
    maximum(scoremat)
end

function visible(io::IO)
    input = preprocess(io)
    visible(input)
end

function scenicscore(io::IO)
    input = preprocess(io)
    scenicscore(input)
end

function solutions(io::String="data/08.txt")
    input = preprocess(open(io))
    partone = visible(input)
    parttwo = scenicscore(input)
    partone, parttwo
end

end
