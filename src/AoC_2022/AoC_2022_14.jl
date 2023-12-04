module AoC_2022_14
    using AdventOfCode;
    using OffsetArrays;
    using IterTools;
    const AoC = AdventOfCode;

    parseCoord(coord::SubString)                                            = CartesianIndex(parse.(Int, split(coord, ','))...)
    parseInputs(lines::Vector{String})::Vector{Vector{CartesianIndex{2}}}   = map(x->parseCoord.(x), split.(lines, r"\s->\s"))

    function cartesianIndexBounds(indices::Vector{CartesianIndex{2}})
        x = (x->x[1]).(indices);
        y = (x->x[2]).(indices);
        return (CartesianIndex(min(x...), min(y...)), CartesianIndex(max(x...), max(y...)))
    end

    function displayCave(cave::OffsetMatrix{Bool, BitMatrix})
        caved                           = fill(".", size(cave));
        caved[cave.parent]             .= "#"
        caved[500 - cave.offsets[1], 1] = "+"
        println("\n"*join(join.(eachrow(permutedims(caved))), "\n")*"\n")
    end

    function initialiseCave(blockages)
        (bndMin, bndMax) = cartesianIndexBounds(vcat(blockages...))
        
        yAxis = 0 : bndMax[2];
        xAxis = bndMin[1]-1 : bndMax[1]+1;

        cave = OffsetArray(falses(length(xAxis), length(yAxis)), xAxis, yAxis)

        for blockage in blockages
            for (from, to) in partition(blockage, 2, 1)
                cave[from:to] .= true;
                cave[from < to ? (from:to) : (to:from)] .= true;
            end
        end
        # displayCave(cave)
        return cave;
    end

    function findFlooredColumnRange(cave, nRows)::Tuple{Int, Int}
        mincol = 500-nRows;
        maxcol = 500+nRows;

        for (iRow, row) in enumerate(eachcol(cave))
            any(row) || continue;

            offset = (nRows - iRow + 1)

            mincol = min(mincol, findfirst(row) - offset)
            maxcol = max(maxcol, findlast(row) + offset)
        end
        
        return (mincol, maxcol)
    end

    function addCaveFloor(cave)
        nRows               = size(cave, 2) + 2;
        (minCol, maxCol)    = findFlooredColumnRange(cave, nRows)
        nCols               = maxCol - minCol + 1;

        flooredCave         = OffsetArray(falses(nCols, nRows), minCol : maxCol, 0 : nRows-1);
        for idx in CartesianIndices(cave)
            flooredCave[idx] = cave[idx];
        end
        flooredCave[:, end]    .= true;

        # displayCave(flooredCave)
        return flooredCave;
    end

    isAnythingBelow(cave::OffsetMatrix{Bool, BitMatrix}, coord::CartesianIndex{2})::Bool    = any(cave[coord:CartesianIndex(coord[1], size(cave, 2) + cave.offsets[2])]);
    canFallDown(cave::OffsetMatrix{Bool, BitMatrix}, coord::CartesianIndex{2})::Bool        = !cave[coord + CartesianIndex(0,1)];

    function dropSand!(cave::OffsetMatrix{Bool, BitMatrix}, coord = CartesianIndex(500,0))::Bool
        nSteps = 0;

        while isAnythingBelow(cave, coord)
            if canFallDown(cave, coord)
                coord += CartesianIndex(0,1);
            elseif canFallDown(cave, coord + CartesianIndex(-1,0))
                coord += CartesianIndex(-1,1);
            elseif canFallDown(cave, coord + CartesianIndex(+1,0))
                coord += CartesianIndex(+1,1);
            else
                if cave[500, 0]
                    cave[coord] = true;
                    return false;
                end

                cave[coord] = true;
                return true;
            end

            nSteps += 1;
        end

        return false;
    end

    function simulateFallingSand(cave)
        cave    = deepcopy(cave);
        nSands  = 0;
        while dropSand!(cave)
            # displayCave(cave)
            nSands += 1;
        end
        return nSands
    end

    function solve(bTestCase::Bool = false)::Tuple{Any, Any};
        lines       = @getInputs(bTestCase);
        blockages   = parseInputs(lines);

        cave        = initialiseCave(blockages);
        part1       = simulateFallingSand(cave);
        part2       = simulateFallingSand(addCaveFloor(cave));

        return (part1, part2);
    end


    # @time (part1, part2) = solve(true); # Test
    # @time (part1, part2) = solve();
    # println("\nPart 1 answer: $(part1)");
    # println("\nPart 2 answer: $(part2)");
end