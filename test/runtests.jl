using Advent2022
using Test

@testset "Advent2022.jl" begin

    teststr = """1000
    2000
    3000
    
    4000
    
    5000
    6000
    
    7000
    8000
    9000
    
    10000"""

    @test Day01.solutions(teststr) == (24000, 45000)

    teststr = """A Y
    B X
    C Z"""

    @test Day02.solutions(teststr) == (15, 12)

    teststr = """vJrwpWtwJgWrhcsFMMfFFhFp
    jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
    PmmdzqPrVvPwwTWBwg
    wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
    ttgJtRGJQctTZtZT
    CrZsJsPPZsGzwwsLwLmpwMDw"""

    @test Day03.solutions(teststr) == (157, 70)

    teststr = """2-4,6-8
    2-3,4-5
    5-7,7-9
    2-8,3-7
    6-6,4-6
    2-6,4-8"""

    @test Day04.solutions(teststr) == (2, 4)

    teststr = """    [D]    
    [N] [C]    
    [Z] [M] [P]
     1   2   3 
    
    move 1 from 2 to 1
    move 3 from 1 to 3
    move 2 from 2 to 1
    move 1 from 1 to 2"""

    @test Day05.solutions(teststr) == ("CMZ","MCD")

    teststrs = [
        "mjqjpqmgbljsphdztnvjfqwrcgsmlb",
        "bvwbjplbgvbhsrlpgdmjqwftvncz",
        "nppdvjthqldpwncqszvftbrmjlhg",
        "nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg",
        "zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw"
    ]

    @test Day06.solutions.(teststrs) == [
        (7, 19),
        (5, 23),
        (6, 23),
        (10, 29),
        (11, 26)
    ]


end
