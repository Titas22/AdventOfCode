module AoC_2024_13
    using AdventOfCode;
    using Parsers;

    struct ClawMachine
        ButtonA::CartesianIndex{2}
        ButtonB::CartesianIndex{2}
        Prize::CartesianIndex{2}
    end

    function ClawMachine(three_lines::Vector{<:AbstractString})::ClawMachine
        m   = match.(r"X[\+\=](\d+), Y[\+\=](\d+)", three_lines)
        btnA  = CartesianIndex(Parsers.parse(Int, m[1][1]), Parsers.parse(Int, m[1][2]))
        btnB  = CartesianIndex(Parsers.parse(Int, m[2][1]), Parsers.parse(Int, m[2][2]))
        prize = CartesianIndex(Parsers.parse(Int, m[3][1]), Parsers.parse(Int, m[3][2]))
        return ClawMachine(btnA, btnB, prize)
    end

    parse_inputs(lines::Vector{String})::Vector{ClawMachine} = ClawMachine.(split_at_empty_lines(lines))

    function find_cheapest_win(machine::ClawMachine, prize_offset::Int = 0)::Int
        prize = machine.Prize + CartesianIndex(prize_offset, prize_offset);

        # Cramer's rule (https://en.wikipedia.org/wiki/Cramer%27s_rule)
        D  = machine.ButtonA[1] * machine.ButtonB[2] - machine.ButtonA[2] * machine.ButtonB[1]
        Da = prize[1] * machine.ButtonB[2] - prize[2] * machine.ButtonB[1]
        Db = machine.ButtonA[1] * prize[2] - machine.ButtonA[2] * prize[1]

        A = Da ÷ D
        B = Db ÷ D

        (A * D != Da || B * D != Db) && return 0;
        return 3*A + B
    end

    function solve_common(machines::Vector{ClawMachine}, prize_offset::Int = 0)::Int
        return mapreduce(machine -> find_cheapest_win(machine, prize_offset), +, machines)
    end

    function solve(btest::Bool = false)::Tuple{Any, Any}
        lines       = @getinputs(btest);
        machines    = parse_inputs(lines);

        part1       = solve_common(machines, 0);
        part2       = solve_common(machines, 10000000000000);

        return (part1, part2);
    end

    # @time (part1, part2) = solve(true); # Test
    @time (part1, part2) = solve();
    println("\nPart 1 answer: $(part1)");
    println("\nPart 2 answer: $(part2)\n");
end