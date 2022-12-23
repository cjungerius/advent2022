module Day23

using StatsBase

function make_elves(io="data/23.txt", n=10)
        elves = []
        for (y, line) in enumerate(eachline(io))
                xs = findall(==('#'), line)
                push!(elves,[(x,y) for x in xs]...)
        end

        surround = falses(9)
        NSWE = [[1,4,7],[3,6,9],[1,2,3],[7,8,9]]
        NSWEstep = [(0,-1),(0,1),(-1,0),(1,0)]
        start = 1

        for i in 1:n
                tocheck = Set(elves)
                next = []

                for elf in elves
                        surround[1:end] .= false
                        for (i, (x,y)) in enumerate((x,y) for y in -1:1, x in -1:1)
                                x == y == 0 && continue
                                (elf[1]+x,elf[2]+y) ∈ tocheck && (surround[i] = true)
                        end

                        if sum(surround) == 0 
                                push!(next,elf)
                                continue
                        end
                        canmove = false

                        for o in start:start+3
                                loccheck = NSWE[mod1(o,4)]
                                if !any(surround[loccheck]) 
                                        canmove = true
                                        push!(next,(elf .+ NSWEstep[mod1(o,4)])) 
                                        break
                                end
                        end

                        if !canmove
                                push!(next,elf)
                        end

                end
                
                nextcheck = countmap(next)
                for (i,n) in enumerate(next)
                        if nextcheck[n] == 1
                                elves[i] = n
                        end
                end
                start += 1
        end

        elves
end

end