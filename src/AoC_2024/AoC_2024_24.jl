module AoC_2024_24
    using AdventOfCode

    function parse_inputs(lines::Vector{String})

        return lines;
    end
    function solve_common(inputs)

        return inputs;
    end

    function solve_part_1(inputs)

        return nothing;
    end

    function solve_part_2(inputs)

        return nothing;
    end

    function solve(btest::Bool = false)::Tuple{Any, Any}
        lines       = @getinputs(btest);
        # lines2      = @getinputs(btest, "_2"); # Use if 2nd problem test case inputs are different
        inputs      = parse_inputs(lines);

        solution    = solve_common(inputs);
        part1       = solve_part_1(solution);
        part2       = solve_part_2(solution);

        return (part1, part2);
    end

    @time (part1, part2) = solve(true); # Test
    # @time (part1, part2) = solve();
    println("\nPart 1 answer: $(part1)");
    println("\nPart 2 answer: $(part2)\n");
end

lines = @getinputs(true)
blocks = split_at_empty_lines(lines)

init_block = blocks[1]

states = Dict{String, Bool}()
for line in init_block
    k = line[1:3]
    v = line[6] == '1'
    states[k] = v
end



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


gates_block = blocks[2]
op_list = LogicGate[]
sizehint!(op_list, length(gates_block))
for line in gates_block
    a = line[1:3]
    g = line[5]
    
    if g == 'O'
        offset = 8
        TGate = OrOp
    else
        offset = 9
        TGate = g == 'A' ? AndOp : XorOp
    end
    
    b = line[offset : offset + 2]

    c = line[offset+7 : end]

    push!(op_list, LogicGate(TGate, a, b, c))
end

op_list
completed = falses(length(op_list))

remaining = length(completed)

while remaining > 0
    global remaining
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
# bitval = BitArray([0, 0, 1])

Int(bitval.chunks[1])