module AoC_2023_02
    using AdventOfCode;
    const AoC = AdventOfCode;

    match_number_or_zero(rm::Union{Nothing, RegexMatch})::Int = isnothing(rm) ? 0 : parse(Int, rm.match);

    struct GameSet
        Red::Int
        Green::Int
        Blue::Int
    end
    GameSet(s::AbstractString)::GameSet = return GameSet(
        match_number_or_zero(match(r"(\d+)(?= red)", s)),
        match_number_or_zero(match(r"(\d+)(?= green)", s)),
        match_number_or_zero(match(r"(\d+)(?= blue)", s))
        );

    struct Game
        Id::Int
        Sets::Vector{GameSet}
        MaxSet::GameSet
    end

    function Game(line::AbstractString)::Game
        (game, sets) = split(line, ": ")
        id = parse(Int, game[6:end])
        sets = GameSet.(split(sets, "; "))
        maxset = GameSet(maximum((x->x.Red).(sets)), maximum((x->x.Green).(sets)), maximum((x->x.Blue).(sets)));
        return Game(id, sets, maxset);
    end

    ispossible(g::Game, red::Int=12, green::Int=13, blue::Int=14) = g.MaxSet.Red <= red && g.MaxSet.Green <= green && g.MaxSet.Blue <= blue; 
    
    get_power(g::Game) = g.MaxSet.Red * g.MaxSet.Green * g.MaxSet.Blue;

    parse_inputs(lines::Vector{<:AbstractString})::Vector{Game} = [Game(l) for l in lines] # Somehow this is faster (at least first time)
    # parse_inputs(lines::Vector{<:AbstractString})::Vector{Game} = Game.(lines); # <- this is nicer but gets recompiled every time
    
    solve_part_1(games::Vector{Game})::Int = sum([g.Id for g in games if ispossible(g)]);

    solve_part_2(games::Vector{Game})::Int = sum(get_power.(games));

    function solve(bTestCase::Bool = false)::Tuple{Int, Int};
        lines       = @getinputs(bTestCase);
        # lines2      = @getinputs(bTestCase, "_2"); # Use if 2nd problem test case inputs are different
        games      = parse_inputs(lines);

        part1       = solve_part_1(games);
        part2       = solve_part_2(games);

        return (part1, part2);
    end

    # @time (part1, part2) = solve(true); # Test
    @time (part1, part2) = solve();
    println("\nPart 1 answer: $(part1)");
    println("\nPart 2 answer: $(part2)");
end
