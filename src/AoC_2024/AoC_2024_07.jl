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
    
    const orders_of_magnitude = Dict{Int, Int}();
    function get_order_of_magnitude(b::Int)::Int
        if !haskey(orders_of_magnitude, b)
            p = 10^(floor(Int, log10(b)) + 1);
            orders_of_magnitude[b] = p;
        else
            p = orders_of_magnitude[b]
        end
        return p;
    end

    function check_calibration!(s::Vector{Tuple{Int, Int}}, cb::Calibration, ispart2::Bool)::Bool
        while !isempty(s)
            current_total, idx = pop!(s)
            if idx == 1
                # println(current_total)
                current_total == cb.inputs[1] && return true
            else
                current_num = cb.inputs[idx];
                # Conatenate
                if ispart2
                    divisor = get_order_of_magnitude(current_num)
                    # Check if current_total ends with current_num
                    if current_total % divisor == current_num
                        new_total = current_total ÷ divisor
                        new_total > 0 && push!(s, (new_total, idx - 1))
                    end
                end

                # Divide
                if current_total % current_num == 0
                    new_total = current_total / current_num
                    new_total > 0 && push!(s, (new_total, idx - 1))
                end

                # Subtract
                new_total = current_total - current_num
                new_total > 0 && push!(s, (new_total, idx - 1))
            end
        end
        return false;
    end
    
    function solve_common(calibrations, ispart2)
        tot = 0
        s::Vector{Tuple{Int, Int}} = [];
        for cb in calibrations
            empty!(s)
            push!(s,  (cb.output, length(cb.inputs)))
            check_calibration!(s, cb, ispart2) || continue
            tot += cb.output
        end
        return tot;
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