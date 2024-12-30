module AoC_2024_22
    using AdventOfCode
    using Parsers

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


prune(secret::Int)::Int = mod(secret, 16777216)
mix(secret::Int, value::Int)::Int = secret ⊻ value
mixprune(secret::Int, value::Int)::Int = prune(mix(secret, value))

function evolve(secret::Int)::Int
    secret = mixprune(secret, secret * 64)
    secret = mixprune(secret, secret ÷ 32)
    secret = mixprune(secret, secret * 2048)
    return secret
end


initial_secrets = Parsers.parse.(Int, lines)


for ii = 1 : 2000
    global initial_secrets
    initial_secrets = evolve.(initial_secrets)
end
initial_secrets
sum(initial_secrets)
    