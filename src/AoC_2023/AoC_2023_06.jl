module AoC_2023_06
    using AdventOfCode;
    const AoC = AdventOfCode;

    const a = 1; # Acceleration
    
    struct Race
        time::Int
        record::Int
    end

    function number_of_winning_options(r::Race):Int
        sqD = sqrt(r.time^2 - 4*r.record / a);
        
        x1 = 0.5 * (r.time - sqD);
        x2 = 0.5 * (r.time + sqD);
        if mod(x1, 1) == 0
            x1 += 1
            x2 -= 1
        else
            x2 = floor(x2);
            x1 = ceil(x1);
        end

        return Int(x2 - x1 +1);
    end

    function concat_int(arr::Vector{Int})::Int
        result = 0
        for num in arr
            result = result * 10^floor(Int, log10(num) + 1) + num
        end
        return result
    end

    get_numbers(line::AbstractString)::Vector{Int} = parse.(Int, split(line)[2:end])

    function parse_inputs(lines::Vector{<:AbstractString})::Tuple{Vector{Race}, Race}        
        times   = get_numbers(lines[1]);
        records = get_numbers(lines[2]);

        races       = Race.(times, records)
        big_race    = Race(concat_int(times), concat_int(records));

        return (races, big_race);
    end

    solve_part_1(races::Vector{Race})::Int  = prod(number_of_winning_options.(races));
    solve_part_2(race::Race)::Int           = number_of_winning_options(race);

    function solve(btest::Bool = false)::Tuple{Any, Any};
        lines       = @getinputs(btest);

        (races, big_race)     = parse_inputs(lines);

        part1       = solve_part_1(races);
        part2       = solve_part_2(big_race);

        return (part1, part2);
    end

    # @time (part1, part2) = solve(true); # Test
    @time (part1, part2) = solve();
    println("\nPart 1 answer: $(part1)");
    println("\nPart 2 answer: $(part2)");
end