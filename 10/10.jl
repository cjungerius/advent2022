input = split.(readlines("input.txt"))

function getsignal(input)
    x = 1
    signal = Int[]
    for line in input
        if line[1] == "noop"
            push!(signal, x)
        else
            push!(signal, repeat([x], 2)...)
            x += parse(Int, line[2])
        end
    end

    partone = sum([signal[x] * x for x in 20:40:220])

    #could also just directly print these chars, but here I save them to a printable string instead to stay consistent with my other solutions
    parttwo = ""
    for (i, s) in enumerate(signal)
        s - 1 ≤ mod1(i, 40) - 1 ≤ s + 1 ? parttwo *= "██" : parttwo *= "  "
        mod(i, 40) == 0 && (parttwo *= '\n')
    end

    partone, parttwo
end

partone, parttwo = getsignal(input)
print(parttwo)
