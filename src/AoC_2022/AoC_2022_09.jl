module AoC_2022_09
    using AdventOfCode;
    using DataStructures 
    using Match

    const Point = CartesianIndex{2};

    struct Move
        Direction::Char
        Steps::Integer

        function Move(ln::String)
            new((x->(only(x[1]), parse(Int, x[2])))(split(ln, " "))...)
        end
    end

    parseInputs(lines::Vector{String}) = Move.(lines);

    function getStep(mv::Move)::Point
        @match mv.Direction begin
            'U' => Point(1, 0)
            'D' => Point(-1, 0)
            'L' => Point(0, -1)
            'R' => Point(0, 1)
        end
    end

    function printPos(rope::Vector{Base.RefValue{Point}})
        offset  = Point(-5, -5);
        vis     = fill(" . ", 18, 13);
        for ii = length(rope) : -1 : 2
            vis[Tuple(rope[ii][]-offset)...] = " $(ii-1) ";
        end
        vis[rope[1][]-offset] = " H ";
        display(join.(eachrow(reverse(vis, dims=1))))
        println("")
    end

    function printVisited(visited::Vector{Point})
        offset  = minimum(visited) - Point(1, 1);
        visited = (x->x-offset).(visited);

        zeros(Int, Tuple(maximum(visited))...)
        vis=fill(" . ", Tuple(maximum(visited))...);
        for idx in visited
            vis[idx] = " # ";
        end
        vis[visited[1]] = " S ";

        display(join.(eachrow(reverse(vis, dims=1))))
    end

    isAdjacent(a::Point, b::Point)  = all(-1 .<= Tuple(a-b) .<= 1);
    getNUniqueVisited(moves::Vector{Move}, ropeLength::Integer) = length(unique(moveRope(moves, ropeLength)));

    function followTail!(tRef::Ref{Point}, h::Point)::Bool
        !isAdjacent(tRef[], h) || return false;
        tRef[] += Point(sign.(Tuple(h-tRef[])));
        return true
    end

    function moveRope(moves::Vector{Move}, ropeLength::Integer)::Vector{Point}
        visited = [Point(0,0)];
        sizehint!(visited, length(moves));
        
        rope = [Ref(Point(0, 0)) for ii = 1 : ropeLength];
        for move in moves
            step = getStep(move);
            for ii = 1 : move.Steps
                rope[1][] += step;
                for jj = 2 : ropeLength-1
                    followTail!(rope[jj], rope[jj-1][]) || continue;
                end
                followTail!(rope[end], rope[end-1][]) || continue;
                push!(visited, deepcopy(rope[end][]));
            end
            # printPos(rope)
        end
        return visited;
    end
    
    function solve(bTestCase::Bool = false)::Tuple{Any, Any};
        lines       = @getinputs(bTestCase);
        moves      = parseInputs(lines);

        part1       = getNUniqueVisited(moves, 2);
        part2       = getNUniqueVisited(moves, 10);

        return (part1, part2);
    end

    # @time (part1, part2) = solve(true); # Test
    # @time (part1, part2) = solve();
    # println("\nPart 1 answer: $(part1)");
    # println("Part 2 answer: $(part2)");
end