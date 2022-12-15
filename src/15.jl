module Day15

#part 1 steps:
#got set of ranges
#noticed they all overlap
#distance of minimum to maximum *-1* (because 1 beacon present in line) = answer

function f(io = "data/15.txt")
        nummatch = r"(-?[0-9]+)"
        sensors = []
        beacons = []
        for line in eachline(io)
        items = [parse(Int, x.captures[1]) for x in eachmatch(nummatch, line)]
        push!(sensors, (items[1:2]))
        push!(beacons, (items[3:4]))
        end

        coverage = []

        for (sensor, beacon) in zip(sensors, beacons)
            manhattan = abs(sensor[1]-beacon[1]) + abs(sensor[2] - beacon[2])
            if 2000000 in sensor[2]-manhattan:sensor[2]+manhattan
                diff = manhattan - abs(sensor[2]-2000000)
                push!(coverage, (sensor[1]-diff:sensor[1]+diff))
            end
        end
        coverage
    end


#scan each line, find a coordinate, then flip and do it for the other one lol
#it aint pretty but it worked
function g(io = "data/15.txt")
        nummatch = r"(-?[0-9]+)"
        sensors = []
        beacons = []
        for line in eachline(io)
        items = [parse(Int, x.captures[1]) for x in eachmatch(nummatch, line)]
        push!(sensors, (items[1:2]))
        push!(beacons, (items[3:4]))
        end
        
        ys = trues(4000000)
        for i in 3292963:4000000
            ys[1:end] .= true
            for (sensor, beacon) in zip(sensors, beacons)
                manhattan = abs(sensor[1]-beacon[1]) + abs(sensor[2] - beacon[2])
                if i in sensor[1]-manhattan:sensor[1]+manhattan
                    diff = manhattan - abs(sensor[1]-i)
                    ys[max(1,sensor[2]-diff):min(sensor[2]+diff,4000000)] .= false
                end
            end
            any(ys) && break
        end
    ys
    end
end