module AoC_2024_10
    using AdventOfCode;

    function parse_inputs(lines::Vector{String})

        return lines;
    end
    function solve_common(inputs)

        return inputs;
    end

    function solve_part_1(inputs)

        return nothing;
    end

    function solve_part_2(inputs)

        return nothing;
    end

    function solve(btest::Bool = false)::Tuple{Any, Any}
        lines       = @getinputs(btest);
        # lines2      = @getinputs(btest, "_2"); # Use if 2nd problem test case inputs are different
        inputs      = parse_inputs(lines);

        solution    = solve_common(inputs);
        part1       = solve_part_1(solution);
        part2       = solve_part_2(solution);

        return (part1, part2);
    end

    @time (part1, part2) = solve(true); # Test
    # @time (part1, part2) = solve();
    println("\nPart 1 answer: $(part1)");
    println("\nPart 2 answer: $(part2)\n");
end
lines = @getinputs(false)

heights = lines2charmat(lines) .- '0';

start_points = findall(x->x==0, heights)

directions = CartesianIndex.([(-1,0), (1,0), (0,-1), (0,1)]);

scores = 0
for start_point in start_points
    searchList          = Queue{Tuple{CartesianIndex{2}, Int}}();
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
    global scores
    scores += length(unique(peaks));
end
scores