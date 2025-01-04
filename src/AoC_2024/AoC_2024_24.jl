module AoC_2024_24
    using AdventOfCode
    using Parsers

    # Define gate operations as functors
    abstract type Op end
    struct AndOp<:Op end
    struct XorOp<:Op end
    struct OrOp<:Op end
    (::AndOp)(x, y) = x && y
    (::XorOp)(x, y) = x ⊻ y
    (::OrOp)(x, y) = x || y

    struct LogicGate{Op, T<:String}
        in1::T
        in2::T
        out::T
    end
    LogicGate(::Type{Op}, in1::T, in2::T, out::T) where {Op, T<:String} = LogicGate{Op, T}(in1, in2, out)

    function try_gate_op!(states::Dict{T, Bool}, g::LogicGate{TOp, T})::Bool where {TOp<:Op, T<:String}
        haskey(states, g.in1) && haskey(states, g.in2) || return false
        states[g.out] = TOp()(states[g.in1], states[g.in2])
        return true
    end

    function parse_inputs(lines::Vector{String})::Tuple{Dict{String, Bool}, Vector{LogicGate}}
        blocks = split_at_empty_lines(lines)
        init_block = blocks[1]
        gates_block = blocks[2]
        
        states = Dict{String, Bool}()
        for line in init_block
            k = line[1:3]
            v = line[6] == '1'
            states[k] = v
        end        
        
        op_list = LogicGate[]
        sizehint!(op_list, length(gates_block))
        for line in gates_block
            in1 = line[1:3]
            g = line[5]
            if g == 'O'
                offset = 8
                TGate = OrOp
            else
                offset = 9
                TGate = g == 'A' ? AndOp : XorOp
            end
            
            in2 = line[offset : offset + 2]
            out = line[offset+7 : end]
            push!(op_list, LogicGate(TGate, in1, in2, out))
        end

        return (states, op_list)
    end

    function run_gates(states::Dict{String, Bool}, op_list::Vector{LogicGate})::BitArray
        completed = falses(length(op_list))
        remaining = length(completed)
        while remaining > 0
            for idx in eachindex(op_list)
                completed[idx] && continue
    
                op = op_list[idx]
                try_gate_op!(states, op) || continue
    
                completed[idx] = true
                remaining -= 1
            end
        end
    
        bitval = falses(64)
        for (k, v) in states
            k[1] == 'z' || continue
            idx = Parsers.parse(Int, k[2:3])
            bitval[idx + 1] = v
        end
        return bitval
        return Int(bitval.chunks[1])
    end

    solve_part_1(states, op_list) = Int(run_gates(states, op_list).chunks[1])

    function solve_part_2(inputs)

        return nothing;
    end

    function solve(btest::Bool = false)::Tuple{Any, Any}
        lines               = @getinputs(btest)
        (states, op_list)   = parse_inputs(lines)
        println(typeof(op_list))
        part1       = solve_part_1(states, op_list)
        part2       = solve_part_2(op_list)

        return (part1, part2);
    end

    # @time (part1, part2) = solve(true); # Test
    @time (part1, part2) = solve();
    println("\nPart 1 answer: $(part1)");
    println("\nPart 2 answer: $(part2)\n");

    @assert(part1 == 56939028423824, "Part 1 is wrong")
end