module AoC_2023_15
    using AdventOfCode;
    using OrderedCollections;
    const AoC = AdventOfCode;

    function parse_inputs(lines::Vector{String})::Vector{Vector{Int}}
        steps = Int.(collect(lines[1]));
        
        idx = [0; findall(steps .== Int(',')); lastindex(steps)+1];
        idx_sets = (:).(idx[1:end-1].+1,idx[2:end].-1);

        return (x->steps[x]).(idx_sets);
    end
    
    function elf_hash(step::Vector{Int})::Int
        current = 0;
        for val in step
            current += val;
            current *= 17;
            current %= 256;
        end
        return current;
    end

    function hash_vec(vals::Vector{Int})::Int
        out = 0;
        for ii in eachindex(vals)
            out *= 100
            out += vals[ii]
        end
        return out
    end

    function process_step!(boxes::Vector{OrderedDict{UInt, Int}}, step::Vector{Int})
        if step[end] == Int('-')
            label = step[1:end-1]
            nbox = elf_hash(label)+1
            delete!(boxes[nbox], hash_vec(label));
        else
            label = step[1:end-2]
            nbox = elf_hash(label)+1
            val = step[end]
            box = boxes[nbox];
            box[hash_vec(label)] = val;
        end
    end

    function get_power(boxes)
        total = 0;
        for nbox in eachindex(boxes)
            box = boxes[nbox]
            isempty(box) && continue;
            for (ilens, power) in enumerate(values(box))
                total += nbox * ilens * (power - 48);
            end
        end
        return total;
    end

    solve_part_1(steps::Vector{Vector{Int64}})::Int = sum(elf_hash.(steps));

    function solve_part_2(steps::Vector{Vector{Int64}})::Int
        boxes = [OrderedDict{UInt, Int}() for _ = 0 : 255]
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
