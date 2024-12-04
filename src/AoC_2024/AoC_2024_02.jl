module AoC_2024_02
    using AdventOfCode;
    using Parsers;
    
    function parse_line(line::AbstractString, opt::Parsers.Options)::Vector{Int}
        io = IOBuffer(line)
        vals = Int[]
        n = count(==( ' '), line) + 1
        sizehint!(vals, n)
        while !eof(io)
            push!(vals, Parsers.parse(Int64, io, opt))
        end
        return vals
    end

    function parse_inputs(lines::Vector{String})::Vector{Vector{Int}}
        inputs  = Vector{Int}[];
        sizehint!(inputs, length(lines));

        opt = Parsers.Options(delim=' ', ignorerepeated=true)
        for line in lines
            parsed_line = parse_line(line, opt)
            push!(inputs, parsed_line)
        end

        return inputs
    end

    function check_pair(a::Int, b::Int)::Tuple{Bool, Int}
        dx = a-b
        (dx == 0 || abs(dx) > 3) && return (false, 0)
        return (true, sign(dx))
    end

    function is_safe_report(v::Vector{Int64})
        length(v) > 1 || return true # 

        (b, s) = check_pair(v[2], v[1])
        b || return false
        for ii in 3 : length(v)
            (b, s2) = check_pair(v[ii], v[ii-1])
            b || return false
            s == s2 || return false
        end
        return true
    end

    function solve_part_2(inputs, fully_safe)
        tot = solve_part_1(fully_safe)
        to_check = @view inputs[.!fully_safe];
        for v in to_check
            for ii in eachindex(v)
                w = v[1:end .!= ii]

                is_safe_report(w) || continue
                
                tot += 1
                break
            end
        end
        return tot
    end

    solve_part_1(fully_safe) = count(fully_safe);

    function solve(btest::Bool = false)::Tuple{Any, Any}
        lines       = @getinputs(btest);
        inputs      = parse_inputs(lines);

        fully_safe  = is_safe_report.(inputs)

        part1       = solve_part_1(fully_safe);
        part2       = solve_part_2(inputs, fully_safe);

        return (part1, part2);
    end

    @time (part1, part2) = solve(false); # Test
    # @time (part1, part2) = solve();
    println("\nPart 1 answer: $(part1)");
    println("\nPart 2 answer: $(part2)\n");
end