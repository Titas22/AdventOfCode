module AoC_2022_03
    using AdventOfCode;

    getScore(ch::Char) = Int(ch) - (isuppercase(ch) ? 38 : 96);

    function solvePart1(lines)
        score = 0;

        for l = lines
            chLast = l[Int(end/2)+1 : end];
            for ch = l[1:Int(end/2)]
                if contains(chLast, ch) 
                    score += getScore(ch)
                    break;
                end
            end
        end
        return score;
    end

    function solvePart2(lines)
        score = 0;
        for ii = 1 : 3 : length(lines)
            a = lines[ii];
            b = lines[ii+1];
            c = lines[ii+2];
            
            for ch = a
                if (contains(b, ch) && contains(c, ch))
                    score += getScore(ch);
                    break;
                end
            end
        end
        return score;
    end

    function solve(bTestCase::Bool = false)::Tuple{Any, Any};
        lines       = @getInputs(bTestCase);

        return (solvePart1(lines), solvePart2(lines));
    end

    # @time (part1, part2) = solve(true); # Test
    # @time (part1, part2) = solve();
    # println("\nPart 1 answer: $(part1)");
    # println("Part 2 answer: $(part2)");
end