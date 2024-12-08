module AoC_2024_08
    using AdventOfCode;

    function parse_inputs(lines::Vector{String})

        return lines;
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

antennas = Dict();
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


antinodes = falses(length(lines), length(lines[1]))

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

println(count(antinodes))


antinodes2 = falses(length(lines), length(lines[1]))

for (k, v) in antennas
    n = length(v)
    n > 1 || continue
    for ii in eachindex(v)
        a = v[ii]
        antinodes2[a] = true;
        for jj = (ii+1) : n
            b = v[jj]

            d = b - a
            kk = 1
            while checkbounds(Bool, antinodes, a - kk*d)
                antinodes2[a-kk*d] = true;
                kk += 1
            end
            kk = 1
            while checkbounds(Bool, antinodes, b + kk*d)
                antinodes2[b+kk*d] = true;
                kk += 1
            end
        end
    end
end

println(count(antinodes2))
