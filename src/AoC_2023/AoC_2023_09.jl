module AoC_2023_09
    using AdventOfCode;
    const AoC = AdventOfCode;

    function parse_inputs(lines::Vector{String})
        split_lines = split.(lines);

        inputs  = Vector{Int}[]
        sizehint!(inputs, length(lines))

        for line in split_lines
            push!(inputs, parse.(Int, line));
        end

        return inputs;
    end

    function extrapolate(arr::Vector{Int})::Tuple{Int, Int}
        darr = diff(arr);
        iszero(darr) && return (arr[end], arr[1])
        
        (x1, x2) = extrapolate(darr);
        return (arr[end] + x1, arr[1] - x2)
    end
    
    function solve(btest::Bool = false)::Tuple{Any, Any};
        lines       = @getinputs(btest);
        inputs      = parse_inputs(lines);

        values      = extrapolate.(inputs);

        part1       = sum((x->x[1]).(values))
        part2       = sum((x->x[2]).(values))
        
        return (part1, part2);
    end

    # @time (part1, part2) = solve(true); # Test
    @time (part1, part2) = solve();
    println("\nPart 1 answer: $(part1)");
    println("\nPart 2 answer: $(part2)\n");
end