module AoC_2022_11
    using AdventOfCode;
    using DataStructures 
    using Match
    
    function pushX!(s::Deque{Int}, vals::Vector{Int})
        for val in vals
            push!(s, val);
        end
    end
    
    function splitAtEmptyLines(lines::Vector{String})::Vector{Vector{String}}
        inputs          = Vector{Vector{String}}()
        currentBlock    = String[]
        for line in lines
            if isempty(line)
                push!(inputs, currentBlock)
                currentBlock = String[]
            else
                push!(currentBlock, line)
            end
        end
        push!(inputs, currentBlock)
        return inputs
    end
    
    substrAfter(str::String, after::String)::String = String(match(Regex("(?<=$(after))(.*)"), str).match);
    
    struct Monkey
        Id          ::Int
        Items       ::Deque{Int}
        Operation   ::Function
        ThrowTo     ::Function
        TestDivisor ::Int
        nInspections::Ref{Int}
        function Monkey(input::Vector{String})
            id              = parse(Int, substrAfter(input[1], "Monkey ")[1:end-1]);
            items           = Deque{Int}();
            pushX!(items, parse.(Int, split(substrAfter(input[2], "  Starting items: "), r",\s")));
            # op  = eval(Meta.parse("old -> " * substrAfter(input[3], "  Operation: new = ")));
            op  = substrAfter(input[3], "  Operation: new = ");
            if op == "old * old"
                op = old -> old*old;
            else
                k = parse(Int, op[7:end]);
                if op[5] == '*'
                    op = old -> old * k;
                else
                    op = old -> old + k;
                end
            end
    
            modulus         = parse(Int, substrAfter(input[4], "  Test: divisible by "));
            throwIfTrue     = parse(Int, substrAfter(input[5], "    If true: throw to monkey "));
            throwIfFalse    = parse(Int, substrAfter(input[6], "    If false: throw to monkey "));
            test            = x -> mod(x, modulus) == 0 ? throwIfTrue : throwIfFalse;
    
            return new(id, items, op, test,modulus, Ref(0))
        end
    end
    
    getMonkeyWithId(monkeys::Vector{Monkey}, id::Int)                 = monkeys[findfirst((x->x.Id == id).(monkeys))];
    inputsToMonkeys(inputs::Vector{Vector{String}})::Vector{Monkey}   = Monkey.(inputs);
    getNumberOfInspections(monkey::Monkey)::Int                       = monkey.nInspections[];
    
    function inspectItem!(monkeys::Vector{Monkey}, monkey::Monkey, divisor::Int, modulus::Int)
        item    = popfirst!(monkey.Items);
        new     = monkey.Operation(item);
        new     = Int(floor(new / divisor));
        new     = mod(new, modulus);            # https://en.wikipedia.org/wiki/Chinese_remainder_theorem
        throwTo = getMonkeyWithId(monkeys, monkey.ThrowTo(new));
        push!(throwTo.Items, new);
        monkey.nInspections[] += 1;
    end
    
    function monkeyTurn!(monkeys::Vector{Monkey}, monkey::Monkey, divisor::Int, modulus::Int)
        while !isempty(monkey.Items)
            inspectItem!(monkeys, monkey, divisor, modulus);
        end
    end
    
    monkeyRound!(monkeys::Vector{Monkey}, divisor::Int, modulus::Int) = (x->monkeyTurn!(monkeys, x, divisor, modulus)).(monkeys);
    
    function monkeyBusinessAfterXRounds(monkeys::Vector{Monkey}, nRounds::Int, divisor::Int)::Tuple{Vector{Monkey}, Int}
        monkeys = deepcopy(monkeys);
        for ii = 1 : nRounds
            monkeyRound!(monkeys, divisor, lcm((x->x.TestDivisor).(monkeys)...));
        end
    
        nInspections = getNumberOfInspections.(monkeys);
        sort!(nInspections, rev=true)
        monkeyBusiness = prod(nInspections[1:2]);
    
        return (monkeys, monkeyBusiness);
    end

    function solve(bTestCase::Bool = false)::Tuple{Any, Any};
        lines       = @getInputs(bTestCase);
        monkeys     = inputsToMonkeys(splitAtEmptyLines(lines));
        (monkeys1, monkeyBusiness1) = monkeyBusinessAfterXRounds(monkeys, 20, 3);
        (monkeys2, monkeyBusiness2) = monkeyBusinessAfterXRounds(monkeys, 10000, 1);

        return (monkeyBusiness1, monkeyBusiness2);
    end

    # @time (part1, part2) = solve(true); # Test
    @time (part1, part2) = solve();
    println("\nPart 1 answer: $(part1)");
    println("Part 2 answer: $(part2)");
end