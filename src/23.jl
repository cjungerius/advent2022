module Day23

using StatsBase

function make_elves(io="data/23.txt", parttwo=false)
        elves = Tuple{Int,Int}[]
        for (y, line) in enumerate(eachline(io))
                xs = findall(==('#'), line)
                push!(elves, [(x, y) for x in xs]...)
        end

        surround = falses(9)
        NSWE = [[1, 4, 7], [3, 6, 9], [1, 2, 3], [7, 8, 9]]
        NSWEstep = [(0, -1), (0, 1), (-1, 0), (1, 0)]
        start = 1
        counter = 0
        partone = 0
        parttwo = 0

        next = similar(elves)

        while true

                counter += 1
                if counter == 11
                        a = maximum(x[2] for x in elves) - minimum(x[2] for x in elves) + 1
                        b = maximum(x[1] for x in elves) - minimum(x[1] for x in elves) + 1
                        partone = a * b - length(elves)
                end

                tocheck = Set{Tuple{Int,Int}}(elves)

                for (i, elf) in enumerate(elves)
                        surround[1:end] .= false
                        for (j, (x::Int, y::Int)) in enumerate((x, y) for y in -1:1, x in -1:1)
                                x == y == 0 && continue
                                (elf[1] + x, elf[2] + y) ∈ tocheck && (surround[j] = true)
                        end

                        if sum(surround) == 0
                                next[i] = elf
                                continue
                        end
                        canmove = false

                        for o in start:start+3
                                loccheck = NSWE[mod1(o, 4)]
                                if !any(surround[loccheck])
                                        canmove = true
                                        next[i] = (elf .+ NSWEstep[mod1(o, 4)])
                                        break
                                end
                        end

                        if !canmove
                                next[i] = elf
                        end

                end

                done = true

                nextcheck = countmap(next)
                for (i, n) in enumerate(next)
                        if nextcheck[n] == 1
                                done && elves[i] != n && (done = false)
                                elves[i] = n
                        end
                end
                done && break
                start += 1
        end

        parttwo = counter
        partone, parttwo
end

end