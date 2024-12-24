module AoC_2024_19
    using AdventOfCode;
    const AoC = AdventOfCode;

    function parse_inputs(lines::Vector{String})
        patterns = string.(split(lines[1], ", "))
        designs = lines[3:end]
        return (patterns, designs);
    end

    function ispossible!(cache::Dict{String, Int}, design::String, patterns::Vector{String})::Int
        haskey(cache, design) && return cache[design]
        count = 0
        for pattern in patterns
            startswith(design, pattern) || continue
            if design == pattern 
                count += 1
                continue
            end
    
            np = length(pattern)
            subdesign = design[np+1 : end]
            count += ispossible!(cache, subdesign, patterns)
        end
        cache[design] = count
        return count
    end

    function solve_common(patterns, designs)::Tuple{Int, Int}
        cache = Dict{String, Int}()

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
end