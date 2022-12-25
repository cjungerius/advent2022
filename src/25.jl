module Day25

function read_snafu(s::String)::Int
        snafu_dict = Dict([
                '=' => -2,
                '-' => -1,
                '0' => 0,
                '1' => 1,
                '2' => 2
        ])

        n = 0

        for (place, digit) in enumerate(reverse(s))
                n += snafu_dict[digit] * 5^(place - 1)
        end
        n
end

function write_snafu(i::Int)::String

        s = ""
        rem = 0

        reverse_snafu_dict = Dict([
                0 => '0',
                1 => '1',
                2 => '2',
                3 => '=',
                4 => '-',
                5 => '0'
        ])

        for d in digits(i, base=5)
                d += rem
                d > 2 ? rem = 1 : rem = 0
                s *= reverse_snafu_dict[d]
        end
        rem == 1 && (s *= '1')

        reverse(s)
end


function solutions(io::String=joinpath(@__DIR__, "..", "data", "25.txt"))
        ispath(io) || (io = IOBuffer(io))
        readlines(io) .|> read_snafu |> sum |> write_snafu
end

end