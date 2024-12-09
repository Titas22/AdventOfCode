module AoC_2024_07
    using AdventOfCode;
    using Parsers;

    struct Calibration
        output::Int
        inputs::Vector{Int}
    end
    
    function Calibration(line::String)::Calibration
        idx = findfirst(':', line)  # Find the delimiter
        output = Parsers.parse(Int, line[1:idx-1])  # Parse the output part
        inputs = parse_right(line[idx+2:end])  # Parse the inputs
        return Calibration(output, inputs)
    end
    
    const parse_opt = Parsers.Options(delim=' ', ignorerepeated=true)
    
    function parse_right(line::AbstractString)::Vector{Int64}
        io = IOBuffer(line)
        n = count(==(' '), line) + 1;
        vals::Vector{Int64} = Vector{Int64}(undef, n)
        for ii in eachindex(vals)
            vals[ii] = Parsers.parse(Int64, io, parse_opt)
        end
        return vals
    end
    
    parse_inputs(lines::Vector{String}) = Calibration.(lines)
    
    function get_order_of_magnitude(b::Int)::Int
        b < 10 && return 10;
        b < 100 && return 100;
        b < 1000 && return 1000;
        return 10^(floor(Int, log10(b)) + 1); # Backup
    end

    function check_calibration(current_total::Int, idx::Int, inputs::Vector{Int}, ispart2::Bool)::Bool
        if idx == 1
            return current_total == inputs[1]
        else
            @inbounds current_num = inputs[idx]
    
            # Concatenate
            if ispart2
                divisor = get_order_of_magnitude(current_num)
                new_total, remainder = divrem(current_total, divisor)
                remainder == current_num && new_total > 0 && check_calibration(new_total, idx - 1, inputs, ispart2) && return true
            end
    
            # Divide
            new_total, remainder = divrem(current_total, current_num)
            remainder == 0 && new_total > 0 && check_calibration(new_total, idx - 1, inputs, ispart2) && return true
    
            # Subtract
            new_total = current_total - current_num
            new_total > 0 && check_calibration(new_total, idx - 1, inputs, ispart2) && return true
    
            return false
        end
    end
    
    function solve_common(calibrations, ispart2::Bool)::Int
        tot = 0
        for cb in calibrations
            check_calibration(cb.output, length(cb.inputs), cb.inputs, ispart2) || continue
            tot += cb.output
        end
        return tot
    end

    solve_part_1(cals) = solve_common(cals, false);
    solve_part_2(cals) = solve_common(cals, true);

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