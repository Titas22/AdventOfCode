module AoC_2024_19
    using AdventOfCode;
    const AoC = AdventOfCode;

    function parse_inputs(lines::Vector{String})
        patterns = split(lines[1], ", ")
        designs = lines[3:end]
        return (patterns, designs);
    end

    function ispossible!(cache::Dict{<:AbstractString, Int}, design::AbstractString, patterns::Vector{<:AbstractString})::Int
        haskey(cache, design) && return cache[design]
        count = 0
        for pattern in patterns
            np = length(pattern)
            if np >= length(design)
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

    function solve_common(patterns, designs)::Tuple{Int, Int}
        cache = Dict{AbstractString, Int}()

        possible_designs = 0
        ncombinations = 0

        for design in designs
            ncombs = ispossible!(cache, design, patterns)
            ncombs == 0 && continue
            possible_designs += 1
            ncombinations += ncombs
        end

        return (possible_designs, ncombinations)
    end

    function solve(btest::Bool = false)::Tuple{Any, Any}
        lines               = @getinputs(btest);
        (patterns, design)  = parse_inputs(lines);

        (part1, part2)      = solve_common(patterns, design)

        return (part1, part2);
    end

    # @time (part1, part2) = solve(true); # Test
    @time (part1, part2) = solve();
    println("\nPart 1 answer: $(part1)");
    println("\nPart 2 answer: $(part2)\n");

    @assert(part1 == 333, "Part 1 is wrong")
    @assert(part2 == 678536865274732, "Part 2 is wrong")
end