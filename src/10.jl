module Day10

function getsignal(io::IO)
    x = 1
    signal = Int[]
    for line in eachline(io)

        if line[1] == 'n'
            push!(signal, x)
        else
            push!(signal, x, x)
            x += parse(Int, line[6:end])
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

function solutions(io::String=joinpath(@__DIR__, "..", "data", "10.txt"))
    partone, parttwo = getsignal(open(io))
end

end
