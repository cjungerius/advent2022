input = readlines("input.txt")

mutable struct Monkey
    items::Vector{Int}
    opkey::String
    oparg::Int
    modtest::Int
    truemonkey::Int
    falsemonkey::Int
    businesscount::Int
end

function Monkey(input::Vector{String})::Monkey
    nummatch = r"([0-9]+)"
    opmatch = r"(\*|\+)"

    items = [parse(Int, x[1]) for x in eachmatch(nummatch, input[2])]
    op = match(opmatch, input[3])[1]
    opargmatch = match(nummatch, input[3])
    isnothing(opargmatch) ? oparg = 0 : oparg = parse(Int, opargmatch[1])
    modtest = parse(Int, match(nummatch, input[4])[1])
    truemonkey = parse(Int, match(nummatch, input[5])[1]) + 1
    falsemonkey = parse(Int, match(nummatch, input[6])[1]) + 1

    m = Monkey(items, op, oparg, modtest, truemonkey, falsemonkey, 0)
end

function makemonkeys(input)
    monkeystarts = findall(x -> length(x) == 0, input)
    monkeystarts .+= 1
    pushfirst!(monkeystarts, 1)

    monkeys = Monkey[]
    for i in monkeystarts
        monkey = Monkey(input[i:i+5])
        push!(monkeys, monkey)
    end
    monkeys
end

function monkeybusiness(input, n; worry=false)

    monkeys = makemonkeys(input)
    opdict = Dict(["*", "+"] .=> [*, +])

    # item % lowest common multiple behaves the same for all tests as the original number, so:
    worrymod = lcm([m.modtest for m in monkeys]...)

    for i in 1:n
        for m in monkeys
            while !isempty(m.items)
                item = popfirst!(m.items)
                m.oparg == 0 ? item = opdict[m.opkey](item, item) : item = opdict[m.opkey](item, m.oparg)
                worry ? item %= worrymod : item ÷= 3
                mod(item, m.modtest) == 0 ? push!(monkeys[m.truemonkey].items, item) : push!(monkeys[m.falsemonkey].items, item)
                m.businesscount += 1
            end
        end
    end

    business = [m.businesscount for m in monkeys]
    sort!(business, rev=true)
    business[1] * business[2]
end

partone, parttwo = monkeybusiness(input, 20), monkeybusiness(input, 10000, worry=true)
