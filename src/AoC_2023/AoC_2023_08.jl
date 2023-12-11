module AoC_2023_08
    using AdventOfCode;
    const AoC = AdventOfCode;

    struct Node
        Name::AbstractString
        Moves::Tuple{Int, Int}
        EndNode::Bool
    end

    function Node(line::AbstractString, node_names::Dict{String, Int64})::Node
        Node(line[1:3], (node_names[line[8:10]], node_names[line[13:15]]), line[3] == 'Z')
    end
    function parse_inputs(lines::Vector{String})
        moves = lines[1];
        nodes = Node[]
        sizehint!(nodes, length(lines)-2)
        node_names = Dict([line[1:3]=>idx for (idx, line) in enumerate(lines[3:end])])
        for line in lines[3:end]
            push!(nodes, Node(line, node_names));
        end
        return (moves, nodes);
    end

    function make_move(nodes, current, move)
        idx = move == 'L' ? 1 : 2
        next = current.Moves[idx];
        node = nodes[next]
        return node;
    end

    function count_moves_to_finish(nodes, moves, current)::Int
        done = false;
        n = 0;
        while !done
            for move in moves
                n += 1;
                current = make_move(nodes, current, move);
                if current.EndNode
                    done = true;
                    break;
                end
            end
        end
        return n;
    end

    solve_part_1(moves, nodes) = count_moves_to_finish(nodes, moves, [k for k in nodes if k.Name == "AAA"][1]);

    function solve_part_2(moves, nodes)
        current_nodes = [k for k in nodes if endswith(k.Name, 'A')];
        cycle_length = Vector{Int}(undef, length(current_nodes));
        for idx in eachindex(current_nodes)
            cycle_length[idx] = count_moves_to_finish(nodes, moves, current_nodes[idx]);
        end
        return lcm(cycle_length);
    end

    function solve(btest::Bool = false)::Tuple{Any, Any};
        lines       = @getinputs(btest);
        (moves, nodes)      = parse_inputs(lines);

        part1       = solve_part_1(moves, nodes);
        part2       = solve_part_2(moves, nodes);
        
        return (part1, part2);
    end

    # @time (part1, part2) = solve(true); # Test
    @time (part1, part2) = solve();
    println("\nPart 1 answer: $(part1)");
    println("\nPart 2 answer: $(part2)\n");
end

# lines       = @getinputs(false);

# (moves, nodes)      = AoC_2023_08.parse_inputs(lines);
# println("moves: $(length(moves))")

# current_nodes = [nodes[k] for k in keys(nodes) if endswith(k, 'A')];
# println("start nodes: $(length(current_nodes))")

# done = false;
# n = 0;

# for current in current_nodes
#     starting_name = current.Name;
#     n = 0;
#     println("$(n) running $(starting_name)")
#     ncycles = 0;
#     while ncycles < 3
#         for move in moves
#             n+=1;
#             current = AoC_2023_08.make_move(nodes, current, move);
#             if endswith(current.Name, 'Z')
#                 ncycles += 1;
#                 println("$(current.Name) at $(n)")
#             elseif current.Name == starting_name
#                 println("back on $(starting_name) at $(n)")
#             end
#         end
#     end
#     println("")
# end
