module AoC_2023_05
    using AdventOfCode;
    const AoC = AdventOfCode;

    struct Map
        src::Vector{Int}
        srcend::Vector{Int}
        dst::Vector{Int}
        n::Vector{Int}
    end
    function Map(src, dst, n)::Map
        Map(src, src.+n, dst, n)
    end

    function parse_inputs(lines::Vector{String})::Tuple{Vector{Map}, Vector{Int}}
        idxEmpty = findall(isempty.(lines));
        
        seed_numbers = parse.(Int, split(lines[1])[2:end])
        
        maps = Map[]
        sizehint!(maps, length(idxEmpty))
        
        for (from, to) in zip(idxEmpty, [idxEmpty[2:end]; [length(lines)+1]])
            mat = parse.(Int, reduce(hcat, split.(sort(lines[(from+2):(to-1)]))));
            mat = parse.(Int, reduce(hcat, split.(sort(lines[(from+2):(to-1)]))));
            mat = parse.(Int, reduce(hcat, split.(lines[(from+2):(to-1)])));
            dst = mat[1,:];
            src = mat[2,:];
            n = mat[3, :];
            push!(maps, Map(src, dst, n))
        end


        return (maps, seed_numbers);
    end

    function map_numbers(maps::AbstractVector, nums::Vector{Int})::Vector{Int}
        nums = copy(nums);
        for idx in eachindex(nums)
            nums[idx] = map_number(maps, nums[idx]);
        end
        return nums;
    end
    

    function map_number(maps::AbstractVector, num::Int)::Int
        for m in maps
            num = map_number(m, num);
        end
        return num;
    
        # seed_number = map_number(maps[1], seed_number);
        # return length(maps) > 1 ? map_number(maps[2:end], seed_number) : seed_number;
    end
    

    function map_number(m, seed_number::Int)::Int    
        b_in_range = m.src .<= seed_number .< m.srcend;
        
        if any(b_in_range)
            idx = findfirst(b_in_range)
            seed_number = seed_number - m.src[idx] + m.dst[idx]
        end
    
        return seed_number;
    end

    solve_part_1(maps, seed_numbers) = minimum(map_numbers(maps, seed_numbers));

    function solve_part_2(maps, seed_numbers)

        return nothing;
    end

    function solve(btest::Bool = false)::Tuple{Any, Any};
        lines       = @getinputs(btest);
        # lines2      = @getinputs(btest, "_2"); # Use if 2nd problem test case inputs are different
        (maps, seed_numbers)      = parse_inputs(lines);

        # solution    = solve_common(inputs);
        part1       = solve_part_1(maps, seed_numbers);
        part2       = 0; #solve_part_2(solution);

        return (part1, part2);
    end

    # @time (part1, part2) = solve(true); # Test
    @time (part1, part2) = solve();
    println("\nPart 1 answer: $(part1)");
    println("\nPart 2 answer: $(part2)\n");
end