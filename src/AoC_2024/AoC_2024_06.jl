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

    function solve_part_1(charmat, start_pos)
        visited = falses(size(charmat))
        idx_dir = 1;
        dir = directions[idx_dir];
        while true
            start_pos += dir
            checkbounds(Bool, visited, start_pos) || break;
    
            if charmat[start_pos] == '#'
                start_pos  -= dir
                idx_dir     = mod(idx_dir, 4) + 1
                dir         = directions[idx_dir]
                start_pos  -= dir
            else
                visited[start_pos] = true
            end
        end
        return (count(visited)+1, visited);
    end

    function isloop(charmat, directions, pos, idx_dir = 1)
        sz = size(charmat)
        visdir = (falses(sz), falses(sz), falses(sz), falses(sz))
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

    function solve_part_2(charmat, start_pos, org_visited)
        nloops = 0
        org_path = findall(org_visited)
        for block in org_path
            charmat[block] = '#'
            if isloop(charmat, directions, start_pos) 
                nloops += 1;
            end
            charmat[block] = '.'
        end
        return nloops
    end

    function solve(btest::Bool = false)::Tuple{Any, Any}
        lines                   = @getinputs(btest);
        (charmat, idx_start)    = parse_inputs(lines);

        (part1, org_visited)    = solve_part_1(charmat, idx_start);
        part2                   = solve_part_2(charmat, idx_start, org_visited);

        return (part1, part2);
    end

    # @time (part1, part2) = solve(true); # Test
    @time (part1, part2) = solve();
    println("\nPart 1 answer: $(part1)");
    println("\nPart 2 answer: $(part2)\n");
end