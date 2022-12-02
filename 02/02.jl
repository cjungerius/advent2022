using DelimitedFiles
input = readdlm("input.txt")

function scorerps(input)

    #possible outcomes: each letter in the left column gives a given score for losing to it, tying it or beating it

    #sorted by you playing R P or S:
    partonemat = [
        [1 + 3, 2 + 6, 3 + 0],           #outcomes for opponent playing A/rock
        [1 + 0, 2 + 3, 3 + 6],           #outcomes for opponent playing B/paper
        [1 + 6, 2 + 0, 3 + 3]            #outcomes for opponent playing C/scissors
    ]

    #sorted by W D L:
    parttwomat = [
        [0 + 3, 3 + 1, 6 + 2],
        [0 + 1, 3 + 2, 6 + 3],
        [0 + 2, 3 + 3, 6 + 1]
    ]

    oppdict = Dict(["A", "B", "C"] .=> [1, 2, 3])
    playerdict = Dict(["X", "Y", "Z"] .=> [1, 2, 3])

    oppidx = [oppdict[k] for k in input[:, 1]]
    partonescores = [partonemat[o] for o in oppidx]
    parttwoscores = [parttwomat[o] for o in oppidx]

    partone = 0
    parttwo = 0

    for (i, m) in enumerate(input[:, 2])
        partone += partonescores[i][playerdict[m]]
        parttwo += parttwoscores[i][playerdict[m]]
    end

    (partone, parttwo)
end