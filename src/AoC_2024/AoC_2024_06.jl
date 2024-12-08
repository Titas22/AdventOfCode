module AoC_2024_06
    using AdventOfCode;
    using DataStructures;

    const directions = (
        CartesianIndex(-1,  0), 
        CartesianIndex( 0,  1), 
        CartesianIndex( 1,  0), 
        CartesianIndex( 0, -1)
        )

    function parse_inputs(lines::Vector{String})::Tuple{Matrix{Bool}, CartesianIndex{2}}
        charmat = lines2charmat(lines)
        idx_start::CartesianIndex{2} = findfirst(charmat .== '^')
        charmat[idx_start] = '.';
        bobstacle = collect(charmat .== '#')
        return (bobstacle, idx_start);
    end

    function set_visdir!(visdir, pos, bool)
        visdir[1][pos] = bool
        visdir[2][pos] = bool
        visdir[3][pos] = bool
        visdir[4][pos] = bool
    end
    
    function run_guard_path!(visdir, bobstacle::Matrix{Bool}, pos::CartesianIndex{2}, idx_dir::Int=1, ispart2::Bool=false)::Tuple{Bool, Matrix{Int64}}
        visited = visdir[5]
        fill!(visited, false)

        dir         = directions[idx_dir];
        curvisdir   = visdir[idx_dir];
        first_dir   = zeros(Int, ispart2 ? (0,0) : size(bobstacle))
        
        while checkbounds(Bool, bobstacle, pos)            
            if bobstacle[pos]
                pos  -= dir
                idx_dir     = mod(idx_dir, 4) + 1
                dir         = directions[idx_dir]
                !visited[pos] && set_visdir!(visdir, pos, false)
                curvisdir   = visdir[idx_dir];
                ispart2 && @inbounds curvisdir[pos] && return (true, first_dir)
                curvisdir[pos] = true
                visited[pos] = true;
            else
                if !ispart2 
                    !visited[pos] && set_visdir!(visdir, pos, false)
                    curvisdir[pos] = true
                    visited[pos] = true;
                    if first_dir[pos] == 0
                        first_dir[pos] = idx_dir;
                    end
                end
            end

            pos += dir
        end

        return (false, first_dir);
    end

    function solve_part_1!(visdir, bobstacle, pos)
        (_, first_dir) = run_guard_path!(visdir, bobstacle, pos)
        return (count(x-> x>0, first_dir), first_dir)
    end

    function solve_part_2!(visdir, bobstacle, start_pos, first_dir)
        nloops = 0
        first_dir[start_pos] = 0;

        org_path = findall(x-> x>0, first_dir);

        for new_obstacle in org_path
            idx_dir = first_dir[new_obstacle]
            dir = directions[idx_dir];
            start_pos = new_obstacle - dir;
            bobstacle[new_obstacle] = true
            (isloop, _) = run_guard_path!(visdir, bobstacle, start_pos, idx_dir, true) 
            if isloop
                nloops += 1;
            end
            bobstacle[new_obstacle] = false
        end
        return nloops
    end

    function solve(btest::Bool = false)::Tuple{Any, Any}
        lines                           = @getinputs(btest);
        (bobstacle, idx_start)    = parse_inputs(lines);
        
        sz = size(bobstacle)
        visdir = (collect(falses(sz)), collect(falses(sz)), collect(falses(sz)), collect(falses(sz)), collect(falses(sz)))
        
        (part1, first_dir)      = solve_part_1!(visdir, bobstacle, idx_start);
        part2                   = solve_part_2!(visdir, bobstacle, idx_start, first_dir);

        return (part1, part2);
    end

    # @time (part1, part2) = solve(true); # Test
    @time (part1, part2) = solve();
    println("\nPart 1 answer: $(part1)");
    println("\nPart 2 answer: $(part2)\n");
end