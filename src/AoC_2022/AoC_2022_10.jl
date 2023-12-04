module AoC_2022_10
    using AdventOfCode;
    using DataStructures 

    struct Instruction
        NCycles::Integer
        Delta::Integer
    
        function Instruction(str::String)
            return startswith(str, "noop") ? new(1, 0) : new(2, parse(Int, str[6:end]));
        end
    end
    
    function getCycleValues(instructions::Vector{Instruction}, regVal::Int)::Vector{Int}
        cycleVals   = [regVal];
        sizehint!(cycleVals, length(instructions) * 3);
    
        for instruction in instructions
            for ii = 1 : instruction.NCycles-1
                push!(cycleVals, regVal)
            end
            regVal += instruction.Delta;
            push!(cycleVals, regVal)
        end
        
        return cycleVals;
    end
    
    function getImageCRT(instructions::Vector{Instruction}, regVal::Int)::Vector{String}
        crt = fill(" . ", 6, 40)
        NCycle = 0;
    
        for instruction in instructions
            for ii = 1 : instruction.NCycles
                iRow = div(NCycle, 40);
                iCol = NCycle - iRow * 40;
    
                if -1 <= regVal - iCol <= 1 
                    crt[iRow+1, iCol+1] =" # ";
                end
                NCycle += 1;
            end
            regVal += instruction.Delta;
        end
    
        return join.(eachrow(crt));
    end

    function solvePart1(instructions::Vector{Instruction})
        cycleVals   = getCycleValues(instructions, 1);
        nCycles     = collect(20:40:220);

        return sum(cycleVals[nCycles] .* nCycles);
    end
    parseInputs(lines::Vector{String})::Vector{Instruction} = Instruction.(lines);

    function solve(bTestCase::Bool = false)::Tuple{Any, Any};
        lines           = @getInputs(bTestCase);
        instructions    = parseInputs(lines);

        part1       = solvePart1(instructions);
        part2       = join(getImageCRT(instructions, 1), "\n");

        return (part1, part2);
    end

    # @time (part1, part2) = solve(true); # Test
    # @time (part1, part2) = solve();
    # println("\nPart 1 answer: $(part1)");
    # println("Part 2 answer:\n$(part2)");
end