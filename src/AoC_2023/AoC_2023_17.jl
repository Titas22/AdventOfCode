module AoC_2023_17
    using AdventOfCode;
    using DataStructures
    const AoC = AdventOfCode;

    struct State
        straight::Int
        pos::CartesianIndex{2}
        dir::CartesianIndex{2}
    end

    parse_inputs(lines::Vector{String}) = parse.(Int,reduce(hcat, collect.(lines)));
    
    function enqueue_state!(pq::PriorityQueue{State, Int}, visited::Set{State}, s::State, heat::Int)
        s ∉ visited || return;
        enqueue!(pq, s => heat);
        push!(visited, s);
    end    
    
    function find_shortest_path(heatmap::Matrix{Int}, min_straight::Int, max_straight::Int)
        (n,m) = size(heatmap);
        pq = PriorityQueue{State, Int}();
        start = CartesianIndex(1, 1);
        enqueue!(pq, State(0, start, CartesianIndex(1, 0)), 0)
        enqueue!(pq, State(0, start, CartesianIndex(0, 1)), 0)

        visited = Set{State}();
        cumheat = zeros(n, m, max_straight, 3, 3)

        while !isempty(pq)
            (s, h) = dequeue_pair!(pq);
    
            # next_moves = get_next_moves(s)
            pos = s.pos + s.dir;
            checkbounds(Bool, heatmap, pos[1], pos[2]) || continue;
    
            heat = h + heatmap[pos[1], pos[2]];
    
            if s.straight+1 >= min_straight && pos[1] == n && pos[2] == m
                return heat;
            end
    
            straight = s.straight + 1;
            cumheat[pos[1], pos[2], straight, 2 + s.dir[1], 2 + s.dir[2]] < heat || continue;
            cumheat[pos[1], pos[2], straight, 2 + s.dir[1], 2 + s.dir[2]] = heat;
            
            if straight < min_straight
                enqueue_state!(pq, visited, State(straight, pos, s.dir), heat) # add straight
            else
                if straight < max_straight
                    enqueue_state!(pq, visited, State(straight, pos, s.dir), heat) # add straight
                end
                enqueue_state!(pq, visited, State(0, pos, CartesianIndex(s.dir[2], s.dir[1])), heat) # add turn
                enqueue_state!(pq, visited, State(0, pos, CartesianIndex(-s.dir[2], -s.dir[1])), heat) # add turn
            end
        end
    end

    solve_part_1(heatmap) = find_shortest_path(heatmap, 1, 3);
    solve_part_2(heatmap) = find_shortest_path(heatmap, 4, 10);

    function solve(btest::Bool = false)::Tuple{Any, Any};
        lines       = @getinputs(btest);
        heatmap     = parse_inputs(lines);

        part1       = solve_part_1(heatmap);
        part2       = solve_part_2(heatmap);

        return (part1, part2);
    end

    # @time (part1, part2) = solve(true); # Test
    @time (part1, part2) = solve();
    println("\nPart 1 answer: $(part1)");
    println("\nPart 2 answer: $(part2)\n");
end
