module AoC_2024_07
    using AdventOfCode;
    using Parsers;

    struct Calibration
        output::Int
        inputs::Vector{Int}
    end

    function Calibration(line::String)::Calibration
        idx = findfirst(x->x==':', line)
        return Calibration(Parsers.parse(Int64, line[1:idx-1]), parse_right(line[idx+2:end]))
    end
    
    const parse_opt = Parsers.Options(delim=' ', ignorerepeated=true)
    function parse_right(line::AbstractString)::Vector{Int64}
        io = IOBuffer(line)
        vals = Int[]
        n = count(==( ' '), line) + 1
        sizehint!(vals, n)
        while !eof(io)
            push!(vals, Parsers.parse(Int64, io, parse_opt))
        end
        return vals
    end

    function parse_inputs(lines::Vector{String})
        calibrations = Calibration.(lines)
        return calibrations;
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
        println(inputs)
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

calibrations = AoC_2024_07.parse_inputs(lines)

numcat(a::Int, b::Int)::Int = a * 10^(floor(Int, log10(b)) + 1) + b;

function try_operators(operators, target, num, inputs::AbstractArray{Int})::Bool
    if length(inputs) == 1
        for op in operators
            op(num, inputs[1]) == target && return true
        end
    else
        for op in operators
            try_operators(operators, target, op(num, inputs[1]), @view inputs[2:end]) && return true;
        end
    end
    return false;
end

tot = 0
for cb in calibrations
    try_operators((+, *), cb.output, cb.inputs[1], @view cb.inputs[2:end]) || continue
    global tot
    tot += cb.output
end

println(tot)

tot = 0
for cb in calibrations
    try_operators((+, *, numcat), cb.output, cb.inputs[1], @view cb.inputs[2:end]) || continue
    global tot
    tot += cb.output
end

println(tot)