module AoC_2023_xx
    using AdventOfCode;
    const AoC = AdventOfCode;

    function parseInputs(lines::Vector{String})

        return lines;
    end
    function solveCommon(inputs)

        return inputs;
    end

    function solvePart1(inputs)

        return nothing;
    end

    function solvePart2(inputs)

        return nothing;
    end

    function solve(bTestCase::Bool = false)::Tuple{Any, Any};
        lines       = @getInputs(bTestCase);
        # lines2      = @getInputs(bTestCase, "_2"); # Use if 2nd problem test case inputs are different
        inputs      = parseInputs(lines);

        solution    = solveCommon(inputs);
        part1       = solvePart1(solution);
        part2       = solvePart2(solution);

        return (part1, part2);
    end

    # @time (part1, part2) = solve(true); # Test
    @time (part1, part2) = solve();
    println("\nPart 1 answer: $(part1)");
    println("\nPart 2 answer: $(part2)");
end