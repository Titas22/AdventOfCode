module AoC_2023_21
    using AdventOfCode;
    using DataStructures
    const AoC = AdventOfCode;

    function parse_inputs(lines::Vector{String})::Tuple{Matrix{Char}, CartesianIndex{2}}
        charmat = reduce(hcat, collect.(lines));
        idx_start::CartesianIndex{2} = findfirst(charmat .== 'S')
        charmat[idx_start] = '.';
        return (charmat, idx_start);
    end
    
    const DIRECTIONS = (CartesianIndex(-1, 0), CartesianIndex(1, 0), CartesianIndex(0, -1), CartesianIndex(0, 1))

    function explore_around!(q::Queue{Tuple{CartesianIndex{2}, Int}}, stones::Matrix{Bool}, distances::Matrix{Int}, pos::CartesianIndex{2})
        next_dist = distances[pos]+1
        for dir in DIRECTIONS
            next = pos + dir;
            checkbounds(Bool, stones, next[1], next[2]) || continue;
            stones[next] && continue;
            distances[next] <= next_dist && continue;
    
            enqueue!(q, (next, next_dist))
        end
    end

    function find_distances(charmat::Matrix{Char}, start::CartesianIndex{2})::Matrix{Int}
        (n, m) = size(charmat);
        stones = collect(falses(n,m))
        stones[charmat .== '#'] .= true
        
        distances = fill(typemax(Int), (n, m))
        distances[start] = 0;
        
        q = Queue{Tuple{CartesianIndex{2}, Int}}()
        explore_around!(q, stones, distances, start);

        while !isempty(q)
            (pos, dist) = dequeue!(q);
            distances[pos] <= dist && continue;
            distances[pos] = dist;
            explore_around!(q, stones, distances, pos);
        end

        return distances;
    end

    get_plot_count(distances::Matrix{Int}, target::Int)::Int = count(distances .<= target .&& (distances .% 2) .== target % 2)

    function solve_part_1(charmat::Matrix{Char}, start::CartesianIndex{2})
        distances = find_distances(charmat, start);
        return get_plot_count(distances, 64)
    end

    function solve_part_2(charmat::Matrix{Char}, start::CartesianIndex{2})
        rep = 5;
        (n_org, m_org) = size(charmat);
        charmat = repeat(charmat, rep, rep)
        offset = round(Int, n_org * (rep-1)/2)
        start = start + CartesianIndex(offset, offset);

        distances = find_distances(charmat, start);
        x1 = n_org ÷ 2
        x2 = x1 + n_org
        x3 = x2 + n_org
        
        y1 = get_plot_count(distances, x1)
        y2 = get_plot_count(distances, x2)
        y3 = get_plot_count(distances, x3)
        
        # https://math.stackexchange.com/questions/680646/get-polynomial-function-from-3-points
        a = (x1*(y3-y2) + x2*(y1-y3) + x3*(y2-y1)) / ((x1-x2)*(x1-x3)*(x2-x3))
        b = (y2-y1)/(x2-x1) - a*(x1+x2)
        c = y1 - a*x1^2 - b*x1
        
        f(x::Int) = a*x^2 + b*x + c;

        return round(Int, f(Int(26501365)))
    end

    function solve(btest::Bool = false)::Tuple{Any, Any};
        lines                   = @getinputs(btest);
        (charmat, idx_start)    = parse_inputs(lines);

        part1       = solve_part_1(charmat, idx_start);
        part2       = solve_part_2(charmat, idx_start); # will not work for test inputs

        return (part1, part2);
    end

    # @time (part1, part2) = solve(true); # Test
    @time (part1, part2) = solve();
    println("\nPart 1 answer: $(part1)");
    println("\nPart 2 answer: $(part2)\n");
end