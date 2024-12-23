module AoC_2024_18
    using AdventOfCode
    using DataStructures
    using Parsers

    function convert(line::AbstractString)::CartesianIndex{2}
        idx = findfirst(',', line)
        return CartesianIndex(Parsers.parse(Int, line[idx+1:end]) + 1, Parsers.parse(Int, line[1:idx-1]) + 1)
    end

    parse_inputs(lines::Vector{String}) = convert.(lines)

    const directions::NTuple{4, CartesianIndex{2}} = CartesianIndex.(((0,1), (-1,0), (0,-1), (1,0)))

    function explore_next!(pq::PriorityQueue{CartesianIndex{2}, Int}, corrupted::Matrix{Bool}, next::CartesianIndex{2}, dist::Int)
        checkbounds(Bool, corrupted, next) || return
        corrupted[next] && return
        
        if haskey(pq, next) 
            pq[next] > dist || return
            pq[next] = dist
        else
            enqueue!(pq, next => dist)
        end
    end

    function find_shortest_path(corrupted_bytes::Vector{CartesianIndex{2}}, sz::Tuple{Int, Int}, nbytes::Int)
        corrupted = collect(falses(sz))
        visited = collect(falses(sz))
        corrupted[corrupted_bytes[1:nbytes]] .= true

        idx_start = CartesianIndex(1, 1)
        idx_end = CartesianIndex(sz)

        pq = PriorityQueue{CartesianIndex{2}, Int}(Base.Order.Forward)
        enqueue!(pq, idx_start => 0)
        while !isempty(pq)
            (pos, d) = dequeue_pair!(pq)
        
            visited[pos] && continue
            visited[pos] = true

            pos == idx_end && return d
        
            for dir in directions
                explore_next!(pq, corrupted, pos+dir, d+1)
            end
        end

        return -1;
    end

    get_nbytes(istest::Bool)::Int = istest ? 12 : 1024;
    get_grid_size(istest::Bool)::Tuple{Int, Int} = istest ? (7, 7) : (71, 71)

    function solve_part_1(corrupted_bytes::Vector{CartesianIndex{2}}, istest::Bool)::Int
        return find_shortest_path(corrupted_bytes, get_grid_size(istest), get_nbytes(istest))
    end

    function solve_part_2(corrupted_bytes::Vector{CartesianIndex{2}}, istest::Bool)::String
        low = get_nbytes(istest) + 1
        high = length(corrupted_bytes)
        sz = get_grid_size(istest)
        
        while low < high
            mid = (low + high) ÷ 2
            if find_shortest_path(corrupted_bytes, sz, mid) > -1
                low = mid + 1
            else
                high = mid
            end
        end

        blocking_byte = corrupted_bytes[low]
        return string(blocking_byte[2]-1) * "," * string(blocking_byte[1]-1)
    end

    function solve(btest::Bool = false)::Tuple{Any, Any}
        lines           = @getinputs(btest);
        corrupted_bytes = parse_inputs(lines);

        part1       = solve_part_1(corrupted_bytes, btest);
        part2       = solve_part_2(corrupted_bytes, btest);

        return (part1, part2);
    end

    # @time (part1, part2) = solve(true); # Test
    @time (part1, part2) = solve();
    println("\nPart 1 answer: $(part1)");
    println("\nPart 2 answer: $(part2)\n");
end