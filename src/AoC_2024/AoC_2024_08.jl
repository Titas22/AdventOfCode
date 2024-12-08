module AoC_2024_08
    using AdventOfCode;

    function parse_inputs(lines::Vector{String})
        antennas = Dict{Char, Vector{CartesianIndex{2}}}();
        for ii in eachindex(lines)
            line = lines[ii];
            for jj in eachindex(line)
                line[jj] == '.' && continue;
                ch = line[jj]
                if !haskey(antennas, ch)
                    antennas[ch] = CartesianIndex{2}[]
                    sizehint!(antennas[ch], 4)
                end
                push!(antennas[ch], CartesianIndex(ii, jj))
            end
        end
        sz = (length(lines), length(lines[1]))
        return (antennas, sz);
    end

    function check_antinode!(antinodes, pos)
        checkbounds(Bool, antinodes, pos) || return false;
        antinodes[pos] = true;
    end

    function solve_part_1(antennas, sz)
        antinodes = falses(sz)
        
        for (k, v) in antennas
            n = length(v)
            for ii in eachindex(v)
                a = v[ii]
                for jj = (ii+1) : n
                    b = v[jj]
                    d = b - a
                    check_antinode!(antinodes, a-d)
                    check_antinode!(antinodes, b+d)
                end
            end
        end
        
        return count(antinodes);
    end

    function find_all_antinodes!(antinodes, antenna, step)
        kk = 1
        while check_antinode!(antinodes, antenna + step * kk)
            kk += 1
        end
    end

    function solve_part_2(antennas, sz)
        antinodes = falses(sz)
        
        for (k, v) in antennas
            n = length(v)
            n > 1 || continue
            for ii in eachindex(v)
                a = v[ii]
                for jj = (ii+1) : n
                    b = v[jj]
                    d = b - a
                    find_all_antinodes!(antinodes, a, -d)
                    find_all_antinodes!(antinodes, b, d)
                end
                antinodes[a] = true;
            end
        end
        
        return count(antinodes);
    end

    function solve(btest::Bool = false)::Tuple{Any, Any}
        lines       = @getinputs(btest);
        (antennas, sz)      = parse_inputs(lines);
        
        part1       = solve_part_1(antennas, sz);
        part2       = solve_part_2(antennas, sz);

        return (part1, part2);
    end

    # @time (part1, part2) = solve(true); # Test
    @time (part1, part2) = solve();
    println("\nPart 1 answer: $(part1)");
    println("\nPart 2 answer: $(part2)\n");
end