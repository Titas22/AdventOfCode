module AoC_2024_16
    using AdventOfCode;
    using DataStructures;

    const directions::NTuple{4, CartesianIndex{2}} = CartesianIndex.(((0,1), (-1,0), (0,-1), (1,0)))

    struct State
        pos::CartesianIndex{2}
        idx_dir::Int
        dir::CartesianIndex{2}
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

    function explore_next!(pq::PriorityQueue{State, Int}, charmat::Matrix{Char}, visited::Matrix{Int}, pos::CartesianIndex{2}, idx_dir::Int, score::Int)
        if idx_dir == 0
            idx_dir = 4
        elseif idx_dir == 5
            idx_dir = 1;
        end
        
        next = pos + directions[idx_dir]
        checkbounds(Bool, charmat, next) || return
        charmat[next] == '.' || return
        # if visited[next]

        # else

        # end
        next_state = State(next, idx_dir, directions[idx_dir])
        if haskey(pq, next_state) 
            pq[next_state] < score && return
            pq[next_state] = score
        else
            enqueue!(pq, next_state => score)
        end
    end

    function solve_part_1(charmat::Matrix{Char}, start::CartesianIndex{2}, finish::CartesianIndex{2})
        # visited = fill(false, size(charmat))
        visited = fill(typemax(Int) - 1000, size(charmat))
        # display(visited)
        # pq = PriorityQueue{State, Int}(Base.Order.Reverse);
        pq = PriorityQueue{State, Int}(Base.Order.Forward);
        
        enqueue!(pq, State(start, 1, directions[1]) => 0)
        min_score = typemax(Int)
        while !isempty(pq)
            (cur, score) = dequeue_pair!(pq)
            # println("Visiting " * string(cur.pos) * " at score " * string(score))
            # cur.pos == finish && return score
            score > min_score && continue
            if cur.pos == finish 
                if score < min_score
                    min_score = score
                end
                continue 
            end
            # display(visited)
            # visited[cur.pos] && continue;
            if visited[cur.pos] + 1000 <= score
                # println("Skipping")
                continue
            end
            
            visited[cur.pos] = score;

            explore_next!(pq, charmat, visited, cur.pos, cur.idx_dir, score + 1)
            explore_next!(pq, charmat, visited, cur.pos, cur.idx_dir+1, score + 1001)
            explore_next!(pq, charmat, visited, cur.pos, cur.idx_dir-1, score + 1001)
        end
        
        return min_score;
    end

    function solve_part_2(charmat::Matrix{Char}, start::CartesianIndex{2}, finish::CartesianIndex{2})

        return nothing;
    end

    function solve(btest::Bool = false)::Tuple{Any, Any}
        lines       = @getinputs(btest);
        # lines2      = @getinputs(btest, "_2"); # Use if 2nd problem test case inputs are different
        (charmat, start, finish)      = parse_inputs(lines);

        part1       = solve_part_1(charmat, start, finish);
        part2       = solve_part_2(charmat, start, finish);

        return (part1, part2);
    end

    # @time (part1, part2) = solve(true); # Test
    @time (part1, part2) = solve();
    println("\nPart 1 answer: $(part1)");
    println("\nPart 2 answer: $(part2)\n");
end
lines = @getinputs(true)

(charmat, start, finish)      = AoC_2024_16.parse_inputs(lines)

# 72428