module AoC_2024_01
    using AdventOfCode;
    using DataStructures;
    using Parsers;


    function parse_inputs(lines::Vector{String})::Tuple{Vector{Int}, Vector{Int}}   
        inputs  = (Int[], Int[]);
        sizehint!.(inputs, length(lines));
        
        opt = Parsers.Options(delim=' ', ignorerepeated=true)
        for line in lines
            io = IOBuffer(line)            
            push!(inputs[1], Parsers.parse(Int64, io, opt));
            push!(inputs[2], Parsers.parse(Int64, io, opt));
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