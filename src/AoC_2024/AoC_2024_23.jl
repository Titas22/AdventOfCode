module AoC_2024_23
    using AdventOfCode

    const Links = Dict{Int, Set{Int}}
    const Trio = Tuple{Int, Int, Int}

    letters2int(str::String)::Int = (str[1]-'a')*26 + str[2]-'a'
    function int2letters(v::Int)::String
        (d, r) = divrem(v, 26)
        return Char(97+d) * Char(97+r)
    end

    function add_link!(d::Links, a::Int, b::Int)
        if !haskey(d, a)
            d[a] = Set{Int}()
        end
        push!(d[a], b)
    end
    function add_links!(d::Links, a::String, b::String)
        na = letters2int(a)
        nb = letters2int(b)
        add_link!(d, na, nb)
        add_link!(d, nb, na)
    end

    function parse_inputs(lines::Vector{String})
        links = Links()
        for line in lines
            add_links!(links, line[1:2], line[4:5])
        end
        return links
    end

    function find_trios!(all_trios::Set{Trio}, links::Links, k::Int)
        linked = links[k]
        for k2 in linked
            k < k2 || continue
            second = links[k2]
            for k3 in second
                k3 > k2 && k3 in linked || continue
                push!(all_trios, (k, k2, k3))
            end
        end
    end

    function solve_common(links::Links)::Set{Trio}
        all_trios = Set{Trio}()
        for (k, _) in links
            find_trios!(all_trios, links, k)
        end
        return all_trios
    end

    function solve_part_1(all_trios::Set{Trio})
        total = 0
        lims = (letters2int("ta"), letters2int("tz"))
        for trio in all_trios
            any(x -> lims[1] <= x <= lims[2], trio) || continue
            total += 1
        end
        return total
    end

    function find_max_clique_size(all_trios::Set{Trio})::Vector{Int}
        counts = zeros(Int, 675)
        for triplet in all_trios
            for num in triplet
                @inbounds counts[num+1] += 1
            end
        end
        max_count = maximum(counts)
        return findall(x -> x == max_count, counts) .- 1
    end

    # https://en.wikipedia.org/wiki/Bron%E2%80%93Kerbosch_algorithm#With_pivoting
    function BronKerbosch!(largest_clique::Set{Int}, R::Set{Int}, P::Set{Int}, X::Set{Int}, N::Links)
        if isempty(P) && isempty(X)
            if length(R) > length(largest_clique)
                empty!(largest_clique)
                push!(largest_clique, R...)
            end
            return
        end
        u = union(P, X) |> first
        for v in setdiff(P, N[u])
            BronKerbosch!(largest_clique, union(R, [v]), intersect(P, N[v]), intersect(X, N[v]), N)
            P = setdiff(P, [v])
            X = union(X, [v])
        end
    end    
    
    function solve_part_2(all_trios::Set{Trio}, links::Links)::String
        vertices = find_max_clique_size(all_trios)
        
        largest_clique::Set{Int} = Set{Int}()
        BronKerbosch!(largest_clique, Set{Int}(), Set{Int}(vertices), Set{Int}(), links)

        return join(int2letters.(sort(collect(largest_clique))), ',')
    end

    function solve(btest::Bool = false)::Tuple{Any, Any}
        lines       = @getinputs(btest)

        links       = parse_inputs(lines)
        all_trios   = solve_common(links)

        part1       = solve_part_1(all_trios);
        part2       = solve_part_2(all_trios, links);

        return (part1, part2);
    end

    # @time (part1, part2) = solve(true); # Test
    @time (part1, part2) = solve();
    println("\nPart 1 answer: $(part1)");
    println("\nPart 2 answer: $(part2)\n");

    @assert(part1 == 1248, "Part 1 is wrong")
    @assert(part2 == "aa,cf,cj,cv,dr,gj,iu,jh,oy,qr,xr,xy,zb", "Part 2 is wrong")
end