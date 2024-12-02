module AoC_2024_02
    using AdventOfCode;
    const AoC = AdventOfCode;

    function parse_inputs(lines::Vector{String})
        return (x->parse.(Int, x)).(split.(lines));
    end

    function is_safe_report(v::Vector{Int64}, recurse::Bool = false)
        dv = diff(v)
        if dv[1] > 0
            b = dv .> 0 .&& dv .<= 3
        else
            b = dv .< 0 .&& dv .>= -3
        end
    
        ~all(b) || return true
        recurse || return false
        for ii in eachindex(v)
            ~is_safe_report(v[1:end .!= ii], false) || return true
        end
        return false
    end

    solve_part_1(inputs) = count(is_safe_report.(inputs));
    solve_part_2(inputs) = count(is_safe_report.(inputs, true));

    function solve(btest::Bool = false)::Tuple{Any, Any}
        lines       = @getinputs(btest);
        inputs      = parse_inputs(lines);

        part1       = solve_part_1(inputs);
        part2       = solve_part_2(inputs);

        return (part1, part2);
    end

    @time (part1, part2) = solve(false); # Test
    # @time (part1, part2) = solve();
    println("\nPart 1 answer: $(part1)");
    println("\nPart 2 answer: $(part2)\n");
end