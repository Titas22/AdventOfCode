module AoC_2024_02
    using AdventOfCode;
    const AoC = AdventOfCode;

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
lines = @getinputs(true)

inputs = (x->parse.(Int, x)).(split.(lines))

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
    println(b)



    return false
end
b = is_safe_report.(inputs)
count(b)

b = is_safe_report.(inputs, true)
count(b)