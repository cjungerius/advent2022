module Day21

function makedict(io)

        monkeydict = Dict()

        for line in eachline(io)
                key, val = split(line, ": ")

                if isdigit(val[1])
                        monkeydict[key] = parse(Int, val)
                else
                        a, op, b = split(val, " ")
                        monkeydict[key] = [a, op, b]
                end
        end
        monkeydict
end

function processdict(monkeydict, key="root", p2=false, n=1200)

        opdict = Dict(["+" => +, "-" => -, "/" => /, "*" => *])

        if p2
                monkeydict["humn"] = n
        end

        function g(monkey::Int)
                monkey
        end

        function g(monkey::Vector)
                opdict[monkey[2]](g(monkeydict[monkey[1]]), g(monkeydict[monkey[3]]))
        end

        g(monkeydict[key])
end

function gradient_descent(monkeydict)

        start = monkeydict["humn"]
        key1 = monkeydict["root"][1]
        key2 = monkeydict["root"][3]

        get_diff(monkeydict, n=start) = (processdict(monkeydict, key1, true, n) - processdict(monkeydict, key2, true, n))

        learningrate = 1 / (get_diff(monkeydict, start + 1) - get_diff(monkeydict, start))

        distance = get_diff(monkeydict)
        guess = start - round(Int, distance * learningrate)

        while !iszero(distance)
                distance = get_diff(monkeydict, guess)
                guess -= round(Int, distance * learningrate)
        end

        monkeydict["humn"] = start
        guess
end

function solutions(io::String=joinpath(@__DIR__, "..", "data", "21.txt"))
        mdict = ispath(io) ? makedict(io) : makedict(IOBuffer(io))
        partone = processdict(mdict)
        parttwo = gradient_descent(mdict)

        partone, parttwo
end

end