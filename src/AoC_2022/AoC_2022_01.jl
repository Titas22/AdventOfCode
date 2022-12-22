module AoC_2022_01

    using AdventOfCode;

    function getSortedCalories(lines)::Vector{Int64}
        calories = Vector{Int64}()

        currentCount = 0;
        for l = lines
            if !isempty(l)
                currentCount += parse(Int64, l);
                continue
            end

            push!(calories, currentCount)
            currentCount = 0;
        end

        sort!(calories, rev=true)

        return calories;
    end

    function solve(bTestCase::Bool = false)::Tuple{Any, Any};
        lines       = @getInputs(bTestCase);
        calories    = getSortedCalories(lines);
        return (calories[1], sum(calories[1:3]));
    end

    # # @time (part1, part2) = solve(true); # Test
    # @time (part1, part2) = solve();
    # println("\nPart 1 answer: $(part1)");
    # println("Part 2 answer: $(part2)");

end # module AoC_22_01