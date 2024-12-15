module AoC_2024_12
    using AdventOfCode;

    struct Region
        Symbol::Char
        Area::Int
        Perimeter::Int
    end

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

chmat = lines2charmat(lines)

const directions::Vector{CartesianIndex{2}} = CartesianIndex.([(-1,0), (1,0), (0,-1), (0,1)]);

notprocessed = trues(size(chmat))

searchList = CartesianIndex{2}[];
regions = AoC_2024_12.Region[];


for idx in CartesianIndices(chmat)
    notprocessed[idx] || continue
    push!(searchList, idx);

    symbol = chmat[idx]
    perimeter = 0;
    area = 0;

    while !isempty(searchList)
        pos = popfirst!(searchList);
        notprocessed[pos] || continue
        notprocessed[pos] = false
        area += 1

        for dir in directions
            next = pos + dir;
            if !checkbounds(Bool, chmat, next) || chmat[next] != symbol
                perimeter += 1
                continue
            end

            push!(searchList, next);
        end
    end

    push!(regions, AoC_2024_12.Region(symbol, area, perimeter))
end


# plant_types = unique(chmat);

display(regions)

mapreduce(r -> r.Area * r.Perimeter, +, regions)