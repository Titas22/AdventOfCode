module AoC_2023_12
    using AdventOfCode;
    const AoC = AdventOfCode;

    function parse_line(line::AbstractString)::Tuple{AbstractString, Vector{Int}}
        (str, num) = split(line);
        counts = parse.(Int, split(num, ','))
        return (str, counts)
    end
    parse_inputs(lines::Vector{String}) = parse_line.(lines);
    
    storage::Dict{UInt64, Int} = Dict{UInt64, Int}();
    function reset_storage()
        AoC_2023_12.storage = Dict{UInt64, Int}();
    end

    function count_arrangements(str::AbstractString, counts::AbstractArray)::Int
        isempty(counts) && return '#' in str ? 0 : 1;
        length(str) - sum(counts) - size(counts,1) + 1 >= 0 || return 0; 
        str[1] == '.' && return count_arrangements(@view(str[2:end]), counts);

        h = hash(str) + hash(counts);
        haskey(storage, h) && return storage[h];

        combs = str[1] == '?' ? count_arrangements(@view(str[2:end]), counts) : 0;
        n = counts[1];
        while '.' ∉ @view(str[1:n])
            length(str) == n && return 1;
            str[n+1] != '#' || break;
            combs += count_arrangements(@view(str[n+2 : end]), counts[2:end]);
            break;
        end
        
        storage[h] = combs;

        return combs;
    end

    function solve_part_1(inputs::Vector{Tuple{SubString{String}, Vector{Int}}})
        total = 0
        for (s, c) in inputs
            total += count_arrangements(s, c)
        end
        return total;
    end

    function solve_part_2(inputs::Vector{Tuple{SubString{String}, Vector{Int}}})
        total = 0
        for (s, c) in inputs
            c2 = repeat(c, 5);
            str = repeat(s*'?', 5)[1:end-1];
            n = count_arrangements(str, c2)
            total += n;
        end
        return total;
    end

    function solve(btest::Bool = false)::Tuple{Any, Any};
        lines       = @getinputs(btest);
        (inputs)    = parse_inputs(lines);

        reset_storage(); # to make benchmarks not give fake results
        part1       = solve_part_1(inputs);
        part2       = solve_part_2(inputs);

        return (part1, part2);
    end

    # @time (part1, part2) = solve(true); # Test
    @time (part1, part2) = solve();
    println("\nPart 1 answer: $(part1)");
    println("\nPart 2 answer: $(part2)\n");
end
