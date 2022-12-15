# include("./scripts/Day_05.jl")
using Printf
using DataStructures 

# Typedefs
const CrateStack =  Vector{Stack{Char}};


struct CrateMove
    NCrates::Integer
    From::Integer
    To::Integer
    function CrateMove(str::String)
        inputs = parse.(Int64, match(r"move (\d+) from (\d+) to (\d+)", str).captures);
        new(inputs...);
    end
end



function applyMove!(stacks::CrateStack, move::CrateMove)
    for ii = 1 : move.NCrates
        push!(stacks[move.To], pop!(stacks[move.From]))
    end
end
function applyMove2!(stacks::CrateStack, move::CrateMove)
    temp = Stack{Char}();
    for ii = 1 : move.NCrates
        push!(temp, pop!(stacks[move.From]))
    end
    for ii = 1 : move.NCrates
        push!(stacks[move.To], pop!(temp))
    end
end


function dayFunction(lines)

    iSplit = findfirst(x->x=="", lines);

    moves = CrateMove.(lines[iSplit+1 : end]);
    ncol = parse.(Int64, split(strip(lines[iSplit-1]), "   "));

    lstack = lines[1:iSplit-2];
    # moves
    nCols = length(ncol);
    stacks = [Stack{Char}() for ii in 1:nCols];


    for row in reverse(lstack)
        cols = (x->x.captures[1]).(collect(eachmatch(r"(?:[[]([A-Z])[]]\s?|\s\s\s\s?)", row)));
        for iCol = 1 : nCols
            if cols[iCol] === nothing
                continue;
            end
            push!(stacks[iCol], only(cols[iCol]));
        end
    end
    display(stacks)
    stacks2 = deepcopy(stacks);

    display("   ")
    for move = moves 
        applyMove!(stacks, move)
    end

    
    display(stacks)
    
    for move = moves
        applyMove2!(stacks2, move)
    end
    display(stacks)
    display(stacks2)


    @printf("\nAnswer 1:\n")
    for stack in stacks
        @printf("%s", first(stack))
    end
    @printf("\n\n")

    @printf("\nAnswer 2:\n")
    for stack in stacks2
        @printf("%s", first(stack))
    end
    @printf("\n\n")
    return lines;
end

lines = open("./inputs/inputs_05.txt") do file
    @time lines = dayFunction(readlines(file));
end

# lines = open("./inputs/inputs_05_test.txt") do file
#      lines = readlines(file);
# end

display("Done!")


# function test(str::string)


