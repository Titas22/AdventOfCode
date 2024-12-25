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

    const directions::NTuple{4, CartesianIndex{2}} = CartesianIndex.(((0,1), (-1,0), (0,-1), (1,0)))

    function find_path(charmat::Matrix{Char}, start::CartesianIndex{2})::Tuple{Vector{CartesianIndex{2}}, Matrix{Int}}
        pos = start
        prev_dir = CartesianIndex(0, 0)
        pathlength = count(x -> x == '.', charmat)
    
        path::Vector{CartesianIndex{2}} = [pos]
        sizehint!(path, pathlength)
        
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

        dist_to_end = fill(-1, size(charmat))
        pathlength = length(path)
        for ii in eachindex(path)
            dist_to_end[path[ii]] = pathlength - ii
        end
        return (path, dist_to_end)
    end

    get_distance(idx::CartesianIndex{2})::Int = abs(idx[1]) + abs(idx[2])

    function count_cheats(path::Vector{CartesianIndex{2}}, dist_to_end::Matrix{Int}, time_to_save::Int, grid::NTuple{N, CartesianIndex{2}})::Int where N
        distances = [get_distance(grid[ii]) for ii = 1 : N]
        count = 0
        for pos in path
            cur_dist = dist_to_end[pos] - time_to_save
            for ii in 1 : N
                @inbounds next = pos + grid[ii]
                checkbounds(Bool, dist_to_end, next) || continue
                @inbounds next_dist = dist_to_end[next]
                next_dist == -1 && continue
                @inbounds next_dist += distances[ii]
                cur_dist >= next_dist || continue
                count += 1
            end
        end
    
        return count
    end

    solve_part_1(path::Vector{CartesianIndex{2}}, dist_to_end::Matrix{Int}, time_to_save::Int) = count_cheats(path, dist_to_end, time_to_save, directions .* 2)
    function solve_part_2(path::Vector{CartesianIndex{2}}, dist_to_end::Matrix{Int}, time_to_save::Int) 
        r = 20
        grid = Tuple(CartesianIndex(ii, jj) for ii in -r:r for jj in -r:r if 1 < abs(ii) + abs(jj) <= r)
        return count_cheats(path, dist_to_end, time_to_save, grid)
    end

    function solve(btest::Bool = false)::Tuple{Any, Any}
        lines       = @getinputs(btest);
        (charmat, start) = parse_inputs(lines)

        (path, dist_to_end) = find_path(charmat, start)
        time_to_save = btest ? 64 : 100
        part1       = solve_part_1(path, dist_to_end, time_to_save);
        part2       = solve_part_2(path, dist_to_end, time_to_save);

        return (part1, part2);
    end

    # @time (part1, part2) = solve(true); # Test
    @time (part1, part2) = solve();
    println("\nPart 1 answer: $(part1)");
    println("\nPart 2 answer: $(part2)\n");
end