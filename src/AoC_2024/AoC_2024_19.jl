module AoC_2024_19
    using AdventOfCode;
    const AoC = AdventOfCode;

    function parse_inputs(lines::Vector{String})
        patterns = split(lines[1], ", ")
        designs = lines[3:end]
        return (patterns, designs);
    end

    function solve_part_1(patterns, design)

        return nothing;
    end

    function solve_part_2(patterns, design)

        return nothing;
    end

    function solve(btest::Bool = false)::Tuple{Any, Any}
        lines       = @getinputs(btest);
        # lines2      = @getinputs(btest, "_2"); # Use if 2nd problem test case inputs are different
        (patterns, design)      = parse_inputs(lines);

        part1       = solve_part_1(patterns, design);
        part2       = solve_part_2(patterns, design);

        return (part1, part2);
    end

    @time (part1, part2) = solve(true); # Test
    # @time (part1, part2) = solve();
    println("\nPart 1 answer: $(part1)");
    println("\nPart 2 answer: $(part2)\n");
end
lines = @getinputs(false)
(patterns, designs) = AoC_2024_19.parse_inputs(lines)

cache = Dict{AbstractString, Int}()

function ispossible!(cache::Dict{<:AbstractString, Int}, design::AbstractString, patterns::Vector{<:AbstractString})::Int
    haskey(cache, design) && return cache[design]
    count = 0
    for pattern in patterns
        np = length(pattern)
        np > length(design) && continue
        if np == length(design)
            if design == pattern 
                count += 1
            end
            continue
        end

        startswith(design, pattern) || continue
        count += ispossible!(cache, design[np+1 : end], patterns)
    end
    cache[design] = count
    return count
end

ispossible(design::AbstractString)::Int = ispossible!(cache, design, patterns)

@time possibilities = ispossible.(designs)

part1 = count(possibilities .> 0 )
part2 = sum(possibilities)
