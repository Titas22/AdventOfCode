module AoC_2023_19
    using AdventOfCode;
    const AoC = AdventOfCode;

    struct Part
        x::Int
        m::Int
        a::Int
        s::Int
    end
    
    function Part(line::AbstractString)
        args = split(line, ',')
        x = parse(Int, args[1][4:end])
        m = parse(Int, args[2][3:end])
        a = parse(Int, args[3][3:end])
        s = parse(Int, args[4][3:end-1])
        return Part(x, m, a, s);
    end

    function parse_workflow!(w::Dict{Symbol, Vector{<:Tuple}}, line::AbstractString)
        pw = split(line, r"[{=:,}]")
        conditions = Tuple{Any, Symbol, Symbol}[]
    
        for ii in (firstindex(pw)+1 : 2 : lastindex(pw)-3)
            cond = pw[ii]
            var = Symbol(cond[1])
            lim = parse(Int, cond[3:end])
            out = Symbol(pw[ii+1])
    
            if cond[2] == '<'
                push!(conditions, (x -> x < lim, var, out))
            elseif cond[2] == '>'
                push!(conditions, (x -> x > lim, var, out))
            else
                println("wut")
            end
        end
    
        workflow = Symbol(pw[1])
        push!(conditions, (x -> true, :x, Symbol(pw[end-1])))
    
        w[workflow] = conditions;
    end

    function parse_inputs(lines::Vector{String})::Tuple
        workflows = Dict{Symbol, Vector{<:Tuple}}();
        
        idx_empty = findfirst(isempty.(lines));
        for ii in firstindex(lines) : idx_empty-1
            parse_workflow!(workflows, lines[ii])
        end
        
        parts = Part[];
        for ii in idx_empty+1 : lastindex(lines)
            push!(parts, Part(lines[ii]))
        end

        return (workflows, parts)
    end

    function solve_part_1(workflows, parts)
        sum = 0;
        for part in parts
            wf = :in;
            accepted = false;
            while true
                workflow = workflows[wf]
                wf = Symbol("");
                for cond in workflow
                    if cond[1](getproperty(part, cond[2]))
                        wf = cond[3]
                        break;
                    end
                end
                if wf == :A
                    accepted = true;
                    break;
                elseif wf == :R
                    break;
                end
            end
            accepted || continue;
            sum += part.x + part.m + part.a + part.s;
        end
        return sum;
    end

    function solve_part_2(inputs)

        return nothing;
    end

    function solve(btest::Bool = false)::Tuple{Any, Any};
        lines               = @getinputs(btest);
        (workflows, parts)  = parse_inputs(lines);
        
        part1       = solve_part_1(workflows, parts);
        part2       = solve_part_2(workflows);

        return (part1, part2);
    end

    @time (part1, part2) = solve(true); # Test
    # @time (part1, part2) = solve();
    println("\nPart 1 answer: $(part1)");
    println("\nPart 2 answer: $(part2)\n");
end