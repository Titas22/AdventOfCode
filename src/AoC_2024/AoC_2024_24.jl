module AoC_2024_24
    using AdventOfCode
    using Parsers

    const GateStates = Dict{String, Bool}

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

    function try_gate_op!(states::GateStates, g::LogicGate{TOp, String})::Bool where {TOp<:Op}
        haskey(states, g.in1) && haskey(states, g.in2) || return false
        states[g.out] = TOp()(states[g.in1], states[g.in2])
        return true
    end

    function parse_inputs(lines::Vector{String})::Tuple{GateStates, Vector{LogicGate}}
        blocks = split_at_empty_lines(lines)
        init_block = blocks[1]
        gates_block = blocks[2]
        
        states = GateStates()
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

    function run_gates(states::GateStates, op_list::Vector{LogicGate})::BitArray
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
        return states2bitarray(states, 'z')
    end

    function states2bitarray(states::GateStates, varletter::Char = 'z')::BitArray
        bitval = varletter == 'z' ? falses(46) : falses(45)
        for (k, v) in states
            k[1] == varletter || continue
            idx = Parsers.parse(Int, k[2:3])
            bitval[idx + 1] = v
        end
        return bitval
    end

    solve_part_1(states, op_list) = bitarray2num(run_gates(states, op_list))

    num2bitarray(num::Int)::BitArray = BitArray(digits(num, base=2, pad=45))
    bitarray2num(b::BitArray)::Int = Int(b.chunks[1])
    function bitarray2states!(s::GateStates, barr::BitArray, varletter::Char)
        for (idx, val) in pairs(barr)
            k = varletter * lpad(idx, 2, '0')
            s[k] = val
        end
    end

    function add_numbers(op_list::Vector{LogicGate}, x::Int, y::Int)::Int
        xarr = num2bitarray(x)
        yarr = num2bitarray(y)
        states = GateStates()
        bitarray2states!(states, xarr, 'x')
        bitarray2states!(states, yarr, 'y')

        # zarr = run_gates(states, op_list)
        # println(zarr)
        # return Int(zarr.chunks[1])
        return 0
    end

    function check_gates(op_list::Vector{LogicGate}, rule::Function)::Vector{LogicGate}
        failed_gates = LogicGate[]
        for gate in op_list
            rule(gate) && push!(failed_gates, gate)
        end
        return failed_gates
    end

    input_startswith(g::LogicGate, ch::Char)::Bool = g.in1[1] == ch || g.in2[1] == ch
    isgatetype(::LogicGate{TOp, String}, t::Type{<:Op}) where {TOp<:Op} = TOp == t
    is_z(g::LogicGate)::Bool = g.out[1] == 'z' 

    function is_input_to_type(op_list::Vector{LogicGate}, g::LogicGate, t::Type{<:Op})::Bool
        for op in op_list
            op.in1 == g.out || op.in2 == g.out || continue
            typeof(op) == LogicGate{t, String} || continue
            return true
        end
        return false
    end

    function count_inputs(op_list::Vector{LogicGate}, g::LogicGate)::Bool
        for op in op_list
            (op.in1 == g.out || op.in2 == g.out) && continue
            typeof(op) == LogicGate{t, String} || continue
            return true
        end
        return false
    end

    function add_input!(inputs::Dict{String, Vector{Int}}, input::String, idx::Int)
        if !haskey(inputs, input)
            inputs[input] = [idx]
        else
            push!(inputs[input], idx)
        end
    end

    function find_input_output_list(op_list::Vector{LogicGate})::Tuple{Dict{String, Vector{Int}}, Dict{String, Int}}
        inputs = Dict{String, Vector{Int}}()
        outputs = Dict{String, Int}()
        
        for (idx, op) in pairs(op_list)
            outputs[op.out] = idx
            add_input!(inputs, op.in1, idx)
            add_input!(inputs, op.in2, idx)
        end

        return (inputs, outputs)
    end

    function find_input_gate_outputs(gates::SubArray{LogicGate})::Tuple{LogicGate{XorOp, String}, LogicGate{AndOp, String}}
        if typeof(gates[1]) == LogicGate{XorOp, String}
            return (gates[1], gates[2])
        else
            return (gates[2], gates[1])
        end
    end

    function find_faulty_gates(op_list::Vector{LogicGate})::Set{LogicGate}
        faulty_outputs = Set{LogicGate}()
        (inputs, outputs) = find_input_output_list(op_list)


        (zxor, carry_and) = find_input_gate_outputs(@view op_list[inputs["x00"]])

        if zxor.out != "z00"
            push!(faulty_outputs, "z00")
        end

        # XOR = A ⊻ B
        # S = XOR ⊻ C0
        # C1 = (A && B) || (C0 && XOR)

        for ii in 1 : 44
            numstr = lpad(ii, 2, '0')
            (partial_sum_xor, partial_carry_and_1) = find_input_gate_outputs(@view op_list[inputs['x' * numstr]])

            a = get(inputs, partial_sum_xor.out, Int[])
            length(a) == 2 || push!(faulty_outputs, partial_sum_xor)

            b = get(inputs, partial_carry_and_1.out, Int[])
            length(b) == 1 || push!(faulty_outputs, partial_carry_and_1)
            
            # + Find the XOR gate and the AND gate that the input is connected to. (This is a hard assumption - it's gate outputs that are mixed up, not gate inputs, so this should always be true.)
            # + The XOR gate should fork its output to two other gates. If it doesn't, it's one of the miswired ones.
            # + The AND gate should send its output to one other gate. If it doesn't, it's one of the miswired ones.
            # One of the gates below those two is another XOR gate. It should output to a Z wire. If it doesn't, it's one of the miswired ones.
            # Another of the gates below those is another AND gate. It should output to a single OR gate. If it doesn't, it's one of the miswired ones.
            # The final one of the three gates should be an OR gate (though we might not find it if one of the earlier gates was miswired). If we do find it, it should output to an XOR gate and an AND gate. If it doesn't, it's one of the miswired ones.
            

            zoutput = op_list[outputs['z' * numstr]]

            partial_sum_xor.out[1] == 'z' && push!(faulty_outputs, partial_sum_xor)
            partial_carry_and_1.out[1] == 'z' && push!(faulty_outputs, partial_carry_and_1)
            typeof(zoutput) == LogicGate{XorOp, String} || push!(faulty_outputs, zoutput)

            # S = partial_sum_xor
            # prev_and = input_and
            # length(inputs[S.out]) == 2 || push!(faulty_outputs, S)

            # length(inputs[prev_and.out]) == 1 || push!(faulty_outputs, prev_and)
        end
        
        zfinal = op_list[outputs["z45"]]
        # typeof(zfinal) == LogicGate{XorOp, String} || push!(faulty_outputs, zfinal)
        typeof(zfinal) == LogicGate{OrOp, String} || push!(faulty_outputs, zfinal)




        for g in op_list
            isgood = true
            if (is_z(g) && !isgatetype(g, XorOp))
                # isgood = false
            elseif !is_z(g) && !input_startswith(g, 'x') && !input_startswith(g, 'y') && isgatetype(g, XorOp)
                isgood = false
            elseif is_z(g) && (input_startswith(g, 'x') || input_startswith(g, 'y')) && g.in1[2:3] != "00" && g.in2[2:3] != "00" && g.out[2:3] != "00"
                # isgood = false
            elseif !input_startswith(g, 'x') && !input_startswith(g, 'y') && !is_z(g)
                if isgatetype(g, AndOp) && !is_input_to_type(op_list, g, OrOp)
                    # isgood = false
                elseif isgatetype(g, XorOp) && is_input_to_type(op_list, g, OrOp)
                    # isgood = false
                elseif isgatetype(g, OrOp) && is_input_to_type(op_list, g, OrOp)
                    # isgood = false
                end
            end

            # if false && isgatetype(g, AndOp) && !is_input_to_type(op_list, g, OrOp)
            #     isgood = false
            # elseif false && isgatetype(g, XorOp) && is_input_to_type(op_list, g, OrOp)
            #     isgood = false
            # elseif false && isgatetype(g, OrOp) && is_input_to_type(op_list, g, OrOp)
            #     isgood = false
            # end

            isgood && continue
            push!(faulty_outputs, g)
            # length(faulty_outputs) == 8 && break
        end

        return faulty_outputs
    end

    function solve_part_2(op_list::Vector{LogicGate})
        faulty_outputs = find_faulty_gates(op_list)

        if length(faulty_outputs) != 8
            @info("Some rule is missing for a full solution below is the list of faulty gates:")
            [println(x) for x in faulty_outputs]
            println("")
            return ""
        end
        

        # [println(x) for x in op_list if x.out[1] == 'z' && typeof(x) != LogicGate{XorOp, String}]
        # # Main.AoC_2024_24.LogicGate{Main.AoC_2024_24.AndOp, String}("bkq", "jhv", "z39")
        # # Main.AoC_2024_24.LogicGate{Main.AoC_2024_24.OrOp, String}("vrj", "gkc", "z45")
        # # Main.AoC_2024_24.LogicGate{Main.AoC_2024_24.AndOp, String}("x21", "y21", "z21")
        # # Main.AoC_2024_24.LogicGate{Main.AoC_2024_24.OrOp, String}("srp", "jcf", "z05")
        # println("")

        # [println(x) for x in op_list if x.out[1] != 'z' && x.in1[1] != 'x' && x.in2[1] != 'x' && x.in1[1] != 'y' && x.in2[1] != 'y' && typeof(x) == LogicGate{XorOp, String}]
        # # Main.AoC_2024_24.LogicGate{Main.AoC_2024_24.XorOp, String}("jhv", "bkq", "wtt")
        # # Main.AoC_2024_24.LogicGate{Main.AoC_2024_24.XorOp, String}("qjq", "kbj", "frn")
        # # Main.AoC_2024_24.LogicGate{Main.AoC_2024_24.XorOp, String}("mjj", "fqr", "gmq")
        # println("")

        # [println(x) for x in op_list if x.out[1] == 'z' && (x.in1[1] == 'x' || x.in2[1] == 'x' || x.in1[1] == 'y' || x.in2[1] == 'y') && x.in1[2:3] != "00" && x.in2[2:3] != "00" && x.out[2:3] != "00"]
        # # Main.AoC_2024_24.LogicGate{Main.AoC_2024_24.AndOp, String}("x21", "y21", "z21")
        # println("")


        

        return join(sort((x->x.out).(faulty_outputs)), ',')
    end

    function solve(btest::Bool = false)::Tuple{Any, Any}
        lines               = @getinputs(btest)
        (states, op_list)   = parse_inputs(lines)
        
        part1       = solve_part_1(states, op_list)
        part2       = solve_part_2(op_list)

        return (part1, part2);
    end

    # @time (part1, part2) = solve(true); # Test
    @time (part1, part2) = solve();
    println("\nPart 1 answer: $(part1)");
    println("\nPart 2 answer: $(part2)\n");

    @assert(part1 == 56939028423824, "Part 1 is wrong")
    @assert(part2 == "frn,gmq,vtj,wnf,wtt,z05,z21,z39", "Part 2 is wrong")
end