module AoC_2024_11
    using AdventOfCode;

    function parse_inputs(lines::Vector{String})

        return lines;
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
lines = @getinputs(false)

stones = Parsers.parse.(Int, collect(split.(lines[1])))
# stones = [125 17]
number_of_digits(val::Int) = floor(Int, log10(val)) + 1
org_stones = copy(stones)
function blink(stone::Int)
    stone == 0 && return [1]
    ndigits = number_of_digits(stone)
    if ndigits % 2 == 0
        power = 10^(ndigits ÷ 2)
        return [stone ÷ power, mod(stone, power)]
    end
    return [stone * 2024]
end

@time for ii = 1 : 25
    new_stones = blink.(stones)
    global stones
    stones = vcat(new_stones...)
    # println(Dates.format(now(), "HH:MM:SS.sss") * "   =>   " * string(ii))
end
p1_stones = copy(stones)
println(length(stones))


stones = copy(org_stones)

function blink2(stone::Int, nblinks::Int)
    nblinks == 0 && return 1;
    
    stone == 0 && return blink2(1, nblinks-1)

    ndigits = number_of_digits(stone)
    if ndigits % 2 == 0
        power = 10^(ndigits ÷ 2)

        return blink2(stone ÷ power, nblinks-1) + blink2(mod(stone, power), nblinks-1)
    end

    return blink2(stone * 2024, nblinks-1)
end

@time a = sum(blink2.(stones, 25))
println(a)




stones = copy(org_stones)
stonecounts = Dict{Int, Int}([(x, 1) for x in stones])

function insert_count!(stonecounts::Dict{Int, Int}, stone, count_to_add)
    if haskey(stonecounts, stone)
        stonecounts[stone] += count_to_add
    else
        stonecounts[stone] = count_to_add
    end
end

function blink3(stonecounts::Dict{Int, Int})::Dict{Int, Int}
    newcounts = Dict{Int, Int}()

    for (stone, counts) in stonecounts
        if stone == 0 
            insert_count!(newcounts, 1, counts);
        else 
            ndigits = number_of_digits(stone)
            if ndigits % 2 == 0
                power = 10^(ndigits ÷ 2)
                insert_count!(newcounts, stone ÷ power, counts);
                insert_count!(newcounts, mod(stone, power), counts);
            else
                insert_count!(newcounts, stone*2024, counts);
            end
        end
    end
    return newcounts
end

display(stonecounts)
@time for ii = 1 : 25
    global stonecounts
    stonecounts = blink3(stonecounts)
end

# display(stonecounts)
println(sum(values(stonecounts)))

