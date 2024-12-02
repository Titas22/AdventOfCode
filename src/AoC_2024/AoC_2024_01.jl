module AoC_2024_01
    using AdventOfCode;
    using DataStructures;


    function parse_inputs(lines::Vector{String})::Tuple{Vector{Int}, Vector{Int}}   
        inputs  = (Int[], Int[]);
        sizehint!.(inputs, length(lines));
        
        for line in lines
            split_idx = findfirst("   ", line);
            
            num_left = parse(Int, line[1:(split_idx[1]-1)]);
            num_right = parse(Int, line[split_idx[end]+1:end]);

            push!(inputs[1], num_left);
            push!(inputs[2], num_right);
        end
        sort!.(inputs)

        return inputs;
    end

    solve_part_1(inputs::Tuple{Vector{Int}, Vector{Int}})::Int = mapreduce(ii -> abs(inputs[2][ii] - inputs[1][ii]), +, eachindex(inputs[1]))

    function solve_part_2(inputs::Tuple{Vector{Int}, Vector{Int}})::Int
        right_counts = counter(inputs[2])
        tot = foldl((acc, x) -> acc + x * right_counts[x], inputs[1]; init=0)
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