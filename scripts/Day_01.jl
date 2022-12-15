# include("./scripts/Day_01.jl")


function getMaxSum(lines)
    currentCount = 0;
    maxCount = 0;

    for l = lines
        if !isempty(l)
            currentCount += parse(Int64, l);
            continue
        end
        if currentCount > maxCount
            maxCount = currentCount;
        end
        currentCount = 0;
    end
    display("")
    return maxCount;
end

lines = open("./inputs/2022/inputs_2022_01.txt") do file
    display(getMaxSum(readlines(file)))
end