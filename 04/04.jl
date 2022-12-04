input = readlines("input.txt")


function sectionoverlaps(input)

    overlaps = 0
    fulloverlaps = 0

    for line in input
        m = split(line, [',', '-'])
        a = parse(Int, m[1]):parse(Int, m[2])
        b = parse(Int, m[3]):parse(Int, m[4])

        i = a ∩ b

        overlaps += (length(i) > 0)
        fulloverlaps += (length(i) == length(a) || length(i) == length(b))
    end

    fulloverlaps, overlaps
end

partone, parttwo = sectionoverlaps(input)