module AoC_2024_05
    using AdventOfCode;
    using Parsers;

    function parse_inputs(lines::Vector{String})

        idx_empty = findfirst(x-> x == "", lines);
        
        str_deps = @view lines[1:idx_empty-1]
        
        str_lists = @view lines[idx_empty+1 : end]
        lists = (x->parse.(Int, x)).(split.(str_lists, ','))
        
        deps = Dict();
        for strdep in str_deps
            idx_sep = findfirst('|', strdep)
            v = Parsers.parse(Int64, strdep[1 : idx_sep-1])
            k = Parsers.parse(Int64, strdep[idx_sep+1 : end])
            if haskey(deps, k)
                push!(deps[k], v)
            else
                deps[k] = Set(v);
            end
        end

        return (deps, lists);
    end
    function solve_common(deps, lists)
        bOk = falses(length(lists))
        for (jj, l) in pairs(lists)
            bOk[jj] = true
            for ii in eachindex(l)
                if haskey(deps, l[ii]) && findfirst(x -> x in deps[l[ii]], l[ii+1:end]) !== nothing
                    bOk[jj] = false
                    break;
                end
            end
            bOk[jj] || continue;
        end

        return bOk;
    end

    function solve_part_1(lists)
        tot = 0
        for l in lists
            tot += l[length(l)÷2 + 1]
        end
        return tot;
    end

    function solve_part_2(bad_lists, deps)
        for l in bad_lists
            sort!(l; lt=(x, y) -> haskey(deps, x) && y in deps[x])        
        end
        return solve_part_1(bad_lists);
    end

    function solve(btest::Bool = false)::Tuple{Any, Any}
        lines       = @getinputs(btest);
        (deps, lists)      = parse_inputs(lines);

        bOk         = solve_common(deps, lists);
        part1       = solve_part_1(@view lists[bOk]);
        part2       = solve_part_2(lists[.!bOk], deps);

        return (part1, part2);
    end

    # @time (part1, part2) = solve(true); # Test
    @time (part1, part2) = solve();
    println("\nPart 1 answer: $(part1)");
    println("\nPart 2 answer: $(part2)\n");
end