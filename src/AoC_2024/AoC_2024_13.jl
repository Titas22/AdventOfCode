module AoC_2024_13
    using AdventOfCode;
    using Parsers;

    struct ClawMachine
        ButtonA::CartesianIndex{2}
        ButtonB::CartesianIndex{2}
        Prize::CartesianIndex{2}
    end

    function ClawMachine(three_lines::Vector{<:AbstractString})::ClawMachine
        m = match.(r"X[\+\=](\d+), Y[\+\=](\d+)", three_lines)
        btnA  = CartesianIndex(Parsers.parse(Int, m[1][1]), Parsers.parse(Int, m[1][2]))
        btnB  = CartesianIndex(Parsers.parse(Int, m[2][1]), Parsers.parse(Int, m[2][2]))
        prize = CartesianIndex(Parsers.parse(Int, m[3][1]), Parsers.parse(Int, m[3][2]))
        return ClawMachine(btnA, btnB, prize)
    end

    parse_inputs(lines::Vector{String})::Vector{ClawMachine} = ClawMachine.(split_at_empty_lines(lines))

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
lines = @getinputs(false)

machines = AoC_2024_13.parse_inputs(lines)

function find_cheapest_win(machine::AoC_2024_13.ClawMachine)::Int
    min_cost = 1000
    for iA = 0 : 100
        for iB = 0 : 100
            if machine.ButtonA * iA + machine.ButtonB * iB == machine.Prize  
                cost = iA * 3 + iB;
                cost < min_cost || continuel
                min_cost = cost;
            end
        end
    end
    return min_cost
end

costs = find_cheapest_win.(machines)
mapreduce(x -> x == 1000 ? 0 : x, +, costs)