module AoC_2022_04
    using AdventOfCode;

    function processLine(l::String)
        sections = split(l, ',');
        a = parse.(Int64, split(sections[1], '-'));
        b = parse.(Int64, split(sections[2], '-'));
    
        if (a[1] <= b[1] && a[2] >= b[2])
            return 1;
        elseif  (b[1] <= a[1] && b[2] >= a[2])
            return 1;
        else
            return 0;
        end
    end
    
    function processLine2(l::String)
        sections = split(l, ',');
        a = parse.(Int64, split(sections[1], '-'));
        b = parse.(Int64, split(sections[2], '-'));
    
        if max(a[1],b[1]) <= min(a[2],b[2])
            return 1;
        else
            return 0;
        end
    end

    solvePart1(lines::Vector{String}) = sum(processLine.(lines));
    solvePart2(lines::Vector{String}) = sum(processLine2.(lines));

    function solve(bTestCase::Bool = false)::Tuple{Any, Any};
        lines       = @getInputs(bTestCase);

        part1       = solvePart1(lines);
        part2       = solvePart2(lines);

        return (part1, part2);
    end

    # @time (part1, part2) = solve(true); # Test
    # @time (part1, part2) = solve();
    # println("\nPart 1 answer: $(part1)");
    # println("Part 2 answer: $(part2)");
end