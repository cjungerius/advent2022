module Day14


function sand(io,floor=false)
    coords = []
    xmax = 501
    ymax = 0
    for line in eachline(io)
        line = split(line," -> ")
        line = [parse.(Int,split(c,",")).+1 for c in line]
        for (x, y) in line
            xmax = max(xmax,x)
            ymax = max(ymax,y) 
        end
        push!(coords,line)
    end
    cave = zeros(Bool,(xmax, ymax))
    
    for line in coords
        for step in zip(line,line[2:end])
            xrange = min(step[1][1],step[2][1]):max(step[1][1],step[2][1])
            yrange = min(step[1][2],step[2][2]):max(step[1][2],step[2][2])
            cave[xrange, yrange] .= true
        end
    end

    sandcount = 0

    if !floor
        voidreached = false
        while !voidreached
            settled = false
            grainx = 501
            grainy = 1
            while !settled

                if grainy == ymax
                    voidreached = true
                    break
                end

                if !cave[grainx,grainy+1]
                    grainy += 1
                elseif !cave[grainx-1,grainy+1]
                    grainx -= 1
                    grainy += 1
                elseif !cave[grainx+1,grainy+1]
                    grainx += 1
                    grainy += 1
                else
                    settled = true
                    sandcount += 1
                    cave[grainx,grainy] = true
                end
            end
        end
    else
        cave = hcat(cave,zeros(Bool,xmax,1))
        cave = hcat(cave,ones(Bool,xmax,1))
        extension = zeros(Bool,(1,ymax+2))
        extension[end] = true
        while !cave[501,1]
            settled = false
            grainx = 501
            grainy = 1
            while !settled
                grainx
                if grainx == 1
                    cave = vcat(extension,cave)
                    grainx += 1
                elseif grainx == size(cave)[1]
                    cave = vcat(cave,extension)
                end
                if !cave[grainx,grainy+1]
                    grainy += 1
                elseif !cave[grainx-1,grainy+1]
                    grainx -= 1
                    grainy += 1
                elseif !cave[grainx+1,grainy+1]
                    grainx += 1
                    grainy += 1
                else
                    settled = true
                    sandcount += 1
                    cave[grainx,grainy] = true
                end
            end
        end
    end
    sandcount
end

function solutions(io::String=joinpath(@__DIR__,"..","data","14.txt"))
    ispath(io) || (io = IOBuffer(io))
    partone = sand(io)
    parttwo = sand(io,true)

    partone, parttwo
end

end