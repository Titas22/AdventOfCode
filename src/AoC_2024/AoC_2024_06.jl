module AoC_2024_06
    using AdventOfCode;
    using DataStructures;

    lines2charmat(a::Vector{<:AbstractString}) = [a[i][j] for i=1:length(first(a)), j=1:length(a)]
    function parse_inputs(lines::Vector{String})::Tuple{Matrix{Char}, CartesianIndex{2}}
        charmat = lines2charmat(lines)
        idx_start::CartesianIndex{2} = findfirst(charmat .== '^')
        charmat[idx_start] = '.';
        return (charmat, idx_start);
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


(charmat, idx_start)    = AoC_2024_06.parse_inputs(lines);

# directions = Queue{CartesianIndex{2}}(4)
# enqueue!(directions, CartesianIndex(-1,0))
# enqueue!(directions, CartesianIndex(0,1))
# enqueue!(directions, CartesianIndex(1,0))
# enqueue!(directions, CartesianIndex(0,-1))

directions = (
    CartesianIndex(-1,0), 
    CartesianIndex(0,1), 
    CartesianIndex(1,0), 
    CartesianIndex(0,-1)
    )


visited = falses(size(charmat))
# function init_directional_visited()
# end
sz = size(charmat)
visdir = (falses(sz), falses(sz), falses(sz), falses(sz))
#visdir = (copy(visited), copy(visited), copy(visited), copy(visited))

# visdir[1][idx_start] = true;
# visited[idx_start] = true;
# visdict = Dict{CartesianIndex{2}, BitMatrix}();
# for ii = 1 : 4
#     dir = dequeue!(directions)
#     visdict[dir] = copy(visited);
#     enqueue!(directions, dir)
# end


function test(charmat, directions, pos)
    visited = falses(size(charmat))
    idx_dir = 1;
    dir = directions[idx_dir];
    while true
        pos += dir
        checkbounds(Bool, visited, pos) || break;

        if charmat[pos] == '#'
            pos -= dir
            idx_dir = mod(idx_dir, 4) + 1
            dir = directions[idx_dir]
            pos -= dir
        else
            visited[pos] = true
        end
    end
    return visited;
end

@time visited = test(charmat, directions, idx_start)
@time visited = test(charmat, directions, idx_start)

println(count(visited) + 1)


function isloop(charmat, directions, pos)
    visdir = (falses(sz), falses(sz), falses(sz), falses(sz))
    idx_dir = 1;
    visdir[idx_dir][pos] = true;

    dir = directions[idx_dir];
    while true
        pos += dir
        checkbounds(Bool, charmat, pos) || break;
        visdir[idx_dir][pos] && return true;
        if charmat[pos] == '#'
            pos -= dir
            idx_dir = mod(idx_dir, 4) + 1
            dir = directions[idx_dir]
            pos -= dir
        else
            visdir[idx_dir][pos] = true
        end
    end
    return false;


end

nloops = 0
org_path = findall(visited)
for block in org_path
    charmat[block] = '#'
    if isloop(charmat, directions, idx_start) 
        global nloops
        nloops += 1;
    end
    charmat[block] = '.'
end
nloops
