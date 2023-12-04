module AoC_2022_13
    using AdventOfCode;
    using JSON
    const AoC = AdventOfCode;
    
    parseInputs(lines::Vector{String})  = map(x->JSON.parse.(x), splitAtEmptyLines(lines))

    isCorrectOrder(packetPair::Vector{Vector{Any}}) = isCorrectOrder(packetPair[1], packetPair[2]);
    isCorrectOrder(a::Integer, b::Vector{Any})      = isCorrectOrder(Any[a], b);
    isCorrectOrder(a::Vector{Any}, b::Integer)      = isCorrectOrder(a, Any[b]);
    isCorrectOrder(a::Integer, b::Integer)          = a < b ? 1 : (a == b ? 0 : -1);

    function isCorrectOrder(a::Vector{Any}, b::Vector{Any})
        for ii in 1 : min(length(a), length(b))
            correct = isCorrectOrder(a[ii], b[ii]);
            if correct == 0
                continue;
            end
            return correct;
        end

        return isCorrectOrder(length(a), length(b));
    end

    solvePart1(packetPairs::Vector{Vector{Vector{Any}}}) =  sum(findall(isCorrectOrder.(packetPairs) .> 0))

    function solvePart2(packetPairs::Vector{Vector{Vector{Any}}}, extra1=[2], extra2=[6])
        allPackets      = vcat(packetPairs...)
        push!(allPackets, extra1, extra2)

        sortedPackets   = sort(allPackets, lt=(a,b)->isCorrectOrder(a,b)>0)

        return findfirst(sortedPackets .== [extra1]) * findfirst(sortedPackets .== [extra2]);
    end

    function solve(bTestCase::Bool = false)::Tuple{Any, Any};
        lines       = @getInputs(bTestCase);
        packetPairs = parseInputs(lines);

        part1       = solvePart1(packetPairs);
        part2       = solvePart2(packetPairs);

        return (part1, part2);
    end

    # @time (part1, part2) = solve(true); # Test
    # @time (part1, part2) = solve();
    # println("\nPart 1 answer: $(part1)");
    # println("\nPart 2 answer: $(part2)");
end