module AoC_2024_17
    using AdventOfCode
    using DataStructures
    using Parsers

    mutable struct Computer
        A::Int
        B::Int
        C::Int

        program::Vector{Int}
        pointer::Int

        output::Vector{Int}
    end
    Computer(regA::Int, regB::Int, regC::Int, prog::Vector{Int}) = Computer(regA, regB, regC, prog, 0, Int[])
    
    function combo(c::Computer, operand::Int)::Int
        operand < 4 && return operand
        operand == 4 && return c.A
        operand == 5 && return c.B
        operand == 6 && return c.C
        throw(BoundsError(operand, "reserved operand - should not appear in valid program"))
    end

    dv(c::Computer, operand::Int)::Int = c.A >> combo(c, operand) # = c.A ÷ 2^combo(c, operand)

    combomod8(c::Computer, operand::Int)::Int = combo(c, operand) & 7 # = mod(combo(c, operand), 8)

    # Opcode 3
    function jnz!(c::Computer, operand::Int)
        c.A == 0 && return
        c.pointer = operand - 2;
    end

    @inline function do_opcode!(c::Computer)
        @inbounds opcode = c.program[c.pointer+1]
        @inbounds operand = c.program[c.pointer+2]
        if opcode == 0
            setproperty!(c, :A, dv(c, operand)) # adv
        elseif opcode == 1 
            setproperty!(c, :B, c.B ⊻ operand) # bxl
        elseif opcode == 2
            setproperty!(c, :B, combomod8(c, operand)) # bst
        elseif opcode == 3
            jnz!(c, operand) # jnz
        elseif opcode == 4
            setproperty!(c, :B, c.C ⊻ c.B) # bxc
        elseif opcode == 5
            push!(c.output, combomod8(c, operand)) # out
        elseif opcode == 6
            setproperty!(c, :B, dv(c, operand)) # bdv
        else #if opcode == 7 
            setproperty!(c, :C, dv(c, operand)) # cdv
        end
        c.pointer += 2
    end

    function run!(c::Computer)::Vector{Int}
        c.pointer = c.B = c.C = 0;
        empty!(c.output)

        while c.pointer < length(c.program)
            do_opcode!(c)
        end

        return c.output
    end

    # parse_registry(line::AbstractString)::Int = Parsers.parse(Int, match(r"(?>\:\s)(\d+)",line)[1])
    parse_registry(line::AbstractString)::Int = Parsers.parse(Int, line[13:end])

    function parse_inputs(lines::Vector{String})
        regA = parse_registry(lines[1])
        regB = parse_registry(lines[2])
        regC = parse_registry(lines[3])
        prog = Parsers.parse.(Int, split(lines[5][10:end], ','))
        return Computer(regA, regB, regC, prog)
    end

    solve_part_1(c::Computer)::String = join(run!(c), ',')

    function solve_part_2(c::Computer)::Int
        q::Vector{Int} = [0]
        while !isempty(q)
            prev = popfirst!(q)
            for ii in 0 : 7
                newA = prev * 8 + ii
                c.A = newA

                c.program == run!(c) && return newA

                n = length(c.output)
                @inbounds all(c.program[end-n+ii] == c.output[ii] for ii in 1:n) || continue

                push!(q, newA)
                # println("A = " * string(newA) * "(" * bitstring(newA) * ") -> " * string(c.output))
            end
        end
        return -1;
    end

    function solve(btest::Bool = false)::Tuple{Any, Any}
        lines       = @getinputs(btest);
        computer    = parse_inputs(lines);

        part1       = solve_part_1(computer);
        part2       = solve_part_2(computer);

        return (part1, part2);
    end

    # @time (part1, part2) = solve(true); # Test
    @time (part1, part2) = solve();
    println("\nPart 1 answer: $(part1)");
    println("\nPart 2 answer: $(part2)\n");
end