module AoC_2024_03
    using AdventOfCode;
    using Parsers;

    parse_inputs(lines::Vector{String})::String  = join(lines);
    
    function find_muls(input)
        tot = 0;

        for m in eachmatch(r"mul\(\d+,\d+\)", input)
            idx = findfirst(',', m.match)
            a = Parsers.parse(Int64, m.match[5 : idx-1])
            b = Parsers.parse(Int64, m.match[idx+1 : end-1])
            tot += a * b
        end

        return tot;
    end

    solve_part_1(inputs) = find_muls(inputs);

    function solve_part_2(inputs)
        tot = 0;
        do_blocks = split(inputs, "do()")

        for do_block in do_blocks
            idx = findfirst("don't()", do_block);
            do_block = isnothing(idx) ? do_block : do_block[1 : idx[1]-1]
            tot += find_muls(do_block)
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