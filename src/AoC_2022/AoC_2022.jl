module AoC_2022
    using BenchmarkTools

    using AdventOfCode
    

    # TODO: this doesn't work very nicely
    include("./AoC_22_01.jl")
    # import  ..AoC_22_01;
    display(@benchmark (part1, part2) = AoC_22_01.solve());
end 