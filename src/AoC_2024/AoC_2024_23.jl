module AoC_2024_23
    using AdventOfCode

    const Links = Dict{Int, Set{Int}}
    const Trio = Tuple{Int, Int, Int}

    letters2int(str::String)::Int = (str[1]-'a') * 26 + str[2]-'a'

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
        thirds = Set{Int}()
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

    # function find_largest_network(links::Links, start::Symbol)
    #     network = Set{Symbol}()
    #     push!(network, start)
    #     return network
    # end
    
    function solve_part_2(all_trios::Set{Trio})
        # n_largest_network = 0
        # largest_network = Set{Symbol}()
        # for link in keys(links)
        #     ln = find_largest_network(links, link)
        #     sln = length(ln)
        #     sln > n_largest_network || continue
        #     n_largest_network = sln
        #     largest_network = ln
        # end

        return nothing;
    end

    function solve(btest::Bool = false)::Tuple{Any, Any}
        lines       = @getinputs(btest)

        links       = parse_inputs(lines)
        all_trios   = solve_common(links)

        part1       = solve_part_1(all_trios);
        part2       = solve_part_2(all_trios);

        return (part1, part2);
    end

    # @time (part1, part2) = solve(true); # Test
    @time (part1, part2) = solve();
    println("\nPart 1 answer: $(part1)");
    println("\nPart 2 answer: $(part2)\n");

    # @assert(part1 == 1248, "Part 1 is wrong")
    # @assert(part2 == , "Part 2 is wrong")
end
lines       = @getinputs(false)

links       = AoC_2024_23.parse_inputs(lines)
all_trios   = AoC_2024_23.solve_common(links)

vec = [trio for trio in all_trios]
sort!(vec)
vec

vertices = [k for k in keys(links)]

counts = vertices .* 0 
for (ii, v) in pairs(vertices)

    for t in vec
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
max_clique


letters2int(str::String)::Int = (str[1]-'a') * 26 + str[2]-'a'
function int2letters(v::Int)::String
    (d, r) = divrem(v, 26)
    return Char(97 + d) * Char(97+r)
end
# divrem

int2letters.(max_clique)

max_clique

function BronKerbosch1(R, P, X, N)
    if isempty(P) && isempty(X)
        println("Maximal clique: ", R)  # Report R as a maximal clique
    else
        for v in copy(P)
            BronKerbosch1(
                union(R, [v]), 
                intersect(P, N[v]), 
                intersect(X, N[v]), 
                N
            )
            P = setdiff(P, [v])
            X = union(X, [v])
        end
    end
end


R = Set()             # Initially empty
P = Set(max_clique)  # All vertices in the graph
X = Set()             # Initially empty
N = links
BronKerbosch1(R, P, X, N)
x = [61, 95, 622, 228, 57, 615, 0, 388, 241, 73, 165, 651, 433]
sort!(x)
join(int2letters.(x), ',')