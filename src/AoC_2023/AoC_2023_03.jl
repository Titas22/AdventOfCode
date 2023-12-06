module AoC_2023_03
    using AdventOfCode;
    using StaticArrays;

    const AoC = AdventOfCode;
    const TwoVec = Tuple{Int, Int};

    parse_inputs(lines::Vector{String})::Matrix{Char} = reduce(vcat, permutedims.(collect.(lines)));
    
    function get_indices(row, start_col, end_col, nrows, ncols)::Tuple{CartesianIndices, CartesianIndices}
        col_from = start_col > 1 ? start_col-1 : start_col;
        col_to   = end_col == ncols ? end_col : end_col+1;
        row_from = row > 1 ? row-1 : row;
        row_to   = row == nrows ? row : row+1;
    
        indices = CartesianIndices((row_from:row_to, col_from:col_to));
        except  = CartesianIndices((row:row, start_col:end_col))
        return (indices, except);
    end

    function process_number!(all_gears::Dict{CartesianIndex{2}, TwoVec}, chars::Matrix{Char}, row::Int, start_col::Int, end_col::Int, nrows::Int, ncols::Int)::Int
        (idx_around, idx_num) = get_indices(row, start_col, end_col, nrows, ncols);

        b_part_number = false;
        num = 0;

        for idx in idx_around
            (idx in idx_num) && continue;
            
            ch = chars[idx];
            if ch != '.' && !isdigit(ch) 
                if !b_part_number
                    num = parse.(Int, String(vec(chars[idx_num])));
                    b_part_number = true;
                end
                if ch == '*'
                    if haskey(all_gears, idx)
                        all_gears[idx] = (all_gears[idx][1], num)
                    else
                        all_gears[idx] = (num, 0);
                    end
                end
            end
        end

        return num;
    end

    function solve_common(chars::Matrix{Char})::Tuple{Int, Dict{CartesianIndex{2}, TwoVec}}
        (n, m)    = size(chars)
        num_start = total = 0;
        all_gears = Dict{CartesianIndex{2}, TwoVec}();

        for ii = 1 : n
            bnum = false
            for jj = 1 : m
                num_ends = false;
                ch = chars[ii, jj];

                if ch == '.'
                    bnum || continue;
                    num_ends = true;
                elseif isdigit(ch)
                    bnum && continue;
                    bnum = true;
                    num_start = jj;
                elseif bnum
                    num_ends = true;
                end

                if num_ends
                    total += process_number!(all_gears, chars, ii, num_start, jj-1, n, m);
                    bnum = false
                end
            end
            
            if bnum
                total += process_number!(all_gears, chars, ii, num_start, m, n, m);
            end
        end

        return (total, all_gears)
    end

    get_total_ratio(all_gears::Dict{CartesianIndex{2}, TwoVec})::Int = sum([gear[1]*gear[2] for gear in values(all_gears) if length(gear) == 2]);

    function solve(btest::Bool = false)::Tuple{Any, Any}
        lines       = @getinputs(btest);
        chars      = parse_inputs(lines);

        (part1, all_gears)  = solve_common(chars);
        part2               = get_total_ratio(all_gears);

        return (part1, part2);
    end

    # @time (part1, part2) = solve(true); # Test
    @time (part1, part2) = solve();
    println("\nPart 1 answer: $(part1)");
    println("\nPart 2 answer: $(part2)");
end
