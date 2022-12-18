module Day18

using DelimitedFiles
using DataStructures

example = """2,2,2
1,2,2
3,2,2
2,1,2
2,3,2
2,2,1
2,2,3
2,2,4
2,2,6
1,2,5
3,2,5
2,1,5
2,3,5"""

function f(i=IOBuffer(example)) 
    
    coords = readdlm(i,',',Int)
    coords .+= 2

    xmax = maximum(coords[:,1])
    ymax = maximum(coords[:,2])
    zmax = maximum(coords[:,3])

    grid = falses(xmax+4,ymax+4,zmax+4)

    for c in axes(coords)[1]
        grid[coords[c,:]...] = true
    end



    sides = [[0,0,1],[0,0,-1],[0,1,0],[0,-1,0],[1,0,0],[-1,0,0]]
 

    surface = 0
    
    for c in axes(coords)[1]
        for side in sides
            if !grid[coords[c,:].+side...] 
                surface +=1
            end
        end
    end

    outside = falses(size(grid))
    q = Queue{Array}()
    enqueue!(q,[1,1,1])
    outside[1,1,1] = true

    outsidesurface = 0

    while !isempty(q)
        current = dequeue!(q)
        for (x,y,z) in sides
            if 0 < current[1]+x ≤ size(grid)[1] && 0 < current[2]+y ≤ size(grid)[2] && 0 < current[3]+z ≤ size(grid)[3]
                next = current.+[x,y,z]
                if !outside[next...] 
                    if !grid[next...]
                        outside[next...] = true
                        enqueue!(q,next)
                    else
                        outsidesurface += 1
                    end
                end
            end
        end
    end 

    surface, outsidesurface
end


end