module AoC_2024_04
    using AdventOfCode;

    parse_inputs(lines::Vector{String})::Matrix{Char} = reduce(hcat, collect.(lines));

    function solve_part_1(chmat::Matrix{Char})::Int
        directions = CartesianIndices((-1:1, -1:1))

        tot = 0
        for x in findall(ch -> ch == 'X', chmat)
            for d in directions
                checkbounds(Bool, chmat, x+3*d) || continue
                
                chmat[x+3*d] == 'S' || continue;
                chmat[x+2*d] == 'A' || continue;
                chmat[x+d]   == 'M' || continue;
                
                tot += 1
            end
        end
        return tot;
    end
    
    function is_MAS(chmat::Matrix{Char}, x::CartesianIndex{2}, offset::CartesianIndex{2})
        chmat[x + offset] == 'S' && chmat[x - offset] == 'M' && return true;
        return chmat[x + offset] == 'M' && chmat[x - offset] == 'S'
    end

    function solve_part_2(chmat::Matrix{Char})::Int
        (n, m) = size(chmat)

        tot = 0
        for x in findall(ch -> ch == 'A', chmat)
            (x[1] > 1 && x[1] < n && x[2] > 1 && x[2] < m) || continue;
            
            is_MAS(chmat, x, CartesianIndex(1, -1)) || continue;
            is_MAS(chmat, x, CartesianIndex(1, 1)) || continue
            
            tot += 1
        end

        return tot;
    end

    function solve(btest::Bool = false)::Tuple{Any, Any}
        lines       = @getinputs(btest);
        # lines2      = @getinputs(btest, "_2"); # Use if 2nd problem test case inputs are different
        chmat      = parse_inputs(lines);

        part1       = solve_part_1(chmat);
        part2       = solve_part_2(chmat);

        return (part1, part2);
    end

    # @time (part1, part2) = solve(true); # Test
    @time (part1, part2) = solve();
    println("\nPart 1 answer: $(part1)");
    println("\nPart 2 answer: $(part2)\n");
end