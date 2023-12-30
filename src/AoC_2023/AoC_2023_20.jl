module AoC_2023_20
    using AdventOfCode;
    using DataStructures;
    const AoC = AdventOfCode;

    abstract type Module end

    struct Broadcaster <: Module
        name::Symbol
        outputs::Vector{Module}
        Broadcaster(mods::Vector{Module})::Broadcaster = new(:broadcaster, mods);
    end

    struct Button <: Module
        name::Symbol
        outputs::Vector{Module}
        Button(b::Broadcaster)::Button = new(:button, [b]);
    end

    struct Conjunction <: Module
        name::Symbol
        outputs::Vector{Module}
        first_low::Ref{Int}
        memory::Dict{Symbol, Bool}
        Conjunction(name::Symbol, outputs::Vector{Module}, memory::Dict{Symbol, Bool})::Conjunction = new(name, outputs, 0, memory);
    end

    function get_state(c::Conjunction, counter::Int)::Bool
        for val in values(c.memory)
            val && continue;
            if c.first_low[] == 0
                c.first_low[] = counter;
            end
            return false;
        end
        return true;
    end
        
    struct Undefined <: Module
        name::Symbol
    end
    struct SandMover <: Module
        name::Symbol
        input::Module
        SandMover(name::Symbol, input::Module)::SandMover = new(name, input);
    end

    struct FlipFlop <: Module
        name::Symbol
        outputs::Vector{Module}
        state::Ref{Bool}
    end

    struct Signal
        state::Bool
        from::Module
        to::Module
        button_press_counter::Int
    end

    function create_module(name::AbstractString)::Module
        name[1] == '%' && return FlipFlop(Symbol(name[2:end]), Module[], false);
        name[1] == '&' && return Conjunction(Symbol(name[2:end]), Module[], Dict{Symbol, Bool}());
        name == "broadcaster" && return Broadcaster(Module[]);
    end

    function parse_inputs(lines::Vector{String})::Dict{Symbol, Module}
        inputs = split.(lines, " -> ")
        module_symbols = Tuple{Symbol, Vector{Symbol}}[]
        modules = Dict{Symbol, Module}()
        
        for input in inputs
            mod = create_module(input[1]);
            modules[mod.name] = mod;
            out = Symbol.(split(input[2], ", "))
            push!(module_symbols, (mod.name, out))
        end

        rx_input_count = 0;
        for ms in module_symbols
            mod = modules[ms[1]]
            for sym in ms[2]
                if sym == :rx
                    rx_input_count += 1;
                end
                if !haskey(modules, sym)
                    modules[sym] = sym == :rx ? SandMover(sym, mod) : Undefined(sym);
                elseif isa(modules[sym], Conjunction)
                    modules[sym].memory[ms[1]] = false
                end
                push!(mod.outputs, modules[sym])
            end
        end
        @assert(rx_input_count == 1, "Expected only 1 input to :rx")

        modules[:button] = Button(modules[:broadcaster]);
        return modules;
    end


    reset_state!(m::Module) = return;
    function reset_state!(f::FlipFlop)
        f.state[] = false;
    end
    function reset_state!(c::Conjunction)
        for k in keys(c.memory)
            c.memory[k] = false;
        end
        c.first_low[] = 0;
    end


    function send_signal!(q::Queue{Signal}, from::Module, to_all::Vector{Module}, state::Bool, button_press_counter::Int)
        for to in to_all
            signal = Signal(state, from, to, button_press_counter)
            enqueue!(q, signal)
        end
    end

    send_signal!(q::Queue{Signal}, b::Button, button_press_counter::Int) = send_signal!(q, b, b.outputs, false, button_press_counter);
    process_signal!(q::Queue{Signal}, u::Undefined, s::Signal) = return;
    process_signal!(q::Queue{Signal}, b::Broadcaster, s::Signal) = send_signal!(q, b, b.outputs, s.state, s.button_press_counter);
    process_signal!(q::Queue{Signal}, sm::SandMover, s::Signal) = return;
    function process_signal!(q::Queue{Signal}, f::FlipFlop, s::Signal) 
        s.state && return;
        f.state[] = !f.state[]
        send_signal!(q, f, f.outputs, f.state[], s.button_press_counter);
    end
    function process_signal!(q::Queue{Signal}, c::Conjunction, s::Signal)
        c.memory[s.from.name] = s.state;
        send_signal!(q, c, c.outputs, !get_state(c, s.button_press_counter), s.button_press_counter);
    end

    function process_signal!(q::Queue{Signal}, counter::Vector{Int}, s::Signal)
        # println("$(s.from.name) -$(s.state ? "high" : "low")-> $(s.to.name)")
        counter[s.state ? 2 : 1] += 1
        process_signal!(q, s.to, s);
    end

    function press(b::Button, counter::Vector{Int}, button_press_counter::Int, q::Queue{Signal})
        send_signal!(q, b, button_press_counter);

        while !isempty(q)
            s = dequeue!(q);
            process_signal!(q, counter, s)
        end
        return counter;
    end
    
    function solve_part_1(modules)
        button = modules[:button];
        counter = [0, 0]
        q = Queue{Signal}();
        [press(button, counter, ii, q) for ii in 1 : 1000]
        return prod(counter);
    end

    function solve_part_2(modules)
        button::Button          = modules[:button];
        sand_mover::SandMover   = modules[:rx];
        
        counter = 0;
        nand_inputs = [modules[k] for k in keys(sand_mover.input.memory)]
        @assert(all(isa.(nand_inputs, Conjunction)), "Expected all nand_inputs to be of type Conjuction")

        lcm_counters = (x->x.first_low).(nand_inputs)
        
        q = Queue{Signal}();
        while any((x->x[] == 0).(lcm_counters))
            counter += 1
            press(button, [0, 0], counter, q)
        end
        
        return prod((x->x[]).(lcm_counters));
    end

    function solve(btest::Bool = false)::Tuple{Any, Any};
        lines       = @getinputs(btest);
        # lines      = @getinputs(btest, "_2"); # Use if 2nd problem test case inputs are different
        modules      = parse_inputs(lines);
        
        part1       = solve_part_1(modules);
        reset_state!.(values(modules))
        part2       = solve_part_2(modules);
        
        @assert(part1 == 898557000, "p1 wrong")
        @assert(part2 == 238420328103151, "p2 wrong")
        return (part1, part2);
    end

    # # @time (part1, part2) = solve(true); # Test
    @time (part1, part2) = solve();
    println("\nPart 1 answer: $(part1)");
    println("\nPart 2 answer: $(part2)\n");
end