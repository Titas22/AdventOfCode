module AoC_2024_05
    using AdventOfCode;
    using Parsers;

    const deps = Dict{Int64, Set{Int64}}();

    function parse_inputs(lines::Vector{String})
        idx_empty = findfirst(x-> x == "", lines);
        
        str_deps = @view lines[1:idx_empty-1]
        for strdep in str_deps
            (v,k) = Parsers.parse.(Int64, (strdep[1:2], strdep[4:5]))
            haskey(deps, k) ? push!(deps[k], v) : push!(deps, k => Set(v));
        end

        str_updates = @view lines[idx_empty+1 : end]
        updates     = (x->Parsers.parse.(Int, x)).(split.(str_updates, ','))
        return updates;
    end
    
    is_page_ordered(x::Int, y::Int)::Bool = haskey(deps, x) && y in deps[x];

    solve_common(lists::Vector{Vector{Int}}) = issorted.(lists; lt=is_page_ordered, rev=true);

    get_middle_element(l::Vector{Int})::Int = l[(length(l)+1)÷2];

    solve_part_1(lists::AbstractVector{Vector{Int}})::Int = mapreduce(get_middle_element, +, lists);

    function solve_part_2!(bad_lists::AbstractVector{Vector{Int}})::Int
        sort!.(bad_lists; lt=is_page_ordered, alg=InsertionSort)  
        return solve_part_1(bad_lists);
    end

    function solve(btest::Bool = false)::Tuple{Any, Any}
        lines   = @getinputs(btest);
        updates = parse_inputs(lines);

        bOk     = solve_common(updates);
        
        part1   = solve_part_1(updates[bOk]);
        part2   = solve_part_2!(updates[.!bOk]);

        return (part1, part2);
    end

    # @time (part1, part2) = solve(true); # Test
    @time (part1, part2) = solve();
    println("\nPart 1 answer: $(part1)");
    println("\nPart 2 answer: $(part2)\n");
end