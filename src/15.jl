module Day15

#part 1 steps:
#got set of ranges
#noticed they all overlap
#distance of minimum to maximum *-1* (because 1 beacon present in line) = answer

function createmap(io = "data/15.txt")
        nummatch = r"(-?[0-9]+)"
        sensors = []
        beacons = []
        for line in eachline(io)
            items = [parse(Int, x.captures[1]) for x in eachmatch(nummatch, line)]
            push!(sensors, (items[1:2]))
            push!(beacons, (items[3:4]))
        end
    sensors, beacons
end


function sensorrange(sensors,beacons,y)
    coverage = Tuple[]

    for (sensor, beacon) in zip(sensors, beacons)
        manhattan = abs(sensor[1]-beacon[1]) + abs(sensor[2] - beacon[2])
        diff = manhattan - abs(sensor[2]-y)
        diff > 0 && push!(coverage, (sensor[1]-diff,sensor[1]+diff))
    end
    sort!(coverage)
end

function checkgap(coverage,rmin,rmax)::Union{Nothing, Int}

    overlap = 0
    for (a,b) in zip(coverage,coverage[2:end])
        a[2] < rmin && continue
        b[1] > rmax && return nothing
        overlap = max(overlap,a[2])
        b[1] > overlap && return a[2] + 1
    end
    nothing
end

function coveragelength(coverage)

    xmin = minimum(x[1] for x in coverage)
    xmax = maximum(x[2] for x in coverage)
    if isnothing(checkgap(coverage,xmin,xmax))
        return length(xmin:xmax)
    end
end

function findspot(sensors, beacons,rmin=0,rmax=4000000)

    x = nothing
    for y in rmin:rmax
        c = sensorrange(sensors,beacons,y)
        x = checkgap(c,rmin,rmax)
        !isnothing(x) && return (x,y)
    end
    nothing
end

end
