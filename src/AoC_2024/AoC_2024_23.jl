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

    function to_sorted_tuple(k::T, k2::T, k3::T)::Tuple{T, T, T} where T<:Int
        if k < k2
            if k2 < k3
                return (k, k2, k3)
            elseif k3 < k
                return (k3, k , k2)
            else
                return (k, k3, k2)
            end
        else # k2 < k
            if k < k3
                return (k2, k, k3)
            elseif k3 < k2
                return (k3, k2, k)
            else
                return (k2, k3, k)
            end
        end
    end
    function find_trios!(all_trios::Set{Trio}, links::Links, k::Int)
        for k2 in links[k]
            second = links[k2]
            for k3 in second
                k3 in links[k] || continue
                push!(all_trios, to_sorted_tuple(k, k2, k3))
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

    function find_max_clique_size(all_trios::Set{Trio}, links::Links)
        vec_trios::Vector{Trio} = [trio for trio in all_trios]
        vertices::Vector{Int} = [k for (k, _) in links]

        counts = vertices .* 0
        for ii in eachindex(vertices)
            v = vertices[ii]
            for t in vec_trios
                v in t || continue
                counts[ii] += 1
            end
        end
        counts
        nmax = max(counts...)

        max_clique = Int[]
        for (c, v) in zip(counts, vertices)
            c == nmax || continue
            push!(max_clique, v)
        end

        return max_clique
    end
    
    function BronKerbosch!(largest_clique::Set{Int}, R::Set{Int}, P::Set{Int}, X::Set{Int}, N::Links)
        if isempty(P) && isempty(X)
            if length(R) > length(largest_clique)
                empty!(largest_clique)
                push!(largest_clique, R...)
            end
            return
        end
        for v in P
            BronKerbosch!(largest_clique, union(R, [v]), intersect(P, N[v]), intersect(X, N[v]), N)
            P = setdiff(P, [v])
            X = union(X, [v])
        end
    end
    
    function solve_part_2(all_trios::Set{Trio}, links::Links)::String
        vertices = find_max_clique_size(all_trios, links)
        # vertices = keys(links)
        largest_clique::Set{Int} = Set{Int}()
        BronKerbosch!(largest_clique, Set{Int}(), Set{Int}(vertices), Set{Int}(), links)

        x = [c for c in largest_clique]
        sort!(x)
        return join(int2letters.(x), ',')
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