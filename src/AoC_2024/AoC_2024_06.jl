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

    function init_visited(charmat::Matrix{Char})::NTuple{4, BitMatrix}
        sz = size(charmat)
        return (falses(sz), falses(sz), falses(sz), falses(sz))
    end

    function run_guard_path(charmat::Matrix{Char}, pos::CartesianIndex{2}, idx_dir::Int=1, ispart2::Bool=false)::Tuple{Bool, NTuple{4, BitMatrix}, Matrix{Int64}}
        visdir      = init_visited(charmat)
        dir         = directions[idx_dir];
        if !ispart2
            firstvisit  = zeros(Int, size(charmat))
        else
            firstvisit  = zeros(Int, 0, 0)
        end
        while true
            checkbounds(Bool, charmat, pos) || break;
            ispart2 && visdir[idx_dir][pos] && return (true, visdir, firstvisit)
            if charmat[pos] == '#'
                pos  -= dir
                idx_dir     = mod(idx_dir, 4) + 1
                dir         = directions[idx_dir]
            else
                visdir[idx_dir][pos] = true
                if !ispart2 && firstvisit[pos] == 0
                    firstvisit[pos] = idx_dir;
                end
            end

            pos += dir
        end

        return (false, visdir, firstvisit);
    end

    function solve_part_1(charmat, pos)
        (_, visdir, firstvisit) = run_guard_path(charmat, pos)
        visited = visdir[1] .|| visdir[2] .|| visdir[3] .|| visdir[4]
        return (count(visited), firstvisit)
    end

    function solve_part_2(charmat, start_pos, first_dir)
        nloops = 0
        first_dir[start_pos] = 0;

        org_path = findall(x-> x>0, first_dir);

        for new_obstacle in org_path
            idx_dir = first_dir[new_obstacle]
            dir = directions[idx_dir];
            start_pos = new_obstacle - dir;
            charmat[new_obstacle] = '#'
            (isloop, _, _) = run_guard_path(charmat, start_pos, idx_dir, true) 
            if isloop
                nloops += 1;
            end
            charmat[new_obstacle] = '.'
        end
        return nloops
    end

    function solve(btest::Bool = false)::Tuple{Any, Any}
        lines                   = @getinputs(btest);
        (charmat, idx_start)    = parse_inputs(lines);
        # println(typeof(idx_start))
        (part1, first_dir)      = solve_part_1(charmat, idx_start);
        part2                   = solve_part_2(charmat, idx_start, first_dir);

        return (part1, part2);
    end

    # @time (part1, part2) = solve(true); # Test
    @time (part1, part2) = solve();
    println("\nPart 1 answer: $(part1)");
    println("\nPart 2 answer: $(part2)\n");
end