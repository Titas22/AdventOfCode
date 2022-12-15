# include("./scripts/Day_04.jl")
using Printf

function processLine(l::String)
    sections = split(l, ',');
    a = parse.(Int64, split(sections[1], '-'));
    b = parse.(Int64, split(sections[2], '-'));

    if (a[1] <= b[1] && a[2] >= b[2])
        return 1;
    elseif  (b[1] <= a[1] && b[2] >= a[2])
        return 1;
    else
        return 0;
    end
end

function processLine2(l::String)
    sections = split(l, ',');
    a = parse.(Int64, split(sections[1], '-'));
    b = parse.(Int64, split(sections[2], '-'));

    if max(a[1],b[1]) <= min(a[2],b[2])
        return 1;
    else
        return 0;
    end
end

function dayFunction(lines)    
    @printf("Score: %d\n", sum(processLine.(lines)));

    @printf("Score2: %d\n", sum(processLine2.(lines)));

    return lines;
end

lines = open("./inputs/2022/inputs_2022_04.txt") do file
    lines = dayFunction(readlines(file));
end

display("Done!")