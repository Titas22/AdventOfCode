module AoC_2023_19
    using AdventOfCode;
    using DataStructures;
    const AoC = AdventOfCode;
    import Base.length

    struct Part
        x::Int
        m::Int
        a::Int
        s::Int
    end
    struct RangePart
        x::UnitRange{Int}
        m::UnitRange{Int}
        a::UnitRange{Int}
        s::UnitRange{Int}
    end

    length(p::RangePart)::Int = length(p.x) * length(p.m) * length(p.a) * length(p.s);
    
    function RangePart(p::RangePart, var::Symbol, rng::UnitRange)::RangePart
        var == :x && return RangePart(rng, p.m, p.a, p.s);
        var == :m && return RangePart(p.x, rng, p.a, p.s);
        var == :a && return RangePart(p.x, p.m, rng, p.s);
        return RangePart(p.x, p.m, p.a, rng);
    end

    function Part(line::AbstractString)
        args = split(line, ',')
        x = parse(Int, args[1][4:end])
        m = parse(Int, args[2][3:end])
        a = parse(Int, args[3][3:end])
        s = parse(Int, args[4][3:end-1])
        return Part(x, m, a, s);
    end

    struct Condition
        var::Symbol
        out::Symbol
        lim::Tuple{Int, Int}
    end

    struct Workflow
        conditions::Vector{Condition}
    end

    function parse_workflow!(w::Dict{Symbol, Workflow}, line::AbstractString)
        pw = split(line, r"[{=:,}]")
        wf = Workflow(Condition[]);
    
        for ii in (firstindex(pw)+1 : 2 : lastindex(pw)-3)
            cond = pw[ii]
            var = Symbol(cond[1])
            out = Symbol(pw[ii+1])
            lim = parse(Int, cond[3:end])
            if cond[2] == '<'
                lim = (typemin(Int), lim);
            else #if cond[2] == '>'
                lim = (lim, typemax(Int))
            end
            push!(wf.conditions, Condition(var, out, lim))
        end
    
        push!(wf.conditions, Condition(:x, Symbol(pw[end-1]), (typemin(Int), typemax(Int))))
        
        workflow = Symbol(pw[1])
        w[workflow] = wf;
    end

    function parse_inputs(lines::Vector{String})::Tuple
        idx_empty = findfirst(isempty.(lines));#

        workflows = Dict{Symbol, Workflow}();
        for ii in firstindex(lines) : idx_empty-1
            parse_workflow!(workflows, lines[ii])
        end
        
        parts = Part[];
        for ii in idx_empty+1 : lastindex(lines)
            push!(parts, Part(lines[ii]))
        end

        return (workflows, parts)
    end

    function process_part(workflows::Dict{Symbol, Workflow}, p::Part)::Bool
        wf = :in;
        while true
            wf = get_output(workflows[wf], p)
            if wf == :A
                return true;
            elseif wf == :R
                return false;
            end
        end
    end

    function get_output(wf::Workflow, p::Part)::Symbol
        for cond in wf.conditions
            if check_condition(cond, p)
                return cond.out
            end
        end
    end

    check_condition(cond::Condition, p::Part)::Bool = cond.lim[1] < getproperty(p, cond.var) < cond.lim[2];

    function solve_part_1(workflows, parts)
        sum = 0;
        for part in parts
            process_part(workflows, part) || continue;
            sum += part.x + part.m + part.a + part.s;
        end
        return sum;
    end

    function solve_part_2(workflows)
        rpc = Queue{Tuple{RangePart, Workflow}}();
        accepted = RangePart[];
        enqueue!(rpc, (RangePart(1:4000, 1:4000, 1:4000, 1:4000), workflows[:in]));

        while !isempty(rpc)
            (p, wf) = dequeue!(rpc);
            for cond in wf.conditions
                rng = getproperty(p, cond.var)
                (from, to) = cond.lim
                
                from = max(cond.lim[1]+1, rng[1]);
                to = min(cond.lim[2]-1, rng[end]);
                rng_passed = from:to;

                if !isempty(rng_passed) 
                    passed_part = RangePart(p, cond.var, from:to);
                    if cond.out == :A
                        push!(accepted, passed_part);
                    elseif cond.out != :R
                        enqueue!(rpc, (passed_part, workflows[cond.out]))
                    end
                end

                other = rng[1] : from-1
                if isempty(other)
                    other = to+1 : rng[end]
                    isempty(other) && break;
                end
                p = RangePart(p, cond.var, other);
            end
        end

        return sum(length.(accepted));
    end

    function solve(btest::Bool = false)::Tuple{Any, Any};
        lines               = @getinputs(btest);
        (workflows, parts)  = parse_inputs(lines);
        
        part1       = solve_part_1(workflows, parts);
        part2       = solve_part_2(workflows);

        return (part1, part2);
    end

    # @time (part1, part2) = solve(true); # Test
    @time (part1, part2) = solve();
    println("\nPart 1 answer: $(part1)");
    println("\nPart 2 answer: $(part2)\n");
end