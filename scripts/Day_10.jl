# include("./scripts/Day_09.jl")
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
    sizehint!(cycleVals, length(lines) * 3);

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

# lines = open("./inputs/2022/in_2022--10_test.txt") do file
lines = open("./inputs/2022/in_2022--10.txt") do file
    lines = readlines(file);
end

@time instructions = Instruction.(lines)

cycleVals   = getCycleValues(instructions, 1);
nCycles     = collect(20:40:220);
println("\nPart 1 answer: $(sum(cycleVals[nCycles] .* nCycles))");

@time crt = getImageCRT(instructions, 1);
print("Part 2 answer:\n$(join(crt, "\n"))")