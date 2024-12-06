module AoC_2024_06
    using AdventOfCode;
    using DataStructures;

    lines2charmat(a::Vector{<:AbstractString}) = [a[i][j] for i=1:length(first(a)), j=1:length(a)]
    function parse_inputs(lines::Vector{String})::Tuple{Matrix{Char}, CartesianIndex{2}}
        charmat = lines2charmat(lines)
        idx_start::CartesianIndex{2} = findfirst(charmat .== '^')
        # charmat[idx_start] = '.';
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
visited = falses(size(charmat))

visited[idx_start] = true;

directions = Queue{CartesianIndex{2}}(4)
enqueue!(directions, CartesianIndex(-1,0))
enqueue!(directions, CartesianIndex(0,1))
enqueue!(directions, CartesianIndex(1,0))
enqueue!(directions, CartesianIndex(0,-1))

function test!(visited, charmat, directions, pos)
    dir = dequeue!(directions)
    while true
        pos += dir
        checkbounds(Bool, visited, pos) || break;

        if charmat[pos] == '#'
            pos -= dir
            # Turn and step back
            enqueue!(directions, dir)
            dir = dequeue!(directions)
            pos -= dir
        else
            visited[pos] = true
        end
    end
    return visited;
end

test!(visited, charmat, directions, idx_start)

count(visited)
