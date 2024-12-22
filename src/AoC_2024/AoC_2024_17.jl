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

    dv(c::Computer, operand::Int)::Int = c.A ÷ 2^combo(c, operand)

    combomod8(c::Computer, operand::Int)::Int = mod(combo(c, operand), 8)

    # Opcode 0
    function adv!(c::Computer, operand::Int)
        c.A = dv(c, operand)
    end
    # Opcode 6
    function bdv!(c::Computer, operand::Int)
        c.B = dv(c, operand)
    end
    # Opcode 7
    function cdv!(c::Computer, operand::Int)
        c.C = dv(c, operand)
    end

    # Opcode 1
    function bxl(c::Computer, operand::Int)
        c.B = c.B ⊻ operand
    end

    # Opcode 2
    function bst!(c::Computer, operand::Int)
        c.B = combomod8(c, operand)
    end

    # Opcode 3
    function jnz!(c::Computer, operand::Int)
        c.A == 0 && return
        c.pointer = operand - 2;
    end

    # Opcode 4
    function bxc!(c::Computer, operand::Int)
        c.B = c.C ⊻ c.B
    end

    # Opcode 5
    function out!(c::Computer, operand::Int)
        push!(c.output, combomod8(c, operand))
    end

    const opcodes::Vector{Function} = [adv!; bxl; bst!; jnz!; bxc!; out!; bdv!; cdv!]

    function do_opcode!(c::Computer)
        opcode = c.program[c.pointer+1]
        operand = c.program[c.pointer+2]
        opcodes[opcode+1](c, operand)
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
        q::Queue{Int} = Queue{Int}()
        enqueue!(q, 0)
        while !isempty(q)
            prev = dequeue!(q)
            
            for ii in 0 : 7
                newA = prev*8 + ii
                c.A = newA

                c.program == run!(c) && return newA

                n = length(c.output) - 1
                c.program[end-n : end] == c.output || continue

                enqueue!(q, newA)
                # println("A = " * string(newA) * "(" * bitstring(newA) * ") -> " * string(c.output))
            end
        end
        return -1;
    end

    function solve(btest::Bool = false)::Tuple{Any, Any}
        lines       = @getinputs(btest);
        # lines2      = @getinputs(btest, "_2"); # Use if 2nd problem test case inputs are different
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
# 6,5,4,7,1,6,0,3,1
# 106086382266778