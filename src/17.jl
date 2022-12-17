function f(io="data/17.txt")
    length(readline(io))

    # coordinates are y,x! y adds more R

    chamber = falses(8,9)
    chamber[end,1:end] .= true
    chamber[1:end,1] .= true
    chamber[1:end,end].=true

    tallestpoint = size(chamber)[1]-4
    origin = [tallestpoint,4]
    
    #vcat(trues(10,9),f())

    shapedict = Dict([
        "hline" => [[0,0],[0,1],[0,2],[0,3]],
        "cross" => [[-1,0],[-1,1],[-1,2],[0,1],[-2,1]],
        "hook" => [[0,0],[0,1],[0,2],[-1,2],[-2,2]],
        "vline" => [[0,0],[-1,0],[-2,0],[-3,0]],
        "square" => [[0,0],[0,1],[-1,0],[-1,1]]
    ])

    dropped = false
    while !dropped
        #drop next block
            #go through dropping steps:
                # -down
                # -sideways
            #if dropped: place, extend map, drop next block
        any(chamber[x.+origin...] for x in shapedict["hline"])


    
    chamber
end