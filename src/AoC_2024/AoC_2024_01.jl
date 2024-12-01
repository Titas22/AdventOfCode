module AoC_2024_01
    using AdventOfCode;
    using DataStructures;
    const AoC = AdventOfCode;

    function parse_inputs(lines::Vector{String})::Tuple{Vector{Int}, Vector{Int}}    
        split_lines = split.(lines);        
        
        inputs  = (Int[], Int[]);
        sizehint!.(inputs, length(lines));
        
        for line in split_lines
            line_int = parse.(Int, line);
        
            push!(inputs[1], line_int[1]);
            push!(inputs[2], line_int[2]);
        end
        sort!.(inputs)
        return inputs;
    end

    function solve_part_1(inputs::Tuple{Vector{Int}, Vector{Int}})::Int
        tot = 0;
        for pair in zip(inputs[1], inputs[2])
            tot += abs(pair[2] - pair[1]);
        end
        return tot;
    end

    function solve_part_2(inputs::Tuple{Vector{Int}, Vector{Int}})::Int
        tot = 0
        right_counts = counter(inputs[2])
        for x in inputs[1]
            tot += x * right_counts[x]
        end
        return tot;
    end

    function solve(btest::Bool = false)::Tuple{Any, Any}
        lines       = @getinputs(btest);
        inputs      = parse_inputs(lines);

        part1       = solve_part_1(inputs);
        part2       = solve_part_2(inputs);

        return (part1, part2);
    end

    # @time (part1, part2) = solve(true); # Test
    @time (part1, part2) = solve();
    println("\nPart 1 answer: $(part1)");
    println("\nPart 2 answer: $(part2)\n");
end
