module AoC_2024_05
    using AdventOfCode;

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
lines = @getinputs(false)

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
deps

tot = 0
bOk = falses(length(lists))
for (jj, l) in pairs(lists)
    bOk[jj] = true
    for ii in eachindex(l)
        if haskey(deps, l[ii]) && findfirst(x -> x in deps[l[ii]], l[ii+1:end]) !== nothing
            # l[ii+1:end] deps[l[ii]] in 
            bOk[jj] = false

            # @printf("Current index %d: value %d requires %s\n", ii, l[ii], string(deps[l[ii]]))
            # println(l)
            # println(l[1:ii-1])
            break;
        end
    end
    bOk[jj] || continue;
    # println(l)
    # println(l[length(l)÷2 + 1])
end

tot = 0
for l in @view lists[bOk]
    global tot
    tot += l[length(l)÷2 + 1]
end

println(tot)

bad_lists = @view lists[.!bOk]

for l in bad_lists
    @printf("Pre-sort: %s\n", string(l))
    sort!(l; lt=(x, y) -> haskey(deps, x) && y in deps[x])
    @printf("Post-sort: %s\n", string(l))

end

tot = 0
for l in bad_lists
    global tot
    tot += l[length(l)÷2 + 1]
end

println(tot)