module Day24

function f(io="data/24.txt")

    input = readlines(io)
    valleyheight = length(input)-2
    valleywidth = length(input[1])-2
    timesteps = lcm(valleyheight, valleywidth)
    accessible = trues(length(input),length(input[1]),timesteps)
    xs = Int[]
    ys = Int[]


    for (y,line) in enumerate(input)
        for (x,c) in enumerate(line)
            if c=='#'
                accessible[y,x,:].=false
            elseif c=='>'
                xs = 1 .+ mod1.(x-1 .+ [0:timesteps-1...], valleywidth)
                for (t,i) in enumerate(xs)
                    accessible[y,i,t] = false
                end
            elseif c=='<'
                xs = 1 .+ mod1.(x-1 .- [0:timesteps-1...], valleywidth)
                for (t,i) in enumerate(xs)
                    accessible[y,i,t] = false
                end
            elseif c=='v'
                ys = 1 .+ mod1.(y-1 .+ [0:timesteps-1...], valleyheight)
                for (t,i) in enumerate(ys)
                    accessible[i,x,t] = false
                end
            elseif c=='^'
                ys = 1 .+ mod1.(y-1 .- [0:timesteps-1...], valleyheight)
                for (t,i) in enumerate(ys)
                    accessible[i,x,t] = false
                end
            end
        end
    end
    accessible
end

function bfs(accessible)
    start = [1,2]
    finish = [size(accessible)[1],size(accessible)[2]-1]
end

end