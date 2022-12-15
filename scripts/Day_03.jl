# include("./scripts/Day_03.jl")
using Printf

getScore(ch::Char) = Int(ch) - (isuppercase(ch) ? 38 : 96);


function dayFunction(lines)
    score = 0;

    for l = lines
        chLast = l[Int(end/2)+1 : end];
        for ch = l[1:Int(end/2)]
            if contains(chLast, ch) 
                score += getScore(ch)
                break;
            end
        end
    end
    
    @printf("Score: %d\n", score);

    score2 = 0;
    for ii = 1 : 3 : length(lines)
        a = lines[ii];
        b = lines[ii+1];
        c = lines[ii+2];
        
        for ch = a
            if (contains(b, ch) && contains(c, ch))
                score2 += getScore(ch);
                break;
            end
        end
    end
    @printf("Score2: %d\n", score2);



    return lines;
end

lines = open("./inputs/inputs_03.txt") do file
    lines = dayFunction(readlines(file));
end

display("Done!")