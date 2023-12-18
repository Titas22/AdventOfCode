module AoC_2023_15
    using AdventOfCode;
    using OrderedCollections;
    const AoC = AdventOfCode;

    parse_inputs(lines::Vector{String})::Vector{<:AbstractString} = split(lines[1], ',');
    
    function elf_hash(str::SubString{String})::Int
        current = 0;
        for ii in eachindex(str)
            current += Int(str[ii]);
            current *= 17;
            current %= 256;
        end
        return current;
    end

    function process_step!(boxes::Vector{OrderedDict{SubString{String}, Int}}, step::SubString{String})
        if endswith(step, '-')
            label = step[1:end-1]
            nbox = elf_hash(label)+1
            delete!(boxes[nbox], label);
        else
            label = step[1:end-2]
            nbox = elf_hash(label)+1
            val = step[end] - '0'
            box = boxes[nbox];
            box[label] = val;
        end
    end

    function get_power(boxes)
        total = 0;
        for nbox in eachindex(boxes)
            box = boxes[nbox]
            isempty(box) && continue;
            for (ilens, power) in enumerate(values(box))
                total += nbox * ilens * power;
            end
        end
        return total;
    end

    solve_part_1(steps::Vector{<:AbstractString})::Int = sum(elf_hash.(steps));

    function solve_part_2(steps::Vector{<:AbstractString})::Int
        boxes = [OrderedDict{SubString{String}, Int}() for _ = 0 : 255]
        sizehint!.(boxes, 9);

        for step in steps
            process_step!(boxes, step);
        end
        
        return get_power(boxes);
    end

    function solve(btest::Bool = false)::Tuple{Any, Any};
        lines       = @getinputs(btest);
        steps       = parse_inputs(lines);

        part1       = solve_part_1(steps);
        part2       = solve_part_2(steps);

        return (part1, part2);
    end

    # @time (part1, part2) = solve(true); # Test
    @time (part1, part2) = solve();
    println("\nPart 1 answer: $(part1)");
    println("\nPart 2 answer: $(part2)\n");
end
