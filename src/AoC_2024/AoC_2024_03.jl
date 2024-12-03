module AoC_2024_03
    using AdventOfCode;

    function parse_inputs(lines::Vector{String})::String 
        return join(lines);
    end
    
    function find_muls(input)
        pattern = r"mul\((\d+),(\d+)\)";
        a = [ parse.(Int, split(m.match[5:end-1], ',')) for m in eachmatch(pattern, input)]
        return a;
    end

    function solve_part_1(inputs)

        a = find_muls(inputs)
        p1 = sum([x[1] * x[2] for x in a])
        return p1;
    end

    function solve_part_2(inputs)

        do_blocks = split(inputs, "do()")

        mul_vals = Vector{Int}[]
        for do_block in do_blocks
            a1 = split(do_block, "don't()")[1]
            b1 = find_muls(a1)
            push!(mul_vals, b1...)
        end
        
        p2 = sum([x[1] * x[2] for x in mul_vals])

        return p2;
    end

    function solve(btest::Bool = false)::Tuple{Any, Any}
        lines       = @getinputs(btest);
        # lines2      = @getinputs(btest, "_2"); # Use if 2nd problem test case inputs are different
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