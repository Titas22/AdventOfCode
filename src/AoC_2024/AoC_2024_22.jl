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

nbuyers = length(lines)
nsales = 2000

total_gainz = zeros(Int, 19, 19, 19, 19)
for secret in initial_secrets
    last_changes = zeros(Int, 4)
    last_price = mod(secret, 10)
    already_sold = falses(19, 19, 19, 19)
    for ii = 1 : nsales
        secret = evolve(secret)
        price = mod(secret, 10)

        popfirst!(last_changes)
        push!(last_changes, price - last_price + 10)
        last_price = price

        ii > 3 || continue

        idx = CartesianIndex(last_changes[1], last_changes[2], last_changes[3], last_changes[4])
        already_sold[idx] && continue
        total_gainz[idx] += price
        already_sold[idx] = true
    end
end
p1 = sum(initial_secrets)
initial_secrets

(gainz, idx) = findmax(total_gainz)
