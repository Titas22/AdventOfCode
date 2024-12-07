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

    
    
    @export lines2charmat(a::Vector{<:AbstractString}) = [a[i][j] for i=1:length(first(a)), j=1:length(a)]

    @export function split_at_empty_lines(lines::Vector{String})::Vector{Vector{String}}
        inputs          = Vector{Vector{String}}()
        current_block    = String[]
        for line in lines
            if isempty(line)
                push!(inputs, current_block)
                current_block = String[]
            else
                push!(current_block, line)
            end
        end
        push!(inputs, current_block)
        return inputs
    end

end # module AdventOfCode
