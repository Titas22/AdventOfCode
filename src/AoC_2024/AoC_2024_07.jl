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
    
    numcat(a::Int, b::Int)::Int = a * 10^(floor(Int, log10(b)) + 1) + b;

    function try_operators(operators, target, num, inputs::AbstractArray{Int})::Bool
        if length(inputs) == 1
            for op in operators
                op(num, inputs[1]) == target && return true
            end
        else
            for op in operators
                new_num = op(num, inputs[1])
                new_num > target && continue
                try_operators(operators, target, new_num, @view inputs[2:end]) && return true;
            end
        end
        return false;
    end
    
    function solve_common(calibrations, operators)
        tot = 0
        for cb in calibrations
            try_operators(operators, cb.output, cb.inputs[1], @view cb.inputs[2:end]) || continue
            tot += cb.output
        end
        return tot;
    end

    solve_part_1(cals) = solve_common(cals, (*, +));
    solve_part_2(cals) = solve_common(cals, (*, +, numcat));

    function solve(btest::Bool = false)::Tuple{Any, Any}
        lines   = @getinputs(btest);
        cals    = parse_inputs(lines);
        
        part1   = solve_part_1(cals);
        part2   = solve_part_2(cals);

        return (part1, part2);
    end

    # @time (part1, part2) = solve(true); # Test
    @time (part1, part2) = solve();
    println("\nPart 1 answer: $(part1)");
    println("\nPart 2 answer: $(part2)\n");
end