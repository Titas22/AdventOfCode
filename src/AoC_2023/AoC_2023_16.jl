module AoC_2023_16
    using AdventOfCode;
    const AoC = AdventOfCode;

    function check_passed!(state::Array{Bool, 3}, pos::Tuple{Int, Int}, direction::Tuple{Int, Int})::Bool
        has_passed = false;
        if direction[1] != 0
            if direction[1] == -1 # Up
                has_passed = state[pos[1], pos[2], 1];
                state[pos[1], pos[2], 1] = true;
            else # direction[1] == 1 # Down
                has_passed = state[pos[1], pos[2], 2];
                state[pos[1], pos[2], 2] = true;
            end
        elseif direction[2] == -1 # Left
            has_passed = state[pos[1], pos[2], 3];
            state[pos[1], pos[2], 3] = true;
        else direction[2] == 1 # Right
            has_passed = state[pos[1], pos[2], 4];
            state[pos[1], pos[2], 4] = true;
        end
        return has_passed;
    end

    function parse_inputs(lines::Vector{String})::Tuple{Matrix{Char}, Array{Bool, 3}}
        layout = permutedims(reduce(hcat, collect.(lines)))
        statemat = collect(falses(size(layout)..., 4));
        return (layout, statemat)
    end

    function make_move!(statemat, layout, prev, dir)
        (n, m) = size(statemat);
        
        pos = prev .+ dir;
        0 < pos[1] <= n || return;
        0 < pos[2] <= m || return;
    
        check_passed!(statemat, pos, dir) && return;
        ch = layout[pos[1], pos[2]];
    
        while ch == '.'
            pos = pos .+ dir;
            0 < pos[1] <= n || return;
            0 < pos[2] <= m || return;
            check_passed!(statemat, pos, dir)
            ch = layout[pos[1], pos[2]];
        end

        if ch == '\\'
            make_move!(statemat, layout, pos, (dir[2], dir[1]));
        elseif ch == '/'
            make_move!(statemat, layout, pos, (-dir[2], -dir[1]));
        elseif ch == '|'
            if dir[1] == 0
                make_move!(statemat, layout, pos, (-1,0));
                make_move!(statemat, layout, pos, (1,0));
            else
                make_move!(statemat, layout, pos, dir);
            end
        else # ch == '-'
            if dir[2] == 0
                make_move!(statemat, layout, pos, (0,-1));
                make_move!(statemat, layout, pos, (0,1));
            else
                make_move!(statemat, layout, pos, dir);
            end
        end
    end

    function find_energised_count(layout::Matrix{Char}, statemat::Array{Bool, 3}, start_pos::Tuple{Int, Int}, start_dir::Tuple{Int, Int})
        statemat .= false;
        make_move!(statemat, layout, start_pos, start_dir);
        return count(any(statemat, dims=3))
    end

    solve_part_1(layout::Matrix{Char}, statemat::Array{Bool, 3}) = find_energised_count(layout, statemat, (1, 0), (0, 1));

    function solve_part_2(layout::Matrix{Char}, statemat::Array{Bool, 3})
        most_energised = 0;
        (n, m) = size(layout);
        for ii in 1 : n
            most_energised = max(most_energised, find_energised_count(layout, statemat, (ii, 0), (0, 1)))
            most_energised = max(most_energised, find_energised_count(layout, statemat, (ii, m+1), (0, -1)))
        end
        for jj in 1 : m
            most_energised = max(most_energised, find_energised_count(layout, statemat, (0, jj), (1, 0)))
            most_energised = max(most_energised, find_energised_count(layout, statemat, (n+1, jj), (-1, 0)))
        end
        return most_energised;
    end

    function solve(btest::Bool = false)::Tuple{Any, Any};
        lines       = @getinputs(btest);
        (layout, statemat) = parse_inputs(lines);

        part1       = solve_part_1(layout, statemat);
        part2       = solve_part_2(layout, statemat);
        
        return (part1, part2);
    end

    # @time (part1, part2) = solve(true); # Test
    @time (part1, part2) = solve();
    println("\nPart 1 answer: $(part1)");
    println("\nPart 2 answer: $(part2)\n");
end
