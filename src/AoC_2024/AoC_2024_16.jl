module AoC_2024_16
    using AdventOfCode;
    using DataStructures;

    const directions::NTuple{4, CartesianIndex{2}} = CartesianIndex.(((0,1), (-1,0), (0,-1), (1,0)))

    struct State
        pos::CartesianIndex{2}
        idx_dir::Int
        history::Vector{CartesianIndex{2}}
    end

    function parse_inputs(lines::Vector{String})::Tuple{Matrix{Char}, CartesianIndex{2}, CartesianIndex{2}}
        charmat = lines2charmat(lines)
        
        function find_position(charmat::Matrix{Char}, ch::Char)::CartesianIndex{2}
            idx = findfirst(x -> x == ch, charmat)
            charmat[idx] = '.'
            return idx;
        end
        
        start = find_position(charmat, 'S')
        finish = find_position(charmat, 'E')

        return (charmat, start, finish)
    end

    function explore_next!(pq::PriorityQueue{State, Int}, charmat::Matrix{Char}, visited::Matrix{Int}, prev_state::State, ddir::Int, score::Int)
        idx_dir = prev_state.idx_dir + ddir
        if idx_dir == 0
            idx_dir = 4
        elseif idx_dir == 5
            idx_dir = 1;
        end
        
        next = prev_state.pos + directions[idx_dir]
        checkbounds(Bool, charmat, next) || return
        charmat[next] == '.' || return

        next_state = State(next, idx_dir, copy(prev_state.history))
        push!(next_state.history, next)
        if haskey(pq, next_state) 
            pq[next_state] < score && return
            pq[next_state] = score
        else
            enqueue!(pq, next_state => score)
        end
    end

    function solve_common(charmat::Matrix{Char}, start::CartesianIndex{2}, finish::CartesianIndex{2})::Tuple{Int, Vector{Vector{CartesianIndex{2}}}}
        visited = fill(typemax(Int) - 1000, size(charmat))
        pq = PriorityQueue{State, Int}(Base.Order.Forward);
        
        winning_states = [State(start, 1, [start])]
        enqueue!(pq, winning_states[1] => 0)
        min_score = typemax(Int)
        while !isempty(pq)
            (cur, score) = dequeue_pair!(pq)
            score > min_score && continue

            if cur.pos == finish 
                if score < min_score
                    min_score = score
                    winning_states = [cur]
                elseif score == min_score
                    push!(winning_states, cur)
                end
                continue 
            end
            
            visited[cur.pos] + 1000 < score && continue
            visited[cur.pos] = score;

            explore_next!(pq, charmat, visited, cur, 0, score + 1)
            explore_next!(pq, charmat, visited, cur, +1, score + 1001)
            explore_next!(pq, charmat, visited, cur, -1, score + 1001)
        end

        winning_paths = Vector{CartesianIndex{2}}[]
        for winning_path in winning_states
            push!(winning_paths, winning_path.history)
        end
        
        return (min_score, winning_paths);
    end

    function show_map(charmat::Matrix{Char}, path::Vector{CartesianIndex{2}})
        map = copy(charmat);
        for pos in path
            map[pos] = 'O'
        end
        [println(join(row)) for row in eachrow(map)]
    end

    function solve_part_2(charmat::Matrix{Char}, winning_paths::Vector{Vector{CartesianIndex{2}}})
        visited     = fill(false, size(charmat))
        for winning_path in winning_paths
            for pos in winning_path
                visited[pos] = true
            end
        end

        return count(visited);
    end

    function solve(btest::Bool = false)::Tuple{Any, Any}
        lines       = @getinputs(btest);
        # lines2      = @getinputs(btest, "_2"); # Use if 2nd problem test case inputs are different
        (charmat, start, finish)      = parse_inputs(lines);

        (part1, winning_paths)  = solve_common(charmat, start, finish);
        part2                   = solve_part_2(charmat, winning_paths);

        return (part1, part2);
    end

    # @time (part1, part2) = solve(true); # Test
    @time (part1, part2) = solve();
    println("\nPart 1 answer: $(part1)");
    println("\nPart 2 answer: $(part2)\n");
end
# 72428
# 456