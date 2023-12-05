module AoC_2022_08
    using AdventOfCode;

    parseInputs(lines::Vector{String}) = parse.(Int, permutedims(hcat(collect.(lines)...)));

    function updateVisibilityOneDir!(bVisible::AbstractVector{Bool}, th::Vector{<:Integer})
        maxHeight = th[1];
        for ii in 2 : length(th)
            if th[ii] > maxHeight
                bVisible[ii] = true;
                maxHeight = th[ii];
            end
        end
    end

    function updateVisibility!(bVisible::AbstractVector{Bool}, th::Vector{<:Integer})
        updateVisibilityOneDir!(bVisible, th);
        
        updateVisibilityOneDir!(reverse!(bVisible), reverse(th));
        reverse!(bVisible);
        return bVisible;
    end

    function visibleTrees(treeHeights::Matrix{<:Integer})::Integer
        (nRows, nCols)          = size(treeHeights);

        bVisible                = falses(nRows, nCols);
        bVisible[[1, end], :]  .= true
        bVisible[:, [1, end]]  .= true

        for iCol in 2 : nCols-1
            bVisible[:, iCol] = updateVisibility!(bVisible[:, iCol], treeHeights[:, iCol]);
        end

        for iRow in 2 : nRows-1
            bVisible[iRow, :] = updateVisibility!(bVisible[iRow, :], treeHeights[iRow, :]);
        end
        
        return count(bVisible);
    end

    function getDirectionScore(vec::Vector{<:Integer})::Integer
        th = vec[1];
        idx = 1;
        for outer idx in 2 : length(vec)
            if vec[idx] >= th
                break;
            end
        end
        return idx - 1;
    end

    function scenicScore(treeHeights::Matrix{<:Integer})::Integer
        (nRows, nCols)          = size(treeHeights);

        scores                  = zeros(Int, nRows, nCols);
        for idx in Iterators.filter(x-> (1 < x[1] < nRows && 1 < x[2] < nCols), CartesianIndices(treeHeights))
            vis = [
                getDirectionScore(treeHeights[idx[1], idx[2] : -1 : 1]), 
                getDirectionScore(treeHeights[idx[1], idx[2] : end]),
                getDirectionScore(treeHeights[idx[1] : -1 : 1, idx[2]]),
                getDirectionScore(treeHeights[idx[1] : end, idx[2]])
                ];
                
            scores[idx] = prod(vis);
        end

        return maximum(scores);
    end

    function solve(bTestCase::Bool = false)::Tuple{Any, Any};
        lines       = @getinputs(bTestCase);
        treeHeights = parseInputs(lines);

        part1       = visibleTrees(treeHeights);
        part2       = scenicScore(treeHeights);

        return (part1, part2);
    end

    # @time (part1, part2) = solve(true); # Test
    # @time (part1, part2) = solve();
    # println("\nPart 1 answer: $(part1)");
    # println("Part 2 answer: $(part2)");
end