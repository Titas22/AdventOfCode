module AoC_2024_23
    using AdventOfCode

    const Links = Dict{Symbol, Set{Symbol}}

    function add_link!(d::Links, a::Symbol, b::Symbol)
        if !haskey(d, a)
            d[a] = Set{Symbol}()
        end
        push!(d[a], b)
    end
    function add_tsymbols!(tsymbols::Set{Symbol}, a::String, sa::Symbol)
        a[1] == 't' || return
        push!(tsymbols, sa)
    end
    function add_links!(d::Links, tsymbols::Set{Symbol}, a::String, b::String)
        sa = Symbol(a)
        sb = Symbol(b)
        add_link!(d, sa, sb)
        add_link!(d, sb, sa)
        add_tsymbols!(tsymbols, a, sa)
        add_tsymbols!(tsymbols, b, sb)
    end

    function parse_inputs(lines::Vector{String})
        links = Links()
        tsymbols = Set{Symbol}()
        for line in lines
            add_links!(links, tsymbols, line[1:2], line[4:5])
        end
        return (links, tsymbols)
    end

    function find_trios!(all_trios::Set{Set{Symbol}}, links::Links, k::Symbol)
        thirds = Set{Symbol}()
        for k2 in links[k]
            second = links[k2]
            for k3 in second
                k3 in links[k] && k3 ∉ thirds || continue
                push!(all_trios, Set{Symbol}((k,k2,k3)))
            end
        end
    end
    function solve_part_1(links::Links, tsymbols::Set{Symbol})
        all_trios = Set{Set{Symbol}}()
        for k in tsymbols
            find_trios!(all_trios, links, k)
        end
        return length(all_trios)
    end

    function solve_part_2(inputs)

        return nothing;
    end

    function solve(btest::Bool = false)::Tuple{Any, Any}
        lines       = @getinputs(btest)
        (links, tsymbols) = parse_inputs(lines)

        part1       = solve_part_1(links, tsymbols);
        part2       = solve_part_2(links);

        return (part1, part2);
    end

    # @time (part1, part2) = solve(true); # Test
    @time (part1, part2) = solve();
    println("\nPart 1 answer: $(part1)");
    println("\nPart 2 answer: $(part2)\n");

    # @assert(part1 == 1248, "Part 1 is wrong")
    # @assert(part2 == , "Part 2 is wrong")
end
# lines = @getinputs(true)


