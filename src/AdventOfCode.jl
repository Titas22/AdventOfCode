module AdventOfCode
    using Revise
    using Profile
    using BenchmarkTools
    using InlineExports
    import Dates

    const TIMEZONE_OFFSET       = Dates.Hour(5); # Advent of Code problem is available @ midnight EST (UTC-5)
    const DEFAULT_YEAR          = Dates.year(Dates.today()) - (Dates.value(Dates.Month(Dates.today())) > 10 ? 0 : 1);
    const DEFAULT_SOLVED_DAYS   = 1:25;

    include("Inputs.jl")
    
    include("Benchmarks.jl")

    
    
    @export function splitAtEmptyLines(lines::Vector{String})::Vector{Vector{String}}
        inputs          = Vector{Vector{String}}()
        currentBlock    = String[]
        for line in lines
            if isempty(line)
                push!(inputs, currentBlock)
                currentBlock = String[]
            else
                push!(currentBlock, line)
            end
        end
        push!(inputs, currentBlock)
        return inputs
    end

end # module AdventOfCode
