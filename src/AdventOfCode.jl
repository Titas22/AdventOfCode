module AdventOfCode
    using Revise
    using Profile
    using BenchmarkTools
    using InlineExports
    using JET
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

    @export function number_of_digits(b::Int)::Int
        b < 10 && return 1;
        b < 100 && return 2;
        b < 1000 && return 3;
        b < 10000 && return 4;
        b < 100000 && return 5;
        b < 1000000 && return 6;
        b < 10000000 && return 7;
        b < 100000000 && return 8;
        b < 1000000000 && return 9;
        b < 10000000000 && return 10;
        b < 100000000000 && return 11;
        b < 1000000000000 && return 12;
        return floor(Int, log10(b)) + 1; # Backup
    end

end # module AdventOfCode
