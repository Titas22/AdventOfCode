module AoC_2024_21
    using AdventOfCode
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
end

lines = @getinputs(false)

numeric_keypad = AoC_2024_21.NUMERIC_KEYPAD
directional_keypad = AoC_2024_21.DIRECTIONAL_KEYPAD

numeric_distances = AoC_2024_21.get_distance_map(numeric_keypad)
directional_distances = AoC_2024_21.get_distance_map(directional_keypad)

println("\n")

function find_inputs(code::String)
    robot_locations = ['A', 'A', 'A']
    temp_location_A = robot_locations[1]
    full_shortest_path = ""
    for targetA in code
        # global numeric_distances, directional_distances, temp_location_A, full_shortest_path
        # possible_sequences = String[]
        pathsA = numeric_distances[temp_location_A][targetA] .* 'A'
        println("RobotA location: '$(temp_location_A)'   target: '$targetA'   options: $(pathsA)")
        temp_dict = Dict{Tuple{String, String}, String}()
        final_shortest_A = ""
        # shortest_B = ""
        for pathA in pathsA
            println("B -> A checking path: '$pathA'")
            temp_location_B = robot_locations[2]
            shortest_A = ""
            for targetB in pathA
                pathsB = directional_distances[temp_location_B][targetB] .* 'A'
                println("\tRobotB location: '$(temp_location_B)'   target: '$targetB'   options: $(pathsB)")

                shortest_B = ""
                for pathB in pathsB
                    temp_location_C = robot_locations[3]
                    println("\tC -> B checking path: '$pathB'")
                    shortest_C = ""
                    for targetC in pathB
                        pathsC = directional_distances[temp_location_C][targetC] .* 'A'
                        println("\t\tRobotC location: '$(temp_location_C)'   target: '$targetC'   options: $(pathsC)")

                        for pathC in pathsC
                            println("\t\t\tChecking input option: '$pathC'")
                            
                        end

                        t = (pathA, pathB)
                        if !haskey(temp_dict, t)
                            temp_dict[t] = ""
                        end
                        temp_dict[t] *= pathsC[1]

                        shortest_C *= pathsC[end] # can take either
                        
                        temp_location_C = targetC
                    end

                    if isempty(shortest_B) || length(shortest_B) > length(shortest_C)
                        shortest_B = shortest_C
                    end
                end

                println("\tShortest B: $(shortest_B)\n")
                temp_location_B = targetB
                shortest_A *= shortest_B
            end

            println("Shortest A: $(shortest_A)\n")
            if isempty(final_shortest_A) || length(final_shortest_A) > length(shortest_A)
                final_shortest_A = shortest_A
            end
            # println("Shortest B->A: $(shortest_B)\n")
        end
        println("Final Shortest A: $(final_shortest_A)\n")
        temp_location_A = targetA

        # paths = collect(values(temp_dict))
        # display(temp_dict)
        # (len, idx) = findmin(length, paths)
        # println("Shortest path: $(paths[idx])")
        # full_shortest_path *= paths[idx]

        full_shortest_path *= final_shortest_A
    end
    println("Final $code: $(full_shortest_path)")

    return full_shortest_path
end
println("Correct:       <vA<AA>>^AvAA<^A>A<v<A>>^AvA^A<vA>^A<v<A>^A>AAvA^A<v<A>A>^AAAvA<^A>A")

total = 0
for line in lines
    global total
    full_shortest_path = find_inputs(line)
    total += Parsers.parse(Int, line[1:end-1]) * length(full_shortest_path)
end

println("Total $(total)")


function print_movements(keypad::AoC_2024_21.Keypad, pos::CartesianIndex{2}, inputs::String)::String
    movements = ""
    for ch in inputs
        if ch == 'v'
            pos = CartesianIndex(pos[1] + 1, pos[2])
        elseif ch == '^'
            pos = CartesianIndex(pos[1] - 1, pos[2])
        elseif ch == '<'
            pos = CartesianIndex(pos[1], pos[2]-1)
        elseif ch == '>'
            pos = CartesianIndex(pos[1], pos[2]+1)
        else
            movements *= keypad[pos]
        end
    end
    println(movements)
    return movements
end

println("")

# print("Inputs 2: "); inputs_B = print_movements(directional_keypad, CartesianIndex(1,3), full_shortest_path)
println("Inputs 1: <vA<AA>>^AvAA<^A>A<v<A>>^AvA^A<vA>^A<v<A>^A>AAvA^A<v<A>A>^AAAvA<^A>A")
print("Inputs 2: "); inputs_B = print_movements(directional_keypad, CartesianIndex(1,3), "<vA<AA>>^AvAA<^A>A<v<A>>^AvA^A<vA>^A<v<A>^A>AAvA^A<v<A>A>^AAAvA<^A>A")
print("Inputs 3: "); inputs_C = print_movements(directional_keypad, CartesianIndex(1,3), inputs_B)
# print("Outputs:  "); outputs  = print_movements(numeric_keypad, CartesianIndex(3,2), inputs_C)
print("Outputs:  "); outputs  = print_movements(numeric_keypad, CartesianIndex(4,3), inputs_C)
println("")

println("Test:")
println("Inputs 1: $(full_shortest_path)")
print("Inputs 2: "); inputs_B = print_movements(directional_keypad, CartesianIndex(1,3), full_shortest_path)
print("Inputs 3: "); inputs_C = print_movements(directional_keypad, CartesianIndex(1,3), inputs_B)
print("Outputs:  "); outputs  = print_movements(numeric_keypad, CartesianIndex(4,3), inputs_C)
println("")