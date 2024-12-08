module AoC_2024_08
    using AdventOfCode;

    function parse_inputs(lines::Vector{String})
        antennas = Dict{Char, Vector{CartesianIndex{2}}}();
        for ii in eachindex(lines)
            line = lines[ii];
            for jj in eachindex(line)
                line[jj] == '.' && continue;
                ch = line[jj]
                if haskey(antennas, ch)
                    push!(antennas[ch], CartesianIndex(ii, jj))
                else
                    antennas[ch] = [CartesianIndex(ii, jj)]
                    sizehint!(antennas[ch], 10)
                end
            end
        end
        sz = (length(lines), length(lines[1]))
        return (antennas, sz);
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
        
                    if checkbounds(Bool, antinodes, a - d)
                        antinodes[a-d] = true;
                    end
                    if checkbounds(Bool, antinodes, b + d)
                        antinodes[b+d] = true;
                    end
                end
            end
        end
        
        return count(antinodes);
    end

    function solve_part_2(antennas, sz)
        antinodes = falses(sz)
        
        for (k, v) in antennas
            n = length(v)
            n > 1 || continue
            for ii in eachindex(v)
                a = v[ii]
                antinodes[a] = true;
                for jj = (ii+1) : n
                    b = v[jj]
        
                    d = b - a
                    kk = 1
                    while checkbounds(Bool, antinodes, a - kk*d)
                        antinodes[a-kk*d] = true;
                        kk += 1
                    end
                    kk = 1
                    while checkbounds(Bool, antinodes, b + kk*d)
                        antinodes[b+kk*d] = true;
                        kk += 1
                    end
                end
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