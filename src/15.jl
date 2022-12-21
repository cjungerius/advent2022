module Day15

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
        diff ≥ 0 && push!(coverage, [sensor.x-diff,sensor.x+diff])
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
        elseif a > e+1
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
        push!(edge,(sensor.x-dx,sensor.y+dy))
        push!(edge,(sensor.x+dx,sensor.y-dy))
        push!(edge,(sensor.x-dx,sensor.y-dy))
    end
    edge
end

function walkborders(sensors,rmin, rmax)

    for (i,sensor) in enumerate(sensors)
        border = getborder(sensor)
        for b in border
            rmin < b[1] < rmax || continue
            rmin < b[2] < rmax || continue
            any([inrange(s,b) for s in sensors]) || return b
        end
    end
end

function inrange(sensor,(x,y))
    abs(sensor.x - x) + abs(sensor.y - y) ≤ sensor.mdist
end

function getpartone(sensors,beacons,y=2000000)
    coverage = sensorrange(sensors,y)
    l = coveragelength(coverage)
    
   for s in sensors
       s.y == y && (l -= 1)
   end

    for b in Set(beacons)
        b[2] == y && (l -= 1)
    end
    
    l
end

function getparttwo(sensors)
    x, y = findspot(sensors)
    x * 4000000 + y
end

function solutions(io::String=joinpath(@__DIR__,"..","data","15.txt"))
    ispath(io) || (io = IOBuffer(io))
    s, b = createmap(io)
    sensors = createsensors(s,b)
    partone = getpartone(sensors,b)    
    parttwo = getparttwo(sensors)
end

end