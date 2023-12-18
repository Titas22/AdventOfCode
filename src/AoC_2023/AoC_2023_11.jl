module AoC_2023_11
    using AdventOfCode;
    const AoC = AdventOfCode;

    function get_offsets(bempty::BitVector)::Vector{Int}
        offsets     = zeros(Int, size(bempty, 1))
        idx_empty   = findall(bempty);
        for ii in eachindex(idx_empty[1:end-1])
            offsets[idx_empty[ii]+1:idx_empty[ii+1]] .= ii;
        end
        offsets[idx_empty[end]:end] .= size(idx_empty, 1);
    
        return offsets;
    end

    function parse_inputs(lines::Vector{String})
        galaxies = CartesianIndex[];
        empty_rows = trues(size(lines, 1));
        empty_cols = trues(length(lines[1]));
        for ii in eachindex(empty_rows)
            empty_row = true;
            for jj in eachindex(empty_cols)
                lines[ii][jj] == '.' && continue;
                push!(galaxies, CartesianIndex(ii, jj))
                empty_row       = false;
                empty_cols[jj]  = false;
            end
            empty_rows[ii] = empty_row;
        end
        
        row_offsets = get_offsets(empty_rows)
        col_offsets = get_offsets(empty_cols);
        return (galaxies, row_offsets, col_offsets);
    end

    function get_distance(a::CartesianIndex, b::CartesianIndex, row_offsets::Vector{Int}, col_offsets::Vector{Int}, multiplier)::Int
        a_row = a[1] + row_offsets[a[1]] * multiplier;
        b_row = b[1] + row_offsets[b[1]] * multiplier;
        a_col = a[2] + col_offsets[a[2]] * multiplier;
        b_col = b[2] + col_offsets[b[2]] * multiplier;
        return abs(a_col - b_col) + abs(a_row - b_row)
    end

    function find_distance_sum(galaxies, row_offsets, col_offsets, empty_euivalent_to)::Int
        multiplier      = empty_euivalent_to - 1;
        total           = 0
        for ia in eachindex(galaxies), ib in ia+1 : lastindex(galaxies)
            total += get_distance(galaxies[ia], galaxies[ib], row_offsets, col_offsets, multiplier);
        end
    
        return total;
    end

    function solve(btest::Bool = false)::Tuple{Any, Any};
        lines       = @getinputs(btest);
        (galaxies, row_offsets, col_offsets)      = parse_inputs(lines);

        part1 = find_distance_sum(galaxies, row_offsets, col_offsets, 2);
        part2 = find_distance_sum(galaxies, row_offsets, col_offsets, 1000000);

        return (part1, part2);
    end

    # @time (part1, part2) = solve(true); # Test
    @time (part1, part2) = solve();
    println("\nPart 1 answer: $(part1)");
    println("\nPart 2 answer: $(part2)\n");
end
