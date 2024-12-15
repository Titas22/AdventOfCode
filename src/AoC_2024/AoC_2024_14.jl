module AoC_2024_14
    using AdventOfCode;
    using Parsers;

    struct Robot
        position::Vector{Int}
        velocity::Tuple{Int, Int}
    end
    
    function split_values(str::AbstractString)::Tuple{Int, Int}
        idx = findfirst(x->x==',', str)
        return (Parsers.parse(Int, str[idx+1:end]), Parsers.parse(Int, str[1:idx-1]))
    end
    
    function Robot(line::AbstractString)::Robot
        idx = findfirst(x->x==' ', line)
        pos = split_values(line[3 : idx-1])
        vel = split_values(line[idx+3 : end])
    
        return Robot(collect(pos), vel)
    end

    function move!(robot::Robot, t::Int, sz::Tuple{Int, Int})
        new_pos = robot.position .+ robot.velocity .* t
        robot.position[1] = mod(new_pos[1], sz[1])
        robot.position[2] = mod(new_pos[2], sz[2])
    end

    parse_inputs(lines::Vector{String})::Vector{Robot} = Robot.(lines);

    function calculate_safety_factor(robots::Vector{Robot}, sz::Tuple{Int, Int})::Int
        qcounts = zeros(Int, 4, 1)
        mid = sz .÷ 2
        for robot in robots
            (robot.position[1] == mid[1] || robot.position[2] == mid[2]) && continue
            idx_quadrant = (robot.position[2] < mid[2] ? 1 : 2) + (robot.position[1] < mid[1] ? 0 : 2)    
            qcounts[idx_quadrant] += 1
        end
        
        return prod(qcounts)
    end

    function solve_part_1(robots::Vector{Robot}, sz::Tuple{Int, Int}, t::Int = 100)::Int
        [move!(robot, t, sz) for robot in robots]
        sf = calculate_safety_factor(robots, sz)
        
        # Reset back
        [move!(robot, -t, sz) for robot in robots]

        return sf
    end

    function solve_part_2(robots::Vector{Robot}, sz::Tuple{Int, Int})::Int
        min_safety = (0, Inf)
        for ii in 1 : prod(sz)
            for robot in robots
                move!(robot, 1, sz)
            end
            sf = calculate_safety_factor(robots, sz)

            sf < min_safety[2] || continue
            min_safety = (ii, sf)
        end
        return min_safety[1];
    end

    function solve(btest::Bool = false)::Tuple{Any, Any}
        lines       = @getinputs(btest);
        robots      = parse_inputs(lines);
        sz          = btest ? (7, 11) : (103, 101)

        part1       = solve_part_1(robots, sz);
        part2       = solve_part_2(robots, sz);

        return (part1, part2);
    end

    # @time (part1, part2) = solve(true); # Test
    @time (part1, part2) = solve();
    println("\nPart 1 answer: $(part1)");
    println("\nPart 2 answer: $(part2)\n");
end