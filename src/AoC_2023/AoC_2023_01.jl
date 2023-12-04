module AoC_2023_01
    using AdventOfCode;
    const AoC = AdventOfCode;

    function get_digits_1(l::AbstractString)
        first = findfirst(r"\d", l);
        r = reverse(l);
        last = findfirst(r"\d", r);

        return parse(Int64, l[first]*r[last])
    end

    function get_digits_2(l::AbstractString)
        idx_first = Inf;
        idx_last = 0;
        first = last = "0";

        for (lkp, num) in [("one", "1"), ("two", "2"), ("three", "3"), ("four", "4"), ("five", "5"), ("six", "6"), ("seven", "7"), ("eight", "8"), ("nine", "9"), ("zero", "0"),
                    ("1", "1"), ("2", "2"), ("3", "3"), ("4", "4"), ("5", "5"), ("6", "6"), ("7", "7"), ("8", "8"), ("9", "9"), ("0", "0")]
            idx = findall(lkp, l)
            (isempty(idx) || isnothing(idx)) && continue;
            
            if idx[1][1] < idx_first
                idx_first = idx[1][1];
                first = num;
            end
            
            if idx[end][1] > idx_last
                idx_last = idx[end][1];
                last = num;
            end
        end

        return parse(Int64, first*last)
    end

    solve_part_1(inputs) = sum(get_digits_1.(inputs));
    solve_part_2(inputs) = sum(get_digits_2.(inputs));

    function solve(bTestCase::Bool = false)::Tuple{Any, Any};
        lines       = @getInputs(bTestCase);
        lines2      = bTestCase ? @getInputs(bTestCase, "_2") : lines;

        part1       = solve_part_1(lines);
        part2       = solve_part_2(lines2);

        return (part1, part2);
    end

    # @time (part1, part2) = solve(true); # Test
    @time (part1, part2) = solve();
    println("\nPart 1 answer: $(part1)");
    println("\nPart 2 answer: $(part2)");
end # module AoC_23_01
