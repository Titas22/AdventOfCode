module AoC_2024_20
    using AdventOfCode

    function find_position(charmat::Matrix{Char}, ch::Char)::CartesianIndex{2}
        idx = findfirst(x -> x == ch, charmat)
        charmat[idx] = '.'
        return idx;
    end

    function parse_inputs(lines::Vector{String})::Tuple{Matrix{Char}, CartesianIndex{2}}
        charmat = lines2charmat(lines)
        
        start = find_position(charmat, 'S')
        find_position(charmat, 'E')

        return (charmat, start)
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

const directions::NTuple{4, CartesianIndex{2}} = CartesianIndex.(((0,1), (-1,0), (0,-1), (1,0)))

(charmat, start) = AoC_2024_20.parse_inputs(lines)

function find_path(charmat::Matrix{Char}, start::CartesianIndex{2})::Vector{CartesianIndex{2}}
    pos = start
    prev_dir = CartesianIndex(0, 0)
    pathlength = count(x -> x == '.', charmat)

    path::Vector{CartesianIndex{2}} = [pos]
    sizehint!(path, pathlength)
    
    println(pathlength)
    
    for _ = 2 : pathlength
        for dir in directions
            dir == prev_dir && continue
            next = pos + dir
            checkbounds(Bool, charmat, next) || continue
            charmat[next] == '.' || continue

            push!(path, next)
            pos = next
            prev_dir = -dir
            break
        end
    end
    return path
end

path = find_path(charmat, start)

dist_to_end = fill(-1, size(charmat))
pathlength = length(path)
for ii in eachindex(path)
    dist_to_end[path[ii]] = pathlength - ii
end

display(dist_to_end)

function count_cheats(path::Vector{CartesianIndex{2}}, dist_to_end::Matrix{Int}, time_to_save::Int = 100)
    count = 0
    # grid = CartesianIndices((-1:1, -1:1))
    tstep = 2
    time_to_save += tstep
    for pos in path
        cur_dist = dist_to_end[pos]
        # println("Pos: " * string(pos) * " dist = " * string(cur_dist))
        for dir in directions
            next = pos + dir*tstep
            checkbounds(Bool, dist_to_end, next) || continue
            next_dist = dist_to_end[next]
            next_dist == -1 && continue
            cur_dist - next_dist >= time_to_save || continue
            # println("Next: " * string(next) * " dist = " * string(next_dist))
            count += 1
        end
    end

    return count
end

count_cheats(path, dist_to_end, 100)
