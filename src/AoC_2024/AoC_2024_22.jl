module AoC_2024_22
    using AdventOfCode
    using Parsers
    using StaticArrays

    parse_inputs(lines::Vector{String})::Vector{Int} = Parsers.parse.(Int, lines)

    @inline prune(secret::Int)::Int = secret & 16777215 # mod(secret, 16777216)
    @inline mix(secret::Int, value::Int)::Int = secret ⊻ value
    @inline mixprune(secret::Int, value::Int)::Int = prune(mix(secret, value))

    @inline function evolve(secret::Int)::Int
        secret = mixprune(secret, secret << 6) # * 64
        secret = mixprune(secret, secret >> 5) # ÷ 32
        secret = mixprune(secret, secret << 11) # * 2048
        return secret
    end

    @inline function update_buffer!(vec::MVector{4, Int}, new_value::Int)
        @inbounds for i in 1:3
            vec[i] = vec[i + 1]
        end
        vec[4] = new_value
    end

    const MSIZE::Tuple{Int64,Int64,Int64,Int64} = (19, 19, 19, 19)
    
    @inline _sub2ind(vec::MVector{4, Int}) = vec[1] + (vec[2]-1)*19 + (vec[3]-1)*361 + (vec[4]-1)*6859

    function solve_common(initial_secrets::Vector{Int})::Tuple{Int, Int}
        nsales = 2000
        
        total_gainz = zeros(Int, MSIZE)
        total_secrets = 0
        already_sold = falses(MSIZE)
        last_changes = MVector(0,0,0,0)

        for secret in initial_secrets
            last_price = mod(secret, 10)
            fill!(already_sold, false)
            for _ = 1 : nsales
                secret = evolve(secret)
                price = mod(secret, 10)

                update_buffer!(last_changes, price - last_price + 10)
                last_price = price
        
                lidx = _sub2ind(last_changes)
                @inbounds already_sold[lidx] && continue
                @inbounds total_gainz[lidx] += price
                @inbounds already_sold[lidx] = true
            end
            total_secrets += secret
        end
        
        (gainz, _) = findmax(total_gainz)
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
end