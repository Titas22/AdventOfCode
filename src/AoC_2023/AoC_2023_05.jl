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
        return Map(src, src.+n.-1, dst, n)
    end

    function parse_inputs(lines::Vector{String})::Tuple{Vector{Map}, Vector{Int}}
        idxEmpty = findall(isempty.(lines));
        
        seed_numbers = parse.(Int, split(lines[1])[2:end])
        
        maps = Map[]
        sizehint!(maps, length(idxEmpty))
        
        for (from, to) in zip(idxEmpty, [idxEmpty[2:end]; [length(lines)+1]])
            mat = parse.(Int, reduce(hcat, split.(lines[(from+2):(to-1)])));
            mat = mat[:, sortperm(mat[2,:])];
            push!(maps, Map(mat[2,:], mat[1,:], mat[3, :]))
        end

        return (maps, seed_numbers);
    end

    Base.:+(rng::UnitRange{Int}, offset::Int)::UnitRange{Int} = (rng[1]+offset) : (rng[end]+offset);
    map_src_to_dst(rng::UnitRange{Int}, src::Int, dst::Int)::UnitRange{Int} = rng + (dst - src);

    function map_range(srng::UnitRange{Int}, m::AoC_2023_05.Map)::Vector{UnitRange{Int}}
        drng = UnitRange{Int}[]
        for idx in eachindex(m.src)
            from = m.src[idx];
            to   = m.srcend[idx];

            nomap = srng[1] : min(srng[end], from-1);
            remap = max(srng[1], from) : min(to, srng[end]);
            srng  = max(to+1, srng[1]) : srng[end];

            isempty(nomap) || push!(drng, nomap) 
            isempty(remap) || push!(drng, map_src_to_dst(remap, from, m.dst[idx]))
            isempty(srng) && break;
        end
        isempty(srng) || push!(drng, srng)
        return drng
    end

    function map_ranges(orgrng::Vector{UnitRange{Int}}, maps::Vector{AoC_2023_05.Map})
        newrng = UnitRange{Int}[];
        for m in maps
            newrng = UnitRange{Int}[];
            for s in orgrng
                append!(newrng, map_range(s, m))
            end
            orgrng = newrng;
        end
        return newrng
    end

    solve_minimum_location(maps, seed_ranges)::Int = minimum((x->x[1]).(map_ranges(seed_ranges, maps)));

    get_seed_ranges(nums::Vector{Int})  = (x->(x[1]:(x[1]+x[2]))).(Iterators.partition(nums, 2))
    solve_part_1(maps, seed_numbers)    = solve_minimum_location(maps, (x->x:x).(seed_numbers))
    solve_part_2(maps, seed_numbers)    = solve_minimum_location(maps, get_seed_ranges(seed_numbers))

    function solve(btest::Bool = false)::Tuple{Any, Any};
        lines       = @getinputs(btest);
        (maps, seed_numbers)      = parse_inputs(lines);

        part1 = solve_part_1(maps, seed_numbers);
        part2 = solve_part_2(maps, seed_numbers);

        return (part1, part2);
    end

    # @time (part1, part2) = solve(true); # Test
    @time (part1, part2) = solve();
    println("\nPart 1 answer: $(part1)");
    println("\nPart 2 answer: $(part2)\n");
end