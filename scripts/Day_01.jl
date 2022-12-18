# include("./scripts/Day_01.jl")

function getSortedCalories(lines)
    calories = Vector{Int64}()

    currentCount = 0;
    for l = lines
        if !isempty(l)
            currentCount += parse(Int64, l);
            continue
        end

        push!(calories, currentCount)
        currentCount = 0;
    end

    sort!(calories, rev=true)

    return calories;
end

lines = open("./inputs/2022/in_2022--01.txt") do file
    lines = readlines(file);
end

@time calories = getSortedCalories(lines);

println("\nPart 1 answer: $(calories[1])");
println("\nPart 2 answer: $(sum(calories[1:3]))");