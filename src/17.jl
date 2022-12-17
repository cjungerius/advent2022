module Day17

function tetrisheight(io="data/17.txt";n=2022)
    blowdirs = readline(io)

    # coordinates are y,x! y adds more R, x adds more C

    chamber = falses(4,9)
    chamber[1,1:end] .= true
    chamber[1:end,1] .= true
    chamber[1:end,end].=true

    nextpart = falses(20,9)
    nextpart[1:end,1].=true
    nextpart[1:end,end] .= true

    shapedict = Dict([
        "hline" => [[0,0],[0,1],[0,2],[0,3]],
        "cross" => [[1,0],[1,1],[1,2],[0,1],[2,1]],
        "hook" => [[0,0],[0,1],[0,2],[1,2],[2,2]],
        "vline" => [[0,0],[1,0],[2,0],[3,0]],
        "square" => [[0,0],[0,1],[1,0],[1,1]]
    ])

    shapeorder = ["hline","cross","hook","vline","square"]

    currentheight = 1
    shapesdropped = 0
    blowdir = 0
    results = []


    for (i,shape) in enumerate(Iterators.cycle(shapeorder))


        i > n && break
        
        origin = [currentheight+4, 4]

        origin[1]+3 > size(chamber)[1] && (chamber = vcat(chamber,nextpart))

        dropped = false
            while !dropped                

                blowdir = mod1(blowdir+1,length(blowdirs))


                #sideways step
                nextorigin = blowdirs[blowdir] == '>' ? origin .+ [0,1] : origin .+[0,-1]
                if !any([chamber[x.+nextorigin...] for x in shapedict[shape]])
                    origin = nextorigin
                end
                
                #downstep
                nextorigin = origin .- [1,0]
                if !any([chamber[x.+nextorigin...] for x in shapedict[shape]] )
                    origin = nextorigin
                else
                    dropped = true
                    [[x.+origin...] for x in shapedict[shape]]
                    [chamber[x.+origin...]=true for x in shapedict[shape]]
                end
        end

        
        nextheight = maximum(maximum(findall(chamber[:,i])) for i in 2:8)
        push!(results,[nextheight-currentheight,shape,blowdir])
        currentheight = nextheight

    end
    
    currentheight-1, results
end

function findcycle()

    n = 4000

    while true
        _ , cyc = tetrisheight(n=n)

        for i in eachindex(cyc)
            occs = findall(x->x==cyc[i],cyc)
            length(occs) < 3 && continue
            clengths = [b-a for (a,b) in zip(occs,occs[2:end])]
            allequal(clengths) && return (i,cyc[occs[1]:occs[2]-1])
        end
        n += 1000
    end
end

function bigtetrisheight()
    starti, cyc = findcycle()

    starth, _ = tetrisheight(n=starti-1)
    dcycle = [x[1] for x in cyc]

    n = 1000000000000
    height = 0

    n -= (starti-1)
    height += starth

    fullcycs = floor(n/length(cyc))
    height += sum(dcycle)*fullcycs

    remainder = n%length(cyc)
    height += sum(dcycle[1:remainder])
    height
end

end