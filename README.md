Advent2022.jl
================
Chris Jungerius
12/12/2022

![](https://img.shields.io/badge/day%20📅-22-blue.png)
![](https://img.shields.io/badge/stars%20⭐-22-yellow.png)
![](https://img.shields.io/badge/days%20completed-17-red.png) \# Advent
of Code 2022

Solving Advent of Code 2022 using Julia

``` julia
using Advent2022
using BenchmarkTools
using PrettyTables

conf = set_pt_conf(tf = tf_markdown, alignment = :c)

bscores = Advent2022.benchmark()

header = ["Day", "Time", "Memory"]
data = map(bscores) do (d, t, m)
    [d, BenchmarkTools.prettytime(t), BenchmarkTools.prettymemory(m)]
    end
data = permutedims(hcat(data...))

pretty_table_with_conf(conf, data; header = header)
```

    | Day |    Time    |   Memory   |
    |-----|------------|------------|
    |  1  | 199.200 μs | 55.30 KiB  |
    |  2  | 525.400 μs | 725.30 KiB |
