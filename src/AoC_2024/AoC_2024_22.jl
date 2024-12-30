module AoC_2024_22
    using AdventOfCode
    using Parsers

    parse_inputs(lines::Vector{String})::Vector{Int} = Parsers.parse.(Int, lines)

    prune(secret::Int)::Int = mod(secret, 16777216)
    mix(secret::Int, value::Int)::Int = secret ⊻ value
    mixprune(secret::Int, value::Int)::Int = prune(mix(secret, value))

    function evolve(secret::Int)::Int
        secret = mixprune(secret, secret * 64)
        secret = mixprune(secret, secret ÷ 32)
        secret = mixprune(secret, secret * 2048)
        return secret
    end

    function solve_common(initial_secrets::Vector{Int})::Tuple{Int, Int}
        nsales = 2000
        
        total_gainz = zeros(Int, 19, 19, 19, 19)
        total_secrets = 0
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
            total_secrets += secret
        end
        
        (gainz, idx) = findmax(total_gainz)
        return (total_secrets, gainz)
    end

    function solve(btest::Bool = false)::Tuple{Any, Any}
        lines       = @getinputs(btest)
        secrets     = parse_inputs(lines)

        (part1, part2) = solve_common(secrets)

        return (part1, part2);
    end

    # @time (part1, part2) = solve(true); # Test
    @time (part1, part2) = solve();
    println("\nPart 1 answer: $(part1)");
    println("\nPart 2 answer: $(part2)\n");

    @assert(part1 == 16619522798, "Part 1 is wrong")
    @assert(part2 == 1854, "Part 2 is wrong")
end