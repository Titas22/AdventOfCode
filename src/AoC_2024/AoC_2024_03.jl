module AoC_2024_03
    using AdventOfCode;
    const AoC = AdventOfCode;

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
lines = @getinputs(true)

input  = join(lines);
# m = findall(r"mul\((\d+),(\d+)\)", lines[1])
# # m = eachmatch(, lines[1])

a = [ parse.(Int, split(m.match[5:end-1], ',')) for m in eachmatch(r"mul\((\d+),(\d+)\)", input)]

p1 = sum([x[1] * x[2] for x in a])
# parse.(Int, split(b[5:end-1], ','))

do_blocks = split(input, "do()")

mul_vals = Vector{Int}[]
for do_block in do_blocks
    a1 = split(do_block, "don't()")[1]
    b1 = [ parse.(Int, split(m.match[5:end-1], ',')) for m in eachmatch(r"mul\((\d+),(\d+)\)", a1)]
    push!(mul_vals, b1...)
end

# do_block = do_blocks[1]

# x = split(do_block, "don't()")[1]

mul_vals

# a = split(do_block, "don't()")[1]
# b = [ parse.(Int, split(m.match[5:end-1], ',')) for m in eachmatch(r"mul\((\d+),(\d+)\)", a)]
p2 = sum([x[1] * x[2] for x in mul_vals])