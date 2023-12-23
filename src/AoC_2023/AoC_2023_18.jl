module AoC_2023_18
    using AdventOfCode;
    const AoC = AdventOfCode;

    struct Instruction
        dir::Int
        length::Int
    end

    function parse_instructions(line::AbstractString)::Tuple{Instruction, Instruction}
        (d, l, c) = split(line)
        
        d1 = to_dir(d[1]);
        l1 = parse(Int, l);
        m1 = Instruction(d1, l1);
    
        d2 = parse(Int, c[end-1])+1
        l2 = parse(Int, @view(c[3:end-2]), base=16);
        m2 = Instruction(d2, l2);
        return (m1, m2);
    end

    function parse_inputs(lines::Vector{String})::Tuple{AbstractArray, AbstractArray}
        all_instructions = stack(parse_instructions.(lines))
        return (@view(all_instructions[1,:]), @view(all_instructions[2,:]))
    end
    
    function to_dir(ch::Char)::Int
        ch == 'R' && return 1;
        ch == 'D' && return 1;
        ch == 'L' && return 1;
        return 4; # U
    end
    
    const DIRECTIONS::Tuple = (
        CartesianIndex(0, 1), # 0 / R
        CartesianIndex(-1, 0), # 1 / D
        CartesianIndex(0, -1), # 2 / L 
        CartesianIndex(1, 0) # 3 / U
    )
    @inbounds get_step(dir::Int)::CartesianIndex{2} = DIRECTIONS[dir];
    
    get_next(current::CartesianIndex{2}, m::Instruction)::CartesianIndex{2} = current + get_step(m.dir) * m.length;
    
    function solve_common(instructions::AbstractArray)
        prev = start = CartesianIndex(0, 0);
        dist = area = 0;
        for instruction in instructions
            current = get_next(prev, instruction);
            dist += instruction.length;
            area += current[1]*prev[2] - prev[1]*current[2]; # Shoelace Algorithm
            prev = current;
        end
        area += start[1]*prev[2] - prev[1]*start[2];
    
        area = abs(area);
    
        return (div(area, 2) + div(dist, 2) + 1)
    end

    function solve(btest::Bool = false)::Tuple{Any, Any};
        lines       = @getinputs(btest);
        (m1, m2)    = parse_inputs(lines)

        part1       = solve_common(m1);
        part2       = solve_common(m2);

        return (part1, part2);
    end

    # @time (part1, part2) = solve(true); # Test
    @time (part1, part2) = solve();
    println("\nPart 1 answer: $(part1)");
    println("\nPart 2 answer: $(part2)\n");
end
