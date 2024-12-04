module AoC_2024_04
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
chmat = hcat(collect.(lines)...)

(n, m) = size(chmat)

tot = 0
for x in findall('X' .== chmat)
    for r in [1, 0, -1]
        rx = x[1] + r*3
        (rx <= n && rx > 0) || continue;
        for c in [1, 0, -1]
            cx = x[2] + c*3
            (cx <= m && cx > 0) || continue;
            global tot
            if chmat[x[1]+r, x[2]+c] == 'M'
                if chmat[x[1]+2*r, x[2]+2*c] == 'A'
                    if chmat[x[1]+3*r, x[2]+3*c] == 'S'
                        tot += 1
                    end
                end
            end
        end
    end
end

println(tot)




tot = 0
d = Dict('M'=>'S', 'S'=>'M')
for x in findall('A' .== chmat)
    (x[1] > 1 && x[1] < n && x[2] > 1 && x[2] < m) || continue;

    for b in [(1, -1)] # [(0, 1), (1, -1)]

        # @printf("(%d, %d):   (%+d, %+d) - (%+d, %+d) - (%+d, %+d) - (%+d, %+d)\n", 
        #     x[1], x[2], b[1], b[2], -b[1], -b[2], -b[2], b[1], b[2], -b[1])


        ch = chmat[x[1] + b[1], x[2] + b[2]]
        ch in keys(d) || continue;
        chmat[x[1] - b[1], x[2] - b[2]] == d[ch] || continue;

        ch = chmat[x[1] - b[2], x[2] + b[1]]
        ch in keys(d) || continue;
        chmat[x[1] + b[2], x[2] - b[1]] == d[ch] || continue;


        # @printf("%sA%s, %sA%s\n", chmat[x[1] + b[1], x[2] + b[2]], chmat[x[1] - b[1], x[2] - b[2]], ch, chmat[x[1] + b[2], x[2] - b[1]])
        
        global tot
        tot += 1
    end
    #     if 
    #     for a in [()]
    #     for c in [1, ]
    # if chmat[x[1]+1, x[1]]
    # for r in [1, 0, -1]
    #     rx = x[1] + r*3
    #     (rx <= n && rx > 0) || continue;
    #     for c in [1, 0, -1]
    #         cx = x[2] + c*3
    #         (cx <= m && cx > 0) || continue;
    #         global tot
    #         if chmat[x[1]+r, x[2]+c] == 'M'
    #             if chmat[x[1]+2*r, x[2]+2*c] == 'A'
    #                 if chmat[x[1]+3*r, x[2]+3*c] == 'S'
    #                     tot += 1
    #                 end
    #             end
    #         end
    #     end
    # end
end

println(tot)

# 1928 - too high