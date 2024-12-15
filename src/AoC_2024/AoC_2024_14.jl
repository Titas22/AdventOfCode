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
    function solve_common(inputs)

        return inputs;
    end

    function solve_part_1(inputs)

        return nothing;
    end

    function solve_part_2(inputs)

        return nothing;
    end

    function solve(btest::Bool = false)::Tuple{Any, Any}
        lines       = @getinputs(btest);
        # lines2      = @getinputs(btest, "_2"); # Use if 2nd problem test case inputs are different
        inputs      = parse_inputs(lines);

        solution    = solve_common(inputs);
        part1       = solve_part_1(solution);
        part2       = solve_part_2(solution);

        return (part1, part2);
    end

    @time (part1, part2) = solve(true); # Test
    # @time (part1, part2) = solve();
    println("\nPart 1 answer: $(part1)");
    println("\nPart 2 answer: $(part2)\n");
end
bTest = false
lines = @getinputs(bTest)

robots = AoC_2024_14.parse_inputs(lines)

# org_robots = deepcopy(robots)

sz = bTest ? (7, 11) : (103, 101)

t = 100
[AoC_2024_14.move!(robot, t, sz) for robot in robots]

AoC_2024_14.calculate_safety_factor(robots, sz)

[AoC_2024_14.move!(robot, -t, sz) for robot in robots]

min_safety = (0, Inf)
max_safety = (0, -Inf)
for ii in 1 : prod(sz)
    for robot in robots
        AoC_2024_14.move!(robot, 1, sz)
    end

    sf = AoC_2024_14.calculate_safety_factor(robots, sz)

    global min_safety, max_safety
    if sf < min_safety[2]
        min_safety = (ii, sf)
    end
    if sf > max_safety[2]
        max_safety = (ii, sf)
    end    
end
println(min_safety)
println(max_safety)

