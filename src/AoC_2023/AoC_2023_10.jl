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
        'F' => [(1, 0), (0, 1)]);
    
    get_next_step(step_options::Vector{Tuple{Int, Int}}, previous_step::Tuple{Int, Int})::Tuple{Int, Int} = step_options[ (0 .- previous_step) == step_options[1] ? 2 : 1 ]
    
    function solve_common(tiles, current)::Tuple{Int, Int}        
        step = start_dir = get_start_dir(tiles, current);
        next = current + step
        dist = area = 0;
        while true
            dist += 1;
            area += current[1]*next[2] - next[1]*current[2]; # Shoelace Algorithm

            next_tile = tiles[next];
            next_tile == 'S' && break
    
            step    = get_next_step(connections[next_tile], step);
            current = next;    
            next    = current + step;
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
end