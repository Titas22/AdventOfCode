module AoC_2023_04
    using AdventOfCode;
    const AoC = AdventOfCode;

    struct GameCard{T}
        Winning::Vector{T}
        Scratched::Vector{T}
    end

    function parse_inputs(lines::Vector{<:AbstractString})::Vector{GameCard}
        split_lines = split.(lines);
        idxsep      = findfirst(split_lines[1] .== "|");

        game_cards  = GameCard[]
        sizehint!(game_cards, length(lines))

        for line in split_lines
            winning    = line[3:idxsep-1];
            scratched  = line[idxsep+1:end];
            push!(game_cards, GameCard(winning, scratched));
        end

        return game_cards;
    end
    
    get_match_number(g::GameCard)::Int = count(n -> any(==(n), g.Scratched), g.Winning)

    solve_common(game_cards::Vector{GameCard})::Vector{Int} = get_match_number.(game_cards);

    solve_part_1(nmatches::Vector{Int})::Int = reduce(+, (x-> x > 0 ? 2^(x-1) : 0).(nmatches); init=0);

    function solve_part_2(nmatches::Vector{Int})::Int
        card_count = ones(Int, size(nmatches));
        for ii in eachindex(nmatches)
            n = nmatches[ii];
            for jj = 1 : n
                card_count[ii+jj]+=card_count[ii];
            end
        end
        return sum(card_count);
    end

    function solve(btest::Bool = false)::Tuple{Any, Any};
        lines       = @getinputs(btest);
        game_cards  = parse_inputs(lines);
        
        match_counts    = solve_common(game_cards);
        
        part1       = solve_part_1(match_counts);
        part2       = solve_part_2(match_counts);

        return (part1, part2);
    end

    # @time (part1, part2) = solve(true); # Test
    @time (part1, part2) = solve();
    println("\nPart 1 answer: $(part1)");
    println("\nPart 2 answer: $(part2)");
end