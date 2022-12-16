# include("./scripts/Day_06.jl")
using DataStructures 

function findMarker(line::String, n::Integer)
    cbuf = CircularBuffer{Char}(n);
    append!(cbuf, collect(line[1:n-1]));

    for ii in n : length(line)
        push!(cbuf, line[ii]);
        if length(unique(cbuf)) == n
            display("Answer: $ii");
            break;
        end
    end

end

# lines = open("./inputs/2022/in_2022--06_test.txt") do file
lines = open("./inputs/2022/in_2022--06.txt") do file
    lines = readlines(file);
end

findMarker.(lines, 4);
findMarker.(lines, 14);

display("Done!")