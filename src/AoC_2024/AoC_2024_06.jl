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

    function run_guard_path(charmat, pos)
        visdir = init_visited(charmat)
        idx_dir = 1;
        dir = directions[idx_dir];
        while true
            checkbounds(Bool, charmat, pos) || break;
            visdir[idx_dir][pos] && return (true, visdir)
            if charmat[pos] == '#'
                pos  -= dir
                idx_dir     = mod(idx_dir, 4) + 1
                dir         = directions[idx_dir]
            else
                visdir[idx_dir][pos] = true
            end

            pos += dir
        end

        return (false, visdir);
    end

    function solve_part_1(charmat, pos)
        (_, visdir) = run_guard_path(charmat, pos)
        visited = visdir[1] .|| visdir[2] .|| visdir[3] .|| visdir[4]
        return (count(visited), visdir)
    end

    function solve_part_2(charmat, start_pos, org_visdir)
        nloops = 0
        org_visited = org_visdir[1] .|| org_visdir[2] .|| org_visdir[3] .|| org_visdir[4]
        org_path = findall(org_visited)
        for block in org_path
            charmat[block] = '#'
            (isloop, _) = run_guard_path(charmat, start_pos) 
            if isloop
                nloops += 1;
            end
            charmat[block] = '.'
        end
        return nloops
    end

    function solve(btest::Bool = false)::Tuple{Any, Any}
        lines                   = @getinputs(btest);
        (charmat, idx_start)    = parse_inputs(lines);

        (part1, org_visdir)     = solve_part_1(charmat, idx_start);
        part2                   = solve_part_2(charmat, idx_start, org_visdir);

        return (part1, part2);
    end

    # @time (part1, part2) = solve(true); # Test
    @time (part1, part2) = solve();
    println("\nPart 1 answer: $(part1)");
    println("\nPart 2 answer: $(part2)\n");
end

# 4826
# 1721

# Don't start search from beginning each time, start in front of the inserted obstacle.
# Jump lookup table to shortcut between points (6 ms -> 1 ms)
# Parallelization (1 ms -> 386 µs)

# lines = @getinputs(true)
# (charmat, idx_start)    = AoC_2024_06.parse_inputs(lines);