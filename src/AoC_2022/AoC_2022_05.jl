module AoC_2022_05
    using AdventOfCode;
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
    
    function applyMove1!(stacks::CrateStack, move::CrateMove)
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

    function parseInputs(lines::Vector{String})::Tuple{ Vector{Stack{Char}}, Vector{CrateMove}}
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

        return (stacks, moves);
    end

    function solveCommon(stacks::Vector{Stack{Char}}, moves::Vector{CrateMove}, f!::Function)
        stacks = deepcopy(stacks);
        for move = moves 
            f!(stacks, move)
        end
        return String(first.(stacks));
    end

    function solve(bTestCase::Bool = false)::Tuple{Any, Any};
        lines           = @getInputs(bTestCase);
        (stacks, moves) = parseInputs(lines);

        part1       = solveCommon(stacks, moves, applyMove1!);
        part2       = solveCommon(stacks, moves, applyMove2!);

        return (part1, part2);
    end

    # @time (part1, part2) = solve(true); # Test
    # @time (part1, part2) = solve();
    # println("\nPart 1 answer: $(part1)");
    # println("Part 2 answer: $(part2)");
end