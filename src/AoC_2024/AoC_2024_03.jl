module AoC_2024_03
    using AdventOfCode;
    using Parsers;

    parse_inputs(lines::Vector{String})::String  = join(lines);

    function find_muls(input)
        tot = 0;
        for m in eachmatch(r"mul\((\d+),(\d+)\)", input)
            a = Parsers.parse(Int64, m[1])
            b = Parsers.parse(Int64, m[2])
            tot += a * b
        end
        return tot;
    end

    solve_part_1(inputs) = find_muls(inputs);

    function solve_part_2(inputs)

        do_blocks = split(inputs, "do()")
        
        tot = 0;
        for do_block in do_blocks
            a1 = split(do_block, "don't()")[1]
            tot += find_muls(a1)
        end

        return tot;
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