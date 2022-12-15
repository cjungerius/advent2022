module Day15

#part 1 steps:
#got set of ranges
#noticed they all overlap
#distance of minimum to maximum *-1* (because 1 beacon present in line) = answer

struct Sensor
    x::Int
    y::Int
    mdist::Int
end

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

function createsensors(sensors,beacons)
    sensorarray = Sensor[]
    for (sensor, beacon) in zip(sensors, beacons)
        manhattan = abs(sensor[1]-beacon[1]) + abs(sensor[2]-beacon[2])
        push!(sensorarray,Sensor(sensor[1],sensor[2],manhattan))
    end
    sensorarray
end


function sensorrange(sensors,y)

    coverage = Array[]

    for sensor in sensors
        diff = sensor.mdist - abs(sensor.y-y)
        diff > 0 && push!(coverage, [sensor.x-diff,sensor.x+diff])
    end
    sort!(coverage)
end

function checkgap(coverage,rmin,rmax)::Union{Nothing, Int}

    e = 0
    for (a,b) in coverage
        if b < rmin 
            continue
        elseif a > rmax 
            return nothing
        elseif a > e
            return a-1
        end
        e = max(e,b)
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

function findspot(sensors, rmin=0,rmax=4000000)

    for y in rmin:rmax
       c = sensorrange(sensors,y)
       x = checkgap(c,rmin,rmax)
       !isnothing(x) && return (x,y)
    end
end

function getborder(sensor::Sensor)
    edge = []
    bdist = sensor.mdist+1
    for dx in 0:bdist
        dy = bdist - dx
        push!(edge,(sensor.x+dx,sensor.y+dy))
    end
    edge
end

end