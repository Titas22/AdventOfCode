module AoC_2024_10
    using AdventOfCode;
    using DataStructures;

    parse_inputs(lines::Vector{String})::Matrix{Int} = lines2charmat(lines) .- '0';
    
    const directions::Vector{CartesianIndex{2}} = CartesianIndex.([(-1,0), (1,0), (0,-1), (0,1)]);

    function solve_common(heights::Matrix{Int})::Tuple{Int, Int}
        scores1 = scores2 = 0;

        for start_point in findall(x->x==0, heights)
            searchList = Queue{Tuple{CartesianIndex{2}, Int}}();
            enqueue!(searchList, (start_point, 0));
        
            peaks = CartesianIndex{2}[];
        
            while !isempty(searchList)
                (pos, height)          = dequeue!(searchList);
                if height == 9
                    push!(peaks, pos)
                    continue;
                end
                
                for dir in directions
                    next = pos + dir;
                    checkbounds(Bool, heights, next) || continue;
        
                    heights[next] - height == 1 || continue;
        
                    enqueue!(searchList, (next, heights[next]));
                end
            end
            
            scores1 += length(unique(peaks));
            scores2 += length(peaks);
        end

        return (scores1, scores2);
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