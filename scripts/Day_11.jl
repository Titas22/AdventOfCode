# include("./scripts/Day_11.jl")
using DataStructures 

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

struct Monkey13
    Id          ::Int
    Items       ::Deque{Int}
    Operation   ::Function
    ThrowTo     ::Function
    TestDivisor ::Int
    nInspections::Ref{Int}
    function Monkey13(input::Vector{String})
        id              = parse(Int, substrAfter(input[1], "Monkey ")[1:end-1]);
        items           = Deque{Int}();
        pushX!(items, parse.(Int, split(substrAfter(input[2], "  Starting items: "), r",\s")));
        op              = eval(Meta.parse("old -> " * substrAfter(input[3], "  Operation: new = ")));

        modulus         = parse(Int, substrAfter(input[4], "  Test: divisible by "));
        throwIfTrue     = parse(Int, substrAfter(input[5], "    If true: throw to monkey "));
        throwIfFalse    = parse(Int, substrAfter(input[6], "    If false: throw to monkey "));
        test            = x -> mod(x, modulus) == 0 ? throwIfTrue : throwIfFalse;

        return new(id, items, op, test,modulus, Ref(0))
    end
end

getMonkeyWithId(monkeys::Vector{Monkey13}, id::Int)                 = monkeys[findfirst((x->x.Id == id).(monkeys))];
inputsToMonkeys(inputs::Vector{Vector{String}})::Vector{Monkey13}   = Monkey13.(inputs);
getNumberOfInspections(monkey::Monkey13)::Int                       = monkey.nInspections[];

function inspectItem!(monkeys::Vector{Monkey13}, monkey::Monkey13, divisor::Int, modulus::Int)
    item    = popfirst!(monkey.Items);
    new     = monkey.Operation(item);
    new     = Int(floor(new / divisor));
    new     = mod(new, modulus);            # https://en.wikipedia.org/wiki/Chinese_remainder_theorem
    throwTo = getMonkeyWithId(monkeys, monkey.ThrowTo(new));
    push!(throwTo.Items, new);
    monkey.nInspections[] += 1;
end

function monkeyTurn!(monkeys::Vector{Monkey13}, monkey::Monkey13, divisor::Int, modulus::Int)
    while !isempty(monkey.Items)
        inspectItem!(monkeys, monkey, divisor, modulus);
    end
end

monkeyRound!(monkeys::Vector{Monkey13}, divisor::Int, modulus::Int) = (x->monkeyTurn!(monkeys, x, divisor, modulus)).(monkeys);

function monkeyBusinessAfterXRounds(monkeys::Vector{Monkey13}, nRounds::Int, divisor::Int)::Tuple{Vector{Monkey13}, Int}
    monkeys = deepcopy(monkeys);
    for ii = 1 : nRounds
        monkeyRound!(monkeys, divisor, lcm((x->x.TestDivisor).(monkeys)...));
    end

    nInspections = getNumberOfInspections.(monkeys);
    sort!(nInspections, rev=true)
    monkeyBusiness = prod(nInspections[1:2]);

    return (monkeys, monkeyBusiness);
end


@time lines = begin
    # lines = open("./inputs/2022/in_2022--11_test.txt") do file
    lines = open("./inputs/2022/in_2022--11.txt") do file
        lines = readlines(file);
    end
end

@time monkeys = inputsToMonkeys(splitAtEmptyLines(lines));

@time (monkeys1, monkeyBusiness1) = monkeyBusinessAfterXRounds(monkeys, 20, 3);
@time (monkeys2, monkeyBusiness2) = monkeyBusinessAfterXRounds(monkeys, 10000, 1);

println("\nPart 1 answer: $(monkeyBusiness1)");
println("\nPart 2 answer: $(monkeyBusiness2)");

println("Done!")