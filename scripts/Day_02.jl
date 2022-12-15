# include("./scripts/Day_02.jl")
using Match
using Parameters

abstract type Shape end

@with_kw struct Rock <: Shape
    shapeScore = 1
end
@with_kw struct Paper <: Shape
    shapeScore = 2
end
@with_kw struct Scissors <: Shape
    shapeScore = 3
end

result(a::Rock, b::Rock) = 3;
result(a::Rock, b::Paper) = 6;
result(a::Rock, b::Scissors) = 0;

result(a::Paper, b::Rock) = 0;
result(a::Paper, b::Paper) = 3;
result(a::Paper, b::Scissors) = 6;

result(a::Scissors, b::Rock) = 6;
result(a::Scissors, b::Paper) = 0;
result(a::Scissors, b::Scissors) = 3;

getShape(str::SubString{String})::Shape = getShape(string(str));
function getShape(str::String)::Shape
    @match str begin
        "A" || "X" => Rock()
        "B" || "Y" => Paper()
        "C" || "Z" => Scissors()
    end
end

function dayFunction(lines)
    score = 0;

    for l = lines
        game = split(l, " ");
        oponnent = getShape(game[1]);
        me = getShape(game[2]);
        score += result(oponnent, me) + me.shapeScore;
    end
    
    return score;
end

lines = open("./inputs/2022/inputs_2022_02.txt") do file
    display(dayFunction(readlines(file)))
end