module AoC_2024_21
    using AdventOfCode
    using Parsers
    using StaticArrays

    import Base: /

    const Keypad = SMatrix
    const NumericKeypad = Keypad{4, 3, Char}
    const DirectionalKeypad = Keypad{2, 3, Char}

    const NUMERIC_KEYPAD = NumericKeypad(['7' '8' '9'; '4' '5' '6'; '1' '2' '3'; ' ' '0' 'A'])
    const DIRECTIONAL_KEYPAD = DirectionalKeypad([' ' '^' 'A'; '<' 'v' '>'])

    const DIRECTION_MAP = Dict{CartesianIndex{2}, Char}(
        CartesianIndex(-1, 0) => '^',
        CartesianIndex( 1, 0) => 'v',
        CartesianIndex(0, -1) => '<',
        CartesianIndex(0,  1) => '>',
    )
    get_direction_char(dir::CartesianIndex{2})::Char = DIRECTION_MAP[dir]

    # const DIRECTION_MAP = SVector('^', 'v', '<', '>')
    # get_direction_char(dir::CartesianIndex{2})::Char = DIRECTION_MAP[1 + (dir[1] + 1) + (dir[2] + 1) * 2]
    
    is_row_with_empty(keypad::NumericKeypad, idx::CartesianIndex{2})::Bool = idx[1] == 4
    is_row_with_empty(keypad::DirectionalKeypad, idx::CartesianIndex{2})::Bool = idx[1] == 1
    is_col_with_empty(keypad::Keypad, idx::CartesianIndex{2})::Bool = idx[2] == 1

    /(idx::CartesianIndex{2}, d::Int64)::CartesianIndex{2} = CartesianIndex(idx[1]÷d, idx[2]÷d)

    get_straight_path_string(dir::CartesianIndex{2}, dist::Int)::String = repeat(get_direction_char(dir), dist)

    function get_combined_path_string(adir::CartesianIndex{2}, adist::Int, bdir::CartesianIndex{2}, bdist::Int)::String
        return get_straight_path_string(adir, adist) * get_straight_path_string(bdir, bdist)
    end

    function get_paths(keypad::Keypad, from::CartesianIndex{2}, to::CartesianIndex{2})::Vector{String}
        delta = to - from
        if delta[1] == 0 || delta[2] == 0
            # Single straight path
            dist = abs(delta[1]) + abs(delta[2])
            dist == 0 && return [""]
            return [get_straight_path_string(delta ./ dist, dist)]
        end
        
        # Not a straigt path
        vdist = abs(delta[1])
        vdir = delta[1] > 0 ? CartesianIndex(1, 0) : CartesianIndex(-1, 0)
        hdist = abs(delta[2])
        hdir = delta[2] > 0 ? CartesianIndex(0, 1) : CartesianIndex(0, -1)
        
        if is_row_with_empty(keypad, from) && is_col_with_empty(keypad, to)
            # Vertical first
            return [get_combined_path_string(vdir, vdist, hdir, hdist)]
        elseif is_col_with_empty(keypad, from) && is_row_with_empty(keypad, to)
            # Horizontal first
            return [get_combined_path_string(hdir, hdist, vdir, vdist)]
        end

        # 2 Path Options
        vpath = get_straight_path_string(vdir, vdist)
        hpath = get_straight_path_string(hdir, hdist)
        
        isa(keypad, NumericKeypad) || return [vpath * hpath] # Looks like for non-numeric we can always use just one option

        return [vpath * hpath, hpath * vpath]
    end

    function get_distance_map(keypad::Keypad)
        # dict = Dict{Char, Dict{Char, Union{String, Tuple{String, String}}}}()
        dict = Dict{Char, Dict{Char, Vector{String}}}()
        # dict = Dict()
        for from = CartesianIndices(keypad)
            # dict[keypad[from]] = Dict{Char, Union{String, Tuple{String, String}}}()
            dict[keypad[from]] = Dict{Char, Vector{String}}()
            for to = CartesianIndices(keypad)
                (keypad[from] == ' ' || keypad[to] == ' ') && continue


                delta = to - from
                # println("from: " * string(from) * "   to: " * string(to) * "   delta: " * string(delta))
                paths = get_paths(keypad, from, to)
                # println("from: " * keypad[from] * "   to: " * keypad[to] * "   delta: " * string(paths))

                dict[keypad[from]][keypad[to]] = paths
            end
        end

        return dict
    end
    
    numeric_distances = get_distance_map(NUMERIC_KEYPAD)
    directional_distances = get_distance_map(DIRECTIONAL_KEYPAD)
    
    function find_input_sequence(directional_moves::String; depth::Int)::String
        input_sequence = ""
        robot_pos = 'A'
        
        for move in directional_moves
            path = directional_distances[robot_pos][move][1] * 'A'
            if depth == 1
                input_sequence *= path
            else
                input_sequence *= find_input_sequence(path; depth=depth-1)
            end
            robot_pos = move
        end
        return input_sequence
    end
    
    function find_shortest_inputs(code::String, num_directional_robots::Int = 2)::String
        numeric_location = 'A'
        full_shortest_input = ""
        for num in code
            numeric_paths = numeric_distances[numeric_location][num] .* 'A'
            
            shortest_num_input = ""
            for num_path in numeric_paths
                input_sequence = find_input_sequence(num_path; depth=num_directional_robots)
                !isempty(shortest_num_input) && length(input_sequence) > length(shortest_num_input) && continue
                shortest_num_input = input_sequence
            end
    
            full_shortest_input *= shortest_num_input
            numeric_location = num
        end
    
        return full_shortest_input
    end

    function solve_part_1(lines)
        total = 0
        for line in lines
            full_shortest_path = find_shortest_inputs(line, 2)
            total += Parsers.parse(Int, line[1:end-1]) * length(full_shortest_path)
        end
        return total
    end

    function solve_part_2(lines)

        return nothing
    end

    function solve(btest::Bool = false)::Tuple{Any, Any}
        lines       = @getinputs(btest);

        part1       = solve_part_1(lines);
        part2       = solve_part_2(lines);

        return (part1, part2);
    end

    @time (part1, part2) = solve(true); # Test
    # @time (part1, part2) = solve();
    println("\nPart 1 answer: $(part1)");
    println("\nPart 2 answer: $(part2)\n");
end