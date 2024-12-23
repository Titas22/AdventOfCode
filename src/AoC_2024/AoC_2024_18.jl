module AoC_2024_18
    using AdventOfCode
    using Parsers

    function convert(::Type{T}, line::AbstractString)::T where T<:CartesianIndex{2}
        idx = findfirst(',', line)
        return CartesianIndex(Parsers.parse(Int, line[idx+1:end]) + 1, Parsers.parse(Int, line[1:idx-1]) + 1)
    end

    function parse_inputs(lines::Vector{String})
        return convert.(CartesianIndex{2}, lines)
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
istest = false
lines = @getinputs(istest)
idx = AoC_2024_18.parse_inputs(lines)

sz = istest ? (7, 7) : (71, 71)
nbytes = istest ? 21 : 2994
const directions::NTuple{4, CartesianIndex{2}} = CartesianIndex.(((0,1), (-1,0), (0,-1), (1,0)))

corrupted = collect(falses(sz))
visited = collect(falses(sz))
corrupted[idx[1:nbytes]] .= true
corrupted

idx_start = CartesianIndex(1, 1)
idx_end = CartesianIndex(sz)

distances = fill(typemax(Int), sz)

function explore_next!(pq::PriorityQueue{CartesianIndex{2}, Int}, corrupted::Matrix{Bool}, next::CartesianIndex{2}, dist::Int)
    checkbounds(Bool, corrupted, next) || return
    corrupted[next] && return
    
    if haskey(pq, next) 
        pq[next] > dist || return
        pq[next] = dist
    else
        enqueue!(pq, next => dist)
    end
end

pq = PriorityQueue{CartesianIndex{2}, Int}(Base.Order.Forward)
enqueue!(pq, idx_start => 0)
while !isempty(pq)
    (pos, d) = dequeue_pair!(pq)

    visited[pos] && continue
    visited[pos] = true
    if pos == idx_end
        println("Finished: " * string(d))
        break;
    end

    for dir in directions
        explore_next!(pq, corrupted, pos+dir, d+1)
    end
end

# 2994 - not correct
# 30,57 - not correct
println(string(idx[nbytes][2]-1) * "," * string(idx[nbytes][1]-1))