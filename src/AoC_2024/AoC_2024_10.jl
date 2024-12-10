module AoC_2024_10
    using AdventOfCode;
    using DataStructures;

    parse_inputs(lines::Vector{String})::Matrix{Int} = lines2charmat(lines) .- '0';
    
    const directions::Vector{CartesianIndex{2}} = CartesianIndex.([(-1,0), (1,0), (0,-1), (0,1)]);

    function solve_common(heights::Matrix{Int})::Tuple{Int, Int}
        n_unique_paths = n_peaks_reached = 0;
        searchList = Tuple{CartesianIndex{2}, Int}[];

        for start_point in findall(x->x==0, heights)
            push!(searchList, (start_point, 0));
            
            peaks = Set{CartesianIndex{2}}()
        
            while !isempty(searchList)
                (pos, height)          = popfirst!(searchList);
                if height == 9
                    push!(peaks, pos)
                    n_unique_paths += 1
                    continue;
                end
                
                for dir in directions
                    next = pos + dir;
                    checkbounds(Bool, heights, next) || continue;
        
                    heights[next] - height == 1 || continue;
        
                    push!(searchList, (next, heights[next]));
                end
            end
            n_peaks_reached += length(peaks);
        end

        return (n_peaks_reached, n_unique_paths);
    end

    function solve(btest::Bool = false)::Tuple{Any, Any}
        lines       = @getinputs(btest);
        heights     = parse_inputs(lines);

        (part1, part2) = solve_common(heights);

        return (part1, part2);
    end

    # @time (part1, part2) = solve(true); # Test
    @time (part1, part2) = solve();
    println("\nPart 1 answer: $(part1)");
    println("\nPart 2 answer: $(part2)\n");
end