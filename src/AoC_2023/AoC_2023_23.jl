module AoC_2023_23
    using AdventOfCode;
    const AoC = AdventOfCode;

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

    function solve(btest::Bool = false)::Tuple{Any, Any};
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
lines = @getinputs(true)

using DataStructures

charmat = permutedims(reduce(hcat, collect.(lines)), [2 1])
(n, m) = size(charmat);

start_pos = CartesianIndex(1, findfirst(charmat[1, :] .== '.'));
end_pos = CartesianIndex(n, findfirst(charmat[end, :] .== '.'));

forest = collect(falses(n,m))
forest[charmat .== '#'] .= true

const SearchParams = Tuple{CartesianIndex{2}, Int, Matrix{Bool}};
const DIRECTIONS = (CartesianIndex(-1, 0), CartesianIndex(1, 0), CartesianIndex(0, -1), CartesianIndex(0, 1)) # ^ V < >

function explore_position!(q::Queue{SearchParams}, forest::Matrix{Bool}, visited::Matrix{Bool}, next_dist::Int, next::CartesianIndex{2})::Bool
    checkbounds(Bool, forest, next[1], next[2]) || return false;
    forest[next] && return false;
    visited[next] && return false;

    enqueue!(q, (next, next_dist, visited))

    return true;
end

function explore_around!(q::Queue{SearchParams}, forest::Matrix{Bool}, visited::Matrix{Bool}, next_dist::Int, pos::CartesianIndex{2})
    is_first_step = true;
    for dir in DIRECTIONS
        if is_first_step
            is_first_step = explore_position!(q, forest, visited, next_dist, pos + dir);
        else
            explore_position!(q, forest, copy(visited), next_dist, pos + dir);
        end
    end
end

function find_distances(charmat::Matrix{Char}, forest::Matrix{Bool}, start_pos::CartesianIndex{2}, end_pos::CartesianIndex{2}, bpart2::Bool = false)::Int
    (n, m) = size(charmat);
    visited = collect(falses(n, m));
    
    q = Queue{SearchParams}()
    explore_position!(q, forest, visited, 1, start_pos + DIRECTIONS[2]);

    path_lengths = Int[];
    while !isempty(q)
        (pos, dist, visited) = dequeue!(q);
        if pos == end_pos
            push!(path_lengths, dist)
            continue
        end

        visited[pos] = true;

        ch = charmat[pos];
        dist += 1;
        if ch == '.' || bpart2
            explore_around!(q, forest, visited, dist, pos);
        elseif ch == 'v'
            explore_position!(q, forest, visited, dist, pos + DIRECTIONS[2]);
        elseif ch == '^'
            explore_position!(q, forest, visited, dist, pos + DIRECTIONS[1]);
        elseif ch == '<'
            explore_position!(q, forest, visited, dist, pos + DIRECTIONS[3]);
        else #if ch == '>'
            explore_position!(q, forest, visited, dist, pos + DIRECTIONS[4]);
        end
    end

    return maximum(path_lengths);
end

@time p1 = find_distances(charmat, forest, start_pos, end_pos)
print(p1)
println("\nPart 1 answer: $(p1)");
# p1 = 2318


# @time p2 = find_distances(charmat, forest, start_pos, end_pos, true)
# print(p2)
# @time (part1, part2) = solve();
# println("\nPart 2 answer: $(p2)\n");
@profile find_distances(charmat, forest, start_pos, end_pos)
Profile.print()