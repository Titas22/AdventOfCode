module AoC_2024_15
    using AdventOfCode;

    function expand_map(map::Matrix{Char})::Matrix{Char}
        expanded_map = Matrix{Char}(undef, size(map, 1), size(map, 2) * 2)
        for idx in CartesianIndices(map)
            new_idx1 = CartesianIndex(idx[1], (idx[2]-1)*2+1)
            new_idx2 = new_idx1 + CartesianIndex(0, 1)
            if map[idx] == '#'
                expanded_map[new_idx1] = '#'
                expanded_map[new_idx2] = '#'
            elseif map[idx] == 'O'
                expanded_map[new_idx1] = '['
                expanded_map[new_idx2] = ']'
            else
                if map[idx] == '.'
                    expanded_map[new_idx1] = '.'
                else # map[idx] == '@'
                    expanded_map[new_idx1] = '@'
                end
                expanded_map[new_idx2] = '.'
            end
        end
        return expanded_map
    end

    function parse_inputs(lines::Vector{String})::Tuple{AbstractString, Matrix{Char}, Matrix{Char}}
        inputs          = split_at_empty_lines(lines)
        moves           = join(inputs[2])
        map             = lines2charmat(inputs[1])
        expanded_map    = expand_map(map)
        return (moves, map, expanded_map);
    end
    
    function get_start_positions(map::Matrix{Char})::Tuple{CartesianIndex{2}, CartesianIndex{2}}
        start_pos       = findfirst(x -> x=='@', map)
        start_pos_ext   = CartesianIndex(start_pos[1], start_pos[2] * 2 - 1)
        return (start_pos, start_pos_ext)
    end

    function showmap(map::Matrix{Char}, robot_pos::CartesianIndex{2})
        copymap = copy(map);
        copymap[robot_pos] = '@'
        [println(join(row)) for row in eachrow(copymap)]
    end

    is_end(ch::Char)::Bool = ch == '#' || ch == '.'

    gps_coordinate(pos::CartesianIndex{2})::Int = (pos[1]-1) * 100 + pos[2] - 1

    function queue_block!(vq::Vector{Tuple{Char, CartesianIndex{2}}}, map::Matrix{Char}, pos::CartesianIndex{2}, dir::CartesianIndex{2})
        @inbounds ch = map[pos]
        if ch == ']'
            pair_pos = pos + CartesianIndex(0, -1)
            pair_ch = '['
        elseif ch == '['
            pair_pos = pos + CartesianIndex(0, 1)
            pair_ch = ']'
        else
            return
        end
        push!(vq, (ch, pos))
        push!(vq, (pair_ch, pair_pos))
        
        queue_block!(vq, map, pos+dir, dir)
        queue_block!(vq, map, pair_pos+dir, dir)
    end

    function get_move_direction(move::Char)::Tuple{CartesianIndex{2}, Bool}
        if move == '^'
            return (CartesianIndex(-1, 0), true)
        elseif move == '<'
            return (CartesianIndex(0, -1), false)
        elseif move == '>'
            return (CartesianIndex(0, 1), false)
        else # move == 'v'
            return (CartesianIndex(1, 0), true)
        end
    end

    function calculate_GPS_sum(map::Matrix{Char}, ispart2::Bool)::Int
        chgps = ispart2 ? '[' : 'O'
        gps_sum = 0
        for idx in CartesianIndices(map)
            map[idx] == chgps || continue
            gps_sum += gps_coordinate(idx)
        end
        return gps_sum
    end

    function solve_common(map::Matrix{Char}, moves::AbstractString, robot_pos::CartesianIndex{2}, ispart2::Bool)
        map[robot_pos] = '.'
        # showmap(expanded_map, robot_pos)
        
        vq = Tuple{Char, CartesianIndex{2}}[]
        sizehint!(vq, 510)
        @inbounds for move in moves
            (dir, verticalmove) = get_move_direction(move)
            next = robot_pos + dir
        
            if ispart2 && verticalmove && !is_end(map[next])
                empty!(vq)
                queue_block!(vq, map, next, dir)
                
                moveable = true
                for (_, v) in Iterators.reverse(vq)
                    if map[v + dir] == '#'
                        moveable = false;
                        break
                    end
                end
        
                if !moveable
                    # println("\nBLOCKED Move: " * string(move))
                    # showmap(expanded_map, robot_pos)
                    continue
                end
        
                for (_, vpos) in vq
                    map[vpos] = '.'
                end
                for (ch, vpos) in vq
                    map[vpos+dir] = ch
                end
            else
                ii = 0
                while !is_end(map[next])
                    ii += 1
                    next += dir
                end
                map[next] == '#' && continue
                
                for _ = ii : -1 : 1
                    map[next] = map[next-dir]
                    next -= dir
                end
                map[next] = '.'
            end
            robot_pos = next
        
            # println("\nMove: " * string(move))
            # showmap(expanded_map, robot_pos)
        end
        
        return calculate_GPS_sum(map, ispart2)
    end

    solve_part_1(map::Matrix{Char}, moves::AbstractString, start_pos::CartesianIndex{2})::Int = solve_common(map, moves, start_pos, false);
    solve_part_2(map::Matrix{Char}, moves::AbstractString, start_pos::CartesianIndex{2})::Int = solve_common(map, moves, start_pos, true);

    function solve(btest::Bool = false)::Tuple{Any, Any}
        lines               = @getinputs(btest);
        (moves, map, emap)  = parse_inputs(lines);
        (start_pos, start_pos_ext) = get_start_positions(map)

        part1       = solve_part_1(map, moves, start_pos);
        part2       = solve_part_2(emap, moves, start_pos_ext);

        return (part1, part2);
    end

    # @time (part1, part2) = solve(true); # Test
    @time (part1, part2) = solve();
    println("\nPart 1 answer: $(part1)");
    println("\nPart 2 answer: $(part2)\n");
end