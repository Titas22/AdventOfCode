module AoC_2024_12
    using AdventOfCode;

    struct Region
        Symbol::Char
        Area::Int
        Perimeter::Int
        Sides::Int
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

const directions::Vector{CartesianIndex{2}} = CartesianIndex.([(-1,0), (0,-1), (1,0), (0,1)]);

notprocessed = trues(size(chmat))

searchList = CartesianIndex{2}[];
regions = AoC_2024_12.Region[];

function is_same_plant_type(chmat::Matrix{Char}, pos::CartesianIndex{2}, symbol::Char)::Bool
    return checkbounds(Bool, chmat, pos) && chmat[pos] == symbol
end

for idx in CartesianIndices(chmat)
    notprocessed[idx] || continue
    push!(searchList, idx);

    symbol = chmat[idx]
    area = perimeter = corners = 0;
    global coords
    coords = CartesianIndex{2}[]
    while !isempty(searchList)
        pos = popfirst!(searchList);
        notprocessed[pos] || continue
        notprocessed[pos] = false
        push!(coords, pos)
        area += 1

        for (ii, dir) in pairs(directions)
            next = pos + dir;
            ccw_pos = pos + directions[mod(ii, 4)+1];
            diag_pos = ccw_pos + dir 

            isnext  = is_same_plant_type(chmat, next, symbol);
            isadj   = is_same_plant_type(chmat, ccw_pos, symbol)
            isdiag  = is_same_plant_type(chmat, diag_pos, symbol)

            if !isnext
                perimeter += 1
                if !isadj #&& !isdiag
                    corners += 1
                end
                continue
            else
                if !isadj && isdiag
                    corners += 1
                end
            end

            push!(searchList, next);
        end
    end
    push!(regions, AoC_2024_12.Region(symbol, area, perimeter, corners))
end


# plant_types = unique(chmat);

display(regions)

p1 = mapreduce(r -> r.Area * r.Perimeter, +, regions)
p2 = mapreduce(r -> r.Area * r.Sides, +, regions)


# for (ii, dir) in pairs(directions)
#     jj = mod(ii, 4)+1
#     @printf("%d->%d dir: %s   cw_dir: %s\n", ii, jj, dir, directions[jj])
# end

# # 865044 - too low
# 872382