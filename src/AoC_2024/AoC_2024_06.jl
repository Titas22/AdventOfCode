module AoC_2024_06
    using AdventOfCode;
    using DataStructures;

    const directions = (
        CartesianIndex(-1,  0), 
        CartesianIndex( 0,  1), 
        CartesianIndex( 1,  0), 
        CartesianIndex( 0, -1)
        )

    function parse_inputs(lines::Vector{String})::Tuple{Matrix{Char}, CartesianIndex{2}}
        charmat = lines2charmat(lines)
        idx_start::CartesianIndex{2} = findfirst(charmat .== '^')
        charmat[idx_start] = '.';

        return (charmat, idx_start);
    end

    function run_guard_path!(visdir, charmat::Matrix{Char}, pos::CartesianIndex{2}, idx_dir::Int=1, ispart2::Bool=false)::Tuple{Bool, Matrix{Int64}}
        fill!.(visdir, false)
        dir         = directions[idx_dir];
        curvisdir   = visdir[idx_dir];
        first_dir   = zeros(Int, ispart2 ? (0,0) : size(charmat))
        
        while true
            checkbounds(Bool, charmat, pos) || break;
            ispart2 && @inbounds curvisdir[pos] && return (true, first_dir)
            
            if charmat[pos] == '#'
                pos  -= dir
                idx_dir     = mod(idx_dir, 4) + 1
                dir         = directions[idx_dir]
                curvisdir   = visdir[idx_dir];
            else
                curvisdir[pos] = true
                if !ispart2 && first_dir[pos] == 0
                    first_dir[pos] = idx_dir;
                end
            end

            pos += dir
        end

        return (false, first_dir);
    end

    function solve_part_1!(visdir, charmat, pos)
        (_, first_dir) = run_guard_path!(visdir, charmat, pos)
        return (count(x-> x>0, first_dir), first_dir)
    end

    function solve_part_2!(visdir, charmat, start_pos, first_dir)
        nloops = 0
        first_dir[start_pos] = 0;

        org_path = findall(x-> x>0, first_dir);

        for new_obstacle in org_path
            idx_dir = first_dir[new_obstacle]
            dir = directions[idx_dir];
            start_pos = new_obstacle - dir;
            charmat[new_obstacle] = '#'
            (isloop, _) = run_guard_path!(visdir, charmat, start_pos, idx_dir, true) 
            if isloop
                nloops += 1;
            end
            charmat[new_obstacle] = '.'
        end
        return nloops
    end

    function solve(btest::Bool = false)::Tuple{Any, Any}
        lines                           = @getinputs(btest);
        (charmat, idx_start)    = parse_inputs(lines);
        
        sz = size(charmat)
        visdir = (collect(falses(sz)), collect(falses(sz)), collect(falses(sz)), collect(falses(sz)))
        # visdir                  = (falses(sz), falses(sz), falses(sz), falses(sz))

        (part1, first_dir)      = solve_part_1!(visdir, charmat, idx_start);
        part2                   = solve_part_2!(visdir, charmat, idx_start, first_dir);

        return (part1, part2);
    end

    # @time (part1, part2) = solve(true); # Test
    @time (part1, part2) = solve();
    println("\nPart 1 answer: $(part1)");
    println("\nPart 2 answer: $(part2)\n");
end