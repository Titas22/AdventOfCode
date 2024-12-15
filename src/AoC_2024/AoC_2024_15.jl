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
lines = @getinputs(true, "_simple")
# lines = @getinputs(true)

inputs = split_at_empty_lines(lines)
map = lines2charmat(inputs[1])
moves = join(inputs[2])

robot_pos = findfirst(x -> x=='@', map)
map[robot_pos] = '.'

is_end(ch::Char)::Bool = ch == '#' || ch == '.'

function showmap(map::Matrix{Char}, robot_pos::CartesianIndex{2})
    copymap = copy(map);
    copymap[robot_pos] = '@'
    display(copymap)
end

showmap(map, robot_pos)

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
showmap(map, robot_pos)

gps_sum = 0

gps_coordinate(idx::CartesianIndex{2})::Int = (idx[1]-1) * 100 + idx[2] - 1

for idx in CartesianIndices(map)
    map[idx] == 'O' || continue
    println(idx)
    println(gps_coordinate(idx))
    global gps_sum
    gps_sum += gps_coordinate(idx)
end