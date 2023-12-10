module AoC_2023_07
    using AdventOfCode;
    import Base.isless;

    const AoC = AdventOfCode;

    # Define the custom ordering
    const custom_order = Dict('A' => 14, 'K' => 13, 'Q' => 12, 'J' => 11, 'T'=>10);

    struct Card
        label::Char
        value::Int
        value_joker::Int
    end
    function Card(card::Char)::Card
        val = isdigit(card) ? Int(card)-48 : custom_order[card]
        val_joker = val == 11 ? 1 : val;
        return Card(card, val, val_joker);
    end
    const Joker::Card = Card('J');

    function get_power(cards::Vector{Card}, s::Set{Card}, njoker::Int = 0):Int
        n = length(s)
        if n == 5 # high card
            return 0;
        elseif n == 4 # one pair
            return 1;
        elseif n == 1 || njoker == 5 # 5 of kind
            return 6;
        else
            m = [count(==(card), cards) for card in s ]
            nmax = maximum(m) + njoker;
            # println("$m")
            if nmax == 4 # 4 of kind
                return 5;
            elseif nmax == 3
                nmin = minimum(m);
                if nmin == 1 # 3 of kind
                    return 3; 
                else # full house
                    return 4;
                end
            else # 2 pair
                return 2;
            end
        end
    end
    
    function calculate_hand_power(cards::Vector{Card})::Tuple{Int, Int}
        s           = Set(cards)
        power       = get_power(cards, s);
        Joker in s || return(power, power)

        delete!(s, Joker)
        power_joker = get_power(cards, s, count(cards .== [Joker]));
        return (power, power_joker);
    end    

    struct Hand
        cards::Vector{Card}
        bid::Int
        power::Int
        power_joker::Int
    end

    Hand(line::AbstractString)::Hand = Hand(Card.(collect(line[1:5])), parse(Int, line[7:end]));
    Hand(cards::Vector{Card}, bid::Int)::Hand = Hand(cards, bid, calculate_hand_power(cards)...);

    function Base.isless(a::Hand, b::Hand)::Bool
        a.power == b.power || return isless(a.power, b.power);

        for idx in eachindex(a.cards)
            aval = a.cards[idx].value
            bval = b.cards[idx].value
            aval == bval || return isless(aval, bval);
        end
        return false;
    end

    function isless_joker(a::Hand, b::Hand)::Bool
        a.power_joker == b.power_joker || return isless(a.power_joker, b.power_joker);

        for idx in eachindex(a.cards)
            aval = a.cards[idx].value_joker
            bval = b.cards[idx].value_joker
            aval == bval || return isless(aval, bval);
        end
        return false;
    end

    parse_inputs(lines::Vector{String})::Vector{Hand} = Hand.(lines);
    function count_total_winnings(sorted_hands::Vector{Hand})::Int
        tot = 0;
        for idx in eachindex(sorted_hands)
            tot += idx * sorted_hands[idx].bid;
        end
        return tot;
    end

    function solve_part_1(hands::Vector{Hand})::Int
        sort!(hands)
        return count_total_winnings(hands);
    end

    function solve_part_2(hands::Vector{Hand})::Int
        sort!(hands; lt=isless_joker)
        return count_total_winnings(hands);
    end

    function solve(btest::Bool = false)::Tuple{Any, Any};
        lines       = @getinputs(btest);

        hands      = parse_inputs(lines);

        part1       = solve_part_1(hands);
        part2       = solve_part_2(hands);
        @assert(part1 == (btest ? 6440 : 251029473), "wrong part 1 answer")
        @assert(part2 == (btest ? 5905 : 251003917), "wrong part 2 answer")
        return (part1, part2);
    end

    # @time (part1, part2) = solve(true); # Test
    @time (part1, part2) = solve();
    println("\nPart 1 answer: $(part1)");
    println("\nPart 2 answer: $(part2)\n");
end