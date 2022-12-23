module Day22

function getmap(io="data/22.txt")
    cubemap = []
    maxlength = 0

    input = readlines(io)
    for line in input
        length(line) == 0 && break
        maxlength = max(length(line), maxlength)
        push!(cubemap, split(line, ""))
    end

    for line in cubemap
        oldlength = length(line)
        if oldlength < maxlength
            resize!(line, maxlength)
            line[oldlength+1:end] .= " "
        end
    end

    cubemap = vcat(permutedims.(cubemap)...)

    instructions = input[end]
    steps = parse.(Int, split(instructions, !isnumeric))
    turns = split(instructions, isnumeric, keepempty=false)

    cubemap, steps, turns
end

function walkmap(cubemap, steps, turns)
    y, x = 1, findfirst(==("."), cubemap[1, :])
    nextx = 0
    nexty = 0
    facing = 0

    for (i, step) in enumerate(steps)

        if facing == 0
            for s in 1:step
                nextx = mod1(x + 1, size(cubemap)[2])
                if cubemap[y, nextx] == " "
                    nextx = findfirst(!=(" "), cubemap[y, :])
                end
                if cubemap[y, nextx] == "."
                    x = nextx
                elseif cubemap[y, nextx] == "#"
                    break
                end
            end
        elseif facing == 2
            for s in 1:step
                nextx = mod1(x - 1, size(cubemap)[2])
                if cubemap[y, nextx] == " "
                    nextx = findlast(!=(" "), cubemap[y, :])
                end
                if cubemap[y, nextx] == "."
                    x = nextx
                elseif cubemap[y, nextx] == "#"
                    break
                end
            end
        elseif facing == 1
            for s in 1:step
                nexty = mod1(y + 1, size(cubemap)[1])
                if cubemap[nexty, x] == " "
                    nexty = findfirst(!=(" "), cubemap[:, x])
                end
                if cubemap[nexty, x] == "."
                    y = nexty
                elseif cubemap[nexty, x] == "#"
                    break
                end
            end
        elseif facing == 3
            for s in 1:step
                nexty = mod1(y - 1, size(cubemap)[1])
                if cubemap[nexty, x] == " "
                    nexty = findlast(!=(" "), cubemap[:, x])
                end
                if cubemap[nexty, x] == "."
                    y = nexty
                elseif cubemap[nexty, x] == "#"
                    break
                end
            end
        end

        i > length(turns) && continue

        turn = turns[i]
        if turn == "R"
            facing = mod(facing + 1, 4)
        elseif turn == "L"
            facing = mod(facing - 1, 4)
        end
    end

    1000 * y + 4 * x + facing
end

function walkcube(cubemap, steps, turns)
    y, x = 1, findfirst(==("."), cubemap[1, :])
    nextx = 0
    nexty = 0
    facing = 0

    for (i, step) in enumerate(steps)

        for s in 1:step
            if facing == 0

                nexty = y
                nextx = mod1(x + 1, size(cubemap)[2])

                if cubemap[nexty, nextx] == " "
                    if 1 ≤ nexty ≤ 50
                        nexty = 151 - y
                        nextx = 100
                        cubemap[nexty, nextx] == "." && (facing = 2)
                    elseif 51 ≤ nexty ≤ 100
                        nexty = 50
                        nextx = y + 50
                        cubemap[nexty, nextx] == "." && (facing = 3)
                    elseif 101 ≤ nexty ≤ 150
                        nexty = 151 - y
                        nextx = 150
                        cubemap[nexty, nextx] == "." && (facing = 2)
                    elseif 151 ≤ nexty ≤ 200
                        nexty = 150
                        nextx = y - 100
                        cubemap[nexty, nextx] == "." && (facing = 3)
                    end
                end

                if cubemap[nexty, nextx] == "."
                    x = nextx
                    y = nexty
                elseif cubemap[nexty, nextx] == "#"
                    break
                end

            elseif facing == 2

                nexty = y
                nextx = mod1(x - 1, size(cubemap)[2])

                if cubemap[y, nextx] == " "
                    if 1 ≤ nexty ≤ 50
                        nexty = 151 - y
                        nextx = 1
                        cubemap[nexty, nextx] == "." && (facing = 0)
                    elseif 51 ≤ nexty ≤ 100
                        nexty = 101
                        nextx = y - 50
                        cubemap[nexty, nextx] == "." && (facing = 1)
                    elseif 101 ≤ nexty ≤ 150
                        nexty = 151 - y
                        nextx = 51
                        cubemap[nexty, nextx] == "." && (facing = 0)
                    elseif 151 ≤ nexty ≤ 200
                        nexty = 1
                        nextx = y - 100
                        cubemap[nexty, nextx] == "." && (facing = 1)
                    end
                end

                if cubemap[nexty, nextx] == "."
                    x = nextx
                    y = nexty
                elseif cubemap[nexty, nextx] == "#"
                    break
                end

            elseif facing == 1

                nextx = x
                nexty = mod1(y + 1, size(cubemap)[1])

                if cubemap[nexty, nextx] == " "
                    if 1 ≤ nextx ≤ 50
                        nexty = 1
                        nextx = x + 100
                        cubemap[nexty, nextx] == "." && (facing = 1)
                    elseif 51 ≤ nextx ≤ 100
                        nexty = x + 100
                        nextx = 50
                        cubemap[nexty, nextx] == "." && (facing = 2)
                    elseif 101 ≤ nextx ≤ 150
                        nexty = x - 50
                        nextx = 100
                        cubemap[nexty, nextx] == "." && (facing = 2)
                    end
                end

                if cubemap[nexty, nextx] == "."
                    x = nextx
                    y = nexty
                elseif cubemap[nexty, nextx] == "#"
                    break
                end

            elseif facing == 3

                nextx = x
                nexty = mod1(y - 1, size(cubemap)[1])

                if cubemap[nexty, nextx] == " "
                    if 1 ≤ nextx ≤ 50
                        nexty = x + 50
                        nextx = 51
                        cubemap[nexty, nextx] == "." && (facing = 0)
                    elseif 51 ≤ nextx ≤ 100
                        nexty = x + 100
                        nextx = 1
                        cubemap[nexty, nextx] == "." && (facing = 0)
                    elseif 101 ≤ nextx ≤ 150
                        nexty = 200
                        nextx = x - 100
                        cubemap[nexty, nextx] == "." && (facing = 3)
                    end
                end
                if cubemap[nexty, nextx] == "."
                    x = nextx
                    y = nexty
                elseif cubemap[nexty, nextx] == "#"
                    break
                end
            end
        end

        i > length(turns) && continue

        turn = turns[i]
        if turn == "R"
            facing = mod(facing + 1, 4)
        elseif turn == "L"
            facing = mod(facing - 1, 4)
        end
    end

    1000 * y + 4 * x + facing
end

function solutions(io::String=joinpath(@__DIR__, "..", "data", "22.txt"))
    cubemap, steps, turns = ispath(io) ? getmap(io) : getmap(IOBuffer(io))
    partone = walkmap(cubemap, steps, turns)
    parttwo = walkcube(cubemap, steps, turns)

    partone, parttwo
end

end