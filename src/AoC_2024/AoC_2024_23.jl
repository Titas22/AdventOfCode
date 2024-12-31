module AoC_2024_23
    using AdventOfCode

    const Links = Dict{String, Set{String}}

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

function add_link!(d::Dict{String, Set{String}}, a::String, b::String)
    if !haskey(d, a)
        d[a] = Set{String}()
    end
    push!(d[a], b)
end
function add_links!(d::Dict{String, Set{String}}, a::String, b::String)
    add_link!(d, a, b)
    add_link!(d, b, a)
end


links = Dict{String, Set{String}}()

for line in lines
    add_links!(links, line[1:2], line[4:5])
end

function add_trios!(all_trios::Set{Set{String}}, links::AoC_2024_23.Links, k::String)
    thirds = Set{String}()
    for k2 in links[k]
        second = links[k2]
        for k3 in second
            k3 in links[k] && k3 ∉ thirds || continue
            # println("$k-$k2-$k3")
            push!(all_trios, Set{String}((k,k2,k3)))
        end
    end
end

all_trios = Set{Set{String}}()
for k in keys(links)
    startswith(k, 't') || continue
    add_trios!(all_trios, links, k)
end
length(all_trios)