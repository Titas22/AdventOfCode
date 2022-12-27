module AdventOfCode
    using Revise
    using Profile
    using BenchmarkTools
    using InlineExports
    import Dates

    const TIMEZONE_OFFSET       = Dates.Hour(5); # Advent of Code problem is available @ midnight EST (UTC-5)
    const DEFAULT_YEAR          = Dates.year(Dates.today());
    const DEFAULT_SOLVED_DAYS   = 1:25;

    include("Inputs.jl")
    
    include("Benchmarks.jl")

end # module AdventOfCode
