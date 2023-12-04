module AoC_2022_12
    using AdventOfCode;
    using DataStructures 
    import Base: +
    
    +(idx::CartesianIndex{2}, dx::Tuple{Int64, Int64}) = CartesianIndex(idx[1]+dx[1], idx[2]+dx[2])
    
    function parseInputs(lines::Vector{String})::Tuple{Matrix{Int64}, CartesianIndex{2}, CartesianIndex{2}}
        hLetters                    = reduce(hcat, collect.(lines));
        heights                     = Int.(reduce(hcat, collect.(lines))) .- Int('a');
        heights[hLetters .== 'E']  .= Int('z') - (Int('a')-1);
    
        idxStart            = findfirst(hLetters .== 'S');
        idxPeak             = findfirst(hLetters .== 'E');
        heights[idxStart]   = 0;
        heights[idxPeak]    = Int('z') - Int('a');
    
        return (heights, idxStart, idxPeak);
    end
    
    function findDistanceMatrix(heights::Matrix{Int}, idx0::CartesianIndex{2})::Tuple{Matrix{Int}, BitMatrix}
        (nRows, nCols)      = size(heights);
    
        distances           = zeros(Int, size(heights)) .+ prod(size(heights));
        bProcessed          = falses(size(heights));
    
        searchList          = Queue{Tuple{CartesianIndex{2}, Int}}();
        enqueue!(searchList, (idx0, 0));
        
        while !isempty(searchList)
            (idxCurrent, dist)          = dequeue!(searchList);
            if bProcessed[idxCurrent]
                continue;
            end
    
            distances[idxCurrent]       = dist;
            bProcessed[idxCurrent]      = true;
    
            for didx in [(-1,0), (1,0), (0,-1), (0,1)]
                idxNext = idxCurrent + didx;
    
                if !(0 < idxNext[1] <= nRows && 0 < idxNext[2] <= nCols) || bProcessed[idxNext] ||  (heights[idxCurrent] - heights[idxNext]) > 1
                    continue;
                end
    
                enqueue!(searchList, (idxNext, dist+1));
            end
        end
    
        return (distances, bProcessed);
    end

    function solve(bTestCase::Bool = false)::Tuple{Any, Any};
        lines                           = @getInputs(bTestCase);
        (heights, idxStart, idxPeak)    = parseInputs(lines);
        (distances, bProcessed)         = findDistanceMatrix(heights, idxPeak);

        return (distances[idxStart], minimum(distances[heights .== 0]));
    end

    # @time (part1, part2) = solve(true); # Test
    # @time (part1, part2) = solve();
    # println("\nPart 1 answer: $(part1)");
    # println("Part 2 answer: $(part2)");
end