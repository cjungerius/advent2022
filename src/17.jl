function f(io="data/17.txt")
    length(readline(io))

    chamber = falses(9,9)
    chamber[end,1:end] .= true
    chamber[1:end,1] .= true
    chamber[1:end,end].=true

    tallestpoint = size(chamber)[2]-4
    start = [tallestpoint,4]

    shapedict = Dict([
        "hline" => [[0,0],[0,1],[0,2],[0,3],[0,4]],
        "cross" => [[-1,0],[-1,1],[-1,2],[0,1],[-2,1]],
        "hook" => [[0,0],[0,1],[0,2],[-1,2],[-2,2]],
        "vline" => [[0,0],[-1,0],[-2,0],[-3,0],[-4,0]],
        "square" => [[0,0],[0,1],[-1,0],[-1,1]]
    ])

    

    [chamber[x.+start...]=true for x in shapedict["square"]]
    
    chamber
end