module AoC_2024_11
    using AdventOfCode;

    function parse_inputs(lines::Vector{String})

        return lines;
    end
    function solve_common(inputs)

        return inputs;
    end

    function solve_part_1(inputs)

        return nothing;
    end

    function solve_part_2(inputs)

        return nothing;
    end

    function solve(btest::Bool = false)::Tuple{Any, Any}
        lines       = @getinputs(btest);
        # lines2      = @getinputs(btest, "_2"); # Use if 2nd problem test case inputs are different
        inputs      = parse_inputs(lines);

        solution    = solve_common(inputs);
        part1       = solve_part_1(solution);
        part2       = solve_part_2(solution);

        return (part1, part2);
    end

    @time (part1, part2) = solve(true); # Test
    # @time (part1, part2) = solve();
    println("\nPart 1 answer: $(part1)");
    println("\nPart 2 answer: $(part2)\n");
end
lines = @getinputs(false)

stones = Parsers.parse.(Int, collect(split.(lines[1])))
stones = [125 17]
number_of_digits(val::Int) = floor(Int, log10(val)) + 1

function blink(stone::Int)
    stone == 0 && return [1]
    ndigits = number_of_digits(stone)
    if ndigits % 2 == 0
        power = 10^(ndigits ÷ 2)
        return [stone ÷ power, mod(stone, power)]
    end
    return [stone * 2024]
end

for ii = 1 : 25
    new_stones = blink.(stones)
    global stones
    stones = vcat(new_stones...)
end

println(length(stones))