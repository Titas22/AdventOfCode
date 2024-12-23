module AoC_2024_18
    using AdventOfCode
    using DataStructures
    using Parsers

    function convert(line::AbstractString)::CartesianIndex{2}
        idx = findfirst(',', line)
        return CartesianIndex(Parsers.parse(Int, line[idx+1:end]) + 1, Parsers.parse(Int, line[1:idx-1]) + 1)
    end

    parse_inputs(lines::Vector{String}) = convert.(lines)
    # function parse_inputs(lines::Vector{String})::Vector{CartesianIndex{2}}
    #     corrupted_bytes = CartesianIndex{2}[]
    #     sizehint!(corrupted_bytes, length(lines))
    #     for line in lines
    #         push!(corrupted_bytes, convert(line))
    #     end
    #     return corrupted_bytes
    # end

    const directions::NTuple{4, CartesianIndex{2}} = CartesianIndex.(((0,1), (-1,0), (0,-1), (1,0)))

    function explore_next!(q::Vector{CartesianIndex{2}}, corrupted_or_visited, distances::Matrix{Int}, next::CartesianIndex{2}, dist::Int)
        checkbounds(Bool, corrupted_or_visited, next) || return
        corrupted_or_visited[next] && return
    
        push!(q, next)
        distances[next] = dist
        corrupted_or_visited[next] = true
    end

    function find_shortest_path(corrupted_bytes::Vector{CartesianIndex{2}}, sz::Tuple{Int, Int}, nbytes::Int)
        distances = zeros(Int, sz)
        corrupted_or_visited = falses(sz)
        return find_shortest_path!(distances, corrupted_or_visited, corrupted_bytes, sz, nbytes)
    end

    function find_shortest_path!(distances::Matrix{Int}, corrupted_or_visited, corrupted_bytes::Vector{CartesianIndex{2}}, sz::Tuple{Int, Int}, nbytes::Int)
        fill!(corrupted_or_visited, false)
        for ii in 1 : nbytes
            corrupted_or_visited[corrupted_bytes[ii]] = true
        end

        idx_start = CartesianIndex(1, 1)
        idx_end = CartesianIndex(sz)
        
        q = [idx_start]
        fill!(distances, 0)
        distances[idx_start] = 0

        while !isempty(q)
            pos = popfirst!(q)
            d = distances[pos]
            
            pos == idx_end && return d
            
            for dir in directions
                explore_next!(q, corrupted_or_visited, distances, pos + dir, d+1)
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
        distances = zeros(Int, sz)
        corrupted_or_visited = collect(falses(sz))
        while low < high
            mid = (low + high) ÷ 2
            if find_shortest_path!(distances, corrupted_or_visited, corrupted_bytes, sz, mid) > -1
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

    @assert(part1 == 318, "Part 1 is wrong")
    @assert(part2 == "56,29", "Part 2 is wrong")
end