module AoC_2024_15
    using AdventOfCode;
    const AoC = AdventOfCode;

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
# lines = @getinputs(true, "_simple")
# lines = @getinputs(true)
lines = @getinputs(false)

inputs = split_at_empty_lines(lines)

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

moves = join(inputs[2])
map = lines2charmat(inputs[1])
expanded_map = expand_map(map)

robot_pos = findfirst(x -> x=='@', map)
map[robot_pos] = '.'

is_end(ch::Char)::Bool = ch == '#' || ch == '.'

function showmap(map::Matrix{Char}, robot_pos::CartesianIndex{2})
    copymap = copy(map);
    copymap[robot_pos] = '@'
    for row in eachrow(copymap)
        println(join(row))
    end
end

# showmap(map, robot_pos)

for move in moves
    global robot_pos, map
    if move == '^'
        dir = CartesianIndex(-1, 0)
    elseif move == '<'
        dir = CartesianIndex(0, -1)
    elseif move == '>'
        dir = CartesianIndex(0, 1)
    else # move == 'v'
        dir = CartesianIndex(1, 0)
    end

    next = robot_pos + dir

    ii = 0
    while !is_end(map[next])
        ii += 1
        next += dir
    end

    if map[next] == '#'
        # println("Move: " * string(move))
        # showmap(map, robot_pos)
        continue 
    end
    
    for jj = ii : -1 : 1
        map[next] = 'O'
        next -= dir
        map[next] = '.'
    end

    # println("Move: " * string(move))
    # showmap(map, next)
    robot_pos = next
end
# showmap(map, robot_pos)

gps_sum = 0

gps_coordinate(idx::CartesianIndex{2})::Int = (idx[1]-1) * 100 + idx[2] - 1

for idx in CartesianIndices(map)
    map[idx] == 'O' || continue
    global gps_sum
    gps_sum += gps_coordinate(idx)
end
p1 = gps_sum

println(p1)

robot_pos = findfirst(x -> x=='@', expanded_map)
expanded_map[robot_pos] = '.'
showmap(expanded_map, robot_pos)



function queue_block!(vq::Vector{Tuple{Char, CartesianIndex{2}}}, map::Matrix{Char}, pos::CartesianIndex{2}, dir::CartesianIndex{2})
    ch = map[pos]
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
ispart2 = true

for move in moves#[1:20]
    global robot_pos, expanded_map
    if move == '^'
        dir = CartesianIndex(-1, 0)
        verticalmove = true
    elseif move == '<'
        dir = CartesianIndex(0, -1)
        verticalmove = false
    elseif move == '>'
        dir = CartesianIndex(0, 1)
        verticalmove = false
    else # move == 'v'
        dir = CartesianIndex(1, 0)
        verticalmove = true
    end
    next = robot_pos + dir

    if ispart2 && verticalmove && !is_end(expanded_map[next])
        vq = Tuple{Char, CartesianIndex{2}}[]
        queue_block!(vq, expanded_map, next, dir)

        moveable = true
        for (ch, v) in vq
            if expanded_map[v + dir] == '#'
                moveable = false;
                break
            end
        end

        # display(vq);
        # display(moveable)
        moveable || continue
        # if !moveable
        #     println("\nMove (NOT): " * string(move))
        #     showmap(expanded_map, robot_pos)
        #     continue
        # end

        for (_, vpos) in vq
            expanded_map[vpos] = '.'
        end
        for (ch, vpos) in vq
            expanded_map[vpos+dir] = ch
        end
    else

        ii = 0
        while !is_end(expanded_map[next])
            ii += 1
            next += dir
        end

        expanded_map[next] == '#' && continue
        
        for jj = ii : -1 : 1
            expanded_map[next] = expanded_map[next-dir]
            next -= dir
        end
        expanded_map[next] = '.'
    end
    robot_pos = next

    # println("\nMove: " * string(move))
    # showmap(expanded_map, robot_pos)
end



function egps_coordinate(idx::CartesianIndex{2}, sz::Tuple{Int, Int})::Int 
    dleft = idx[2] - 1
    dright = sz[2] - idx[2]

    dtop = idx[1] - 1
    dbottom = sz[1] - idx[1]
    
    egps = min(dleft, dright) + min(dtop, dbottom) * 100;

    # println("\nDistance left: " * string(dleft))
    # println("Distance right: " * string(dright))
    # println("Distance top: " * string(dtop))
    # println("Distance bottom: " * string(dbottom))
    # println("GPS Coordinate: " * string(egps))
    return egps
end

egps_sum = 0
sz = size(expanded_map)
for idx in CartesianIndices(expanded_map)
    expanded_map[idx] == '[' || continue
    global egps_sum
    egps_sum += gps_coordinate(idx)
end
p2 = egps_sum