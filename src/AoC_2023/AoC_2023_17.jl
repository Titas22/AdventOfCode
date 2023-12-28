module AoC_2023_17
    using AdventOfCode;
    using DataStructures
    const AoC = AdventOfCode;

    struct State
        straight::Int
        pos::CartesianIndex{2}
        dir::CartesianIndex{2}
    end

    function hash(s::State)::UInt64
        h = s.pos[1] * 1000 + s.pos[2];
        h *= 1000;
        h += s.dir[1] * 10 + s.dir[2]
        h *= 100;
        h += s.straight;
        return h;
    end

    parse_inputs(lines::Vector{String}) = parse.(Int,reduce(hcat, collect.(lines)));
    
    function enqueue_state!(pq::PriorityQueue, cumheat::Array{UInt8, 5}, visited::Set, heatmap::Matrix, s::State, heat::Int)
        checkbounds(Bool, heatmap, s.pos[1], s.pos[2]) || return;

        h = hash(s);
        heat += heatmap[s.pos]
        if h in visited 
            cumheat[s.pos[1], s.pos[2], s.straight, 2 + s.dir[1], 2 + s.dir[2]] > heat || return;
            if haskey(pq, s)
                pq[s] = heat;
                return
            end
        end

        enqueue!(pq, s => heat);
        push!(visited, h);
    end    
    
    function find_shortest_path(heatmap::Matrix{Int}, min_straight::Int, max_straight::Int)
        (n,m) = size(heatmap);

        visited = Set{UInt64}();
        cumheat = zeros(UInt8, n, m, max_straight, 3, 3)

        pq = PriorityQueue{State, Int}();
        enqueue_state!(pq, cumheat, visited, heatmap, State(2, CartesianIndex(2, 1), CartesianIndex(1, 0)), 0)
        enqueue_state!(pq, cumheat, visited, heatmap, State(2, CartesianIndex(1, 2), CartesianIndex(0, 1)), 0)
        
        while !isempty(pq)
            (s, heat) = dequeue_pair!(pq);
    
            if s.pos[1] == n && s.pos[2] == m
                s.straight < min_straight && continue;
                return heat;
            end
    
            next_pos = s.pos + s.dir;
            
            if s.straight < min_straight
                enqueue_state!(pq, cumheat, visited, heatmap, State(s.straight+1, next_pos, s.dir), heat) # add straight
            else
                if s.straight < max_straight
                    enqueue_state!(pq, cumheat, visited, heatmap, State(s.straight+1, next_pos, s.dir), heat) # add straight
                end
                enqueue_state!(pq, cumheat, visited, heatmap, State(1, next_pos, CartesianIndex(s.dir[2], s.dir[1])), heat) # add turn
                enqueue_state!(pq, cumheat, visited, heatmap, State(1, next_pos, CartesianIndex(-s.dir[2], -s.dir[1])), heat) # add turn
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

        @assert(part1 == 916, "p1 wrong")
        @assert(part2 == 1067, "p2 wrong")
        return (part1, part2);
    end

    # @time (part1, part2) = solve(true); # Test
    @time (part1, part2) = solve();
    println("\nPart 1 answer: $(part1)");
    println("\nPart 2 answer: $(part2)\n");
end
