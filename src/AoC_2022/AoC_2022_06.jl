module AoC_2022_06
    using AdventOfCode;
    using DataStructures 

    function findMarker(line::String, n::Integer)
        cbuf = CircularBuffer{Char}(n);
        append!(cbuf, collect(line[1:n-1]));
    
        for ii in n : length(line)
            push!(cbuf, line[ii]);
            if length(unique(cbuf)) == n
                return ii;
                break;
            end
        end
    
    end

    function solve(bTestCase::Bool = false)::Tuple{Any, Any};
        lines       = @getInputs(bTestCase);

        part1       = findMarker.(lines, 4)[1];
        part2       = findMarker.(lines, 14)[1];

        return (part1, part2);
    end

    # @time (part1, part2) = solve(true); # Test
    # @time (part1, part2) = solve();
    # println("\nPart 1 answer: $(part1)");
    # println("Part 2 answer: $(part2)");
end