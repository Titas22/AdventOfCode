module AoC_2022_02
    using AdventOfCode;
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
    
    function getShape(str::SubString{String})::Shape
        @match str begin
            "A" || "X" => Rock()
            "B" || "Y" => Paper()
            "C" || "Z" => Scissors()
        end
    end

    function getShape(opponent::Shape, str::SubString{String})::Shape
        outcome = @match str begin
            "X" => 0
            "Y" => 3
            "Z" => 6
        end
        for myshape in [Rock(), Paper(), Scissors()]
            if result(opponent, myshape) == outcome
                return myshape;
            end
        end
    end
    
    function solve(bTestCase::Bool = false)::Tuple{Any, Any};
        lines           = @getInputs(bTestCase);
        score1, score2  = 0, 0;
    
        for l = lines
            game        = split(l, " ");
            oponnent    = getShape(game[1]);
            me1         = getShape(game[2]);
            me2         = getShape(oponnent, game[2]);
            score1 += result(oponnent, me1) + me1.shapeScore;
            score2 += result(oponnent, me2) + me2.shapeScore;
        end
        
        return (score1, score2);
    end

    # @time (part1, part2) = solve(true); # Test
    # @time (part1, part2) = solve();
    # println("\nPart 1 answer: $(part1)");
    # println("Part 2 answer: $(part2)");
end