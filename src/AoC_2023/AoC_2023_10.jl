module AoC_2023_10
    using AdventOfCode;

    import Base: +

    const AoC = AdventOfCode;
        
    +(idx::CartesianIndex{2}, dx::Tuple{Int, Int}) = CartesianIndex(idx[1]+dx[1], idx[2]+dx[2])

    function get_start_dir(tiles, start_index)::Tuple{Int, Int}
        (n, m) = size(tiles)
        for dir in [(-1,0), (1,0), (0,-1), (0,1)]
            next_index  = start_index + dir;
            (0 < next_index[1] <= n && 0 < next_index[2] <= m) || continue;
            next_tile   = tiles[start_index + dir];
            next_tile != '.' || continue;
            
            opposite    = 0 .- dir;
            connection  = connections[next_tile]
            connection[1] == opposite || connection[2] == opposite || continue;
    
            return dir;
        end
    end

    const connections = Dict(
        '|' => [(1, 0), (-1, 0)], 
        '-' => [(0, -1), (0, 1)], 
        'L' => [(-1, 0), (0, 1)], 
        'J' => [(-1, 0), (0, -1)], 
        '7' => [(1, 0), (0, -1)], 
        'F' => [(1, 0), (0, 1)], 
        '.' => []);
    
    function solve_common(tiles, current)::Tuple{Int, Int}
        
        start_dir = get_start_dir(tiles, current);
    
        step = start_dir;
        next = current + step
    
        dist = area = 0;
        while true #tiles[next] != 'S'
            dist += 1;
    
            area += current[1]*next[2] - next[1]*current[2]; # Shoelace Algorithm
    
            tiles[next] == 'S' && break
    
            step_options = connections[tiles[next]]
            opposite = (0 .- step)
            # opposite2 = (-step[1], -step[2])

            b = opposite == step_options[1];
            if b
                step = step_options[2]
            else
                step = step_options[1]
            end
    
            current = next;
            next = current + step;
        end

        return (dist/2, area/2);
    end

    function parse_inputs(lines)
        tiles = Char.(zeros(length(lines), length(lines[1])).+46)
        start_index = CartesianIndex(0, 0)
        for ii in axes(tiles, 1), jj in axes(tiles, 2)
            ch = lines[ii][jj]
            tiles[ii, jj] = ch
            ch == 'S' || continue;
            start_index = CartesianIndex(ii, jj)
        end
        return (tiles, start_index);
    end


    function solve(btest::Bool = false)::Tuple{Any, Any};
        lines       = @getinputs(btest);
        (tiles, start_index)    = parse_inputs(lines);

        (dist, area)    = solve_common(tiles, start_index);

        part1 = dist;
        part2 = abs(area) - dist + 1;

        return (part1, part2);
    end

    # @time (part1, part2) = solve(true); # Test
    @time (part1, part2) = solve();
    println("\nPart 1 answer: $(part1)");
    println("\nPart 2 answer: $(part2)\n");
    # Part 1 answer: 6838
    
    # Part 2 answer: 451
end
# lines = @getinputs(false)

# (tiles, start_index) = AoC_2023_10.parse_inputs(lines)



# function process_tiles(tiles, current, start_direction)
#     connections = Dict(
#         '|' => [(1, 0), (-1, 0)], 
#         '-' => [(0, -1), (0, 1)], 
#         'L' => [(-1, 0), (0, 1)], 
#         'J' => [(-1, 0), (0, -1)], 
#         '7' => [(1, 0), (0, -1)], 
#         'F' => [(1, 0), (0, 1)], 
#         '.' => [], 'S' => [start_direction] );

#     (n, m)  = size(tiles)
#     bprocessed      = falses(n, m);
#     distances       = zeros(Int, n, m) .* NaN;

#     searchList          = Queue{Tuple{CartesianIndex{2}, Int}}();
#     enqueue!(searchList, (current, 0));
    
#     # println("processing $current")
#     while !isempty(searchList)
#         (current, dist)     = dequeue!(searchList);
#         (bprocessed[current] || tiles[current] == '.') && continue;
        
#         distances[current]       = dist;
#         bprocessed[current]      = true;
#         for didx in connections[tiles[current]]
            
#             next = current + didx;
#             ((0 < next[1] <= n && 0 < next[2] <= m) && !bprocessed[next]) || continue
#             enqueue!(searchList, (next, dist+1));
#         end
#     end

#     return (distances, bprocessed);
# end

# (distances, bprocessed) = process_tiles(tiles, start_index, (0, -1))

