module AoC_2024_12
    using AdventOfCode;

    const directions::Vector{CartesianIndex{2}} = CartesianIndex.([(-1,0), (0,-1), (1,0), (0,1)]);
    struct Region
        Symbol::Char
        Area::Int
        Perimeter::Int
        Sides::Int
    end

    parse_inputs(lines::Vector{String})::Matrix{Char} = lines2charmat(lines)
    
    function is_same_plant_type(chmat::Matrix{Char}, pos::CartesianIndex{2}, symbol::Char)::Bool
        checkbounds(Bool, chmat, pos) || return false
        @inbounds return chmat[pos] == symbol
    end

    function solve_common(chmat::Matrix{Char})::Vector{Region}
        notprocessed = fill(true, size(chmat))

        searchList = CartesianIndex{2}[];
        regions = Region[];
        sizehint!(regions, 600) # a bit of a cheat 👀
        
        @inbounds for idx in CartesianIndices(chmat)
            notprocessed[idx] || continue
            push!(searchList, idx);
        
            symbol = chmat[idx]
            area = perimeter = corners = 0;
            while !isempty(searchList)
                pos = popfirst!(searchList);
                notprocessed[pos] || continue
                notprocessed[pos] = false
                area += 1
        
                for (ii, dir) in pairs(directions)
                    next = pos + dir;
                    ccw_pos = pos + directions[mod(ii, 4)+1];
                    diag_pos = ccw_pos + dir 
        
                    isnext  = is_same_plant_type(chmat, next, symbol);
                    isadj   = is_same_plant_type(chmat, ccw_pos, symbol)
        
                    if !isnext
                        perimeter += 1
                        if !isadj
                            corners += 1
                        end
                        continue
                    elseif !isadj && is_same_plant_type(chmat, diag_pos, symbol)
                        corners += 1
                    end
        
                    notprocessed[next] || continue
                    push!(searchList, next);
                end
            end
            push!(regions, Region(symbol, area, perimeter, corners))
        end
        return regions;
    end

    solve_part_1(regions::Vector{Region})::Int = mapreduce(r -> r.Area * r.Perimeter, +, regions)
    solve_part_2(regions::Vector{Region})::Int = mapreduce(r -> r.Area * r.Sides, +, regions)

    function solve(btest::Bool = false)::Tuple{Any, Any}
        lines       = @getinputs(btest);
        charmat     = parse_inputs(lines);

        regions     = solve_common(charmat);
        part1       = solve_part_1(regions);
        part2       = solve_part_2(regions);

        return (part1, part2);
    end

    # @time (part1, part2) = solve(true); # Test
    @time (part1, part2) = solve();
    println("\nPart 1 answer: $(part1)");
    println("\nPart 2 answer: $(part2)\n");
end