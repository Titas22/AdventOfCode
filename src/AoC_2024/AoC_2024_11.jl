module AoC_2024_11
    using AdventOfCode;
    using Parsers;

    parse_inputs(lines::Vector{String})::Vector{Int} = Parsers.parse.(Int, collect(split.(lines[1])))

    function insert_count!(stonecounts::Dict{Int, Int}, stone::Int, count_to_add::Int)
        if haskey(stonecounts, stone)
            stonecounts[stone] += count_to_add
        else
            stonecounts[stone] = count_to_add
        end
    end
    
    function blink!(newcounts::Dict{Int, Int}, stonecounts::Dict{Int, Int})
        empty!(newcounts)

        for (stone, counts) in stonecounts
            if stone == 0 
                insert_count!(newcounts, 1, counts);
            else 
                ndig = number_of_digits(stone)
                if ndig % 2 == 0
                    power = 10^(ndig ÷ 2)
                    insert_count!(newcounts, stone ÷ power, counts);
                    insert_count!(newcounts, mod(stone, power), counts);
                else
                    insert_count!(newcounts, stone*2024, counts);
                end
            end
        end
    end

    function solve_common(stones::Vector{Int})::Tuple{Int, Int}
        stonecounts = Dict{Int, Int}([(x, 1) for x in stones])
        newcounts = Dict{Int, Int}()
        
        part1 = 0
        for ii = 1 : 75
            if mod(ii, 2) == 1
                blink!(newcounts, stonecounts)
            else
                blink!(stonecounts, newcounts)
            end
            if ii == 25
                part1 = sum(values(newcounts));
            end 
        end
        
        part2 = sum(values(newcounts));

        return (part1, part2)
    end

    function solve(btest::Bool = false)::Tuple{Any, Any}
        lines       = @getinputs(btest);
        # lines2      = @getinputs(btest, "_2"); # Use if 2nd problem test case inputs are different
        stones      = parse_inputs(lines);

        (part1, part2) = solve_common(stones);

        return (part1, part2);
    end

    # @time (part1, part2) = solve(true); # Test
    @time (part1, part2) = solve();
    println("\nPart 1 answer: $(part1)");
    println("\nPart 2 answer: $(part2)\n");
end