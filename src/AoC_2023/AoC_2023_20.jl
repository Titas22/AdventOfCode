module AoC_2023_20
    using AdventOfCode;
    using DataStructures;
    const AoC = AdventOfCode;

    abstract type Module end

    struct Broadcaster <: Module
        name::Symbol
        outputs::Vector{Module}
        Broadcaster(mods::Vector{Module}) = new(:broadcaster, mods);
    end

    struct Button <: Module
        name::Symbol
        outputs::Vector{Module}
        Button(b::Broadcaster) = new(:button, [b]);
    end

    struct Conjunction <: Module
        name::Symbol
        outputs::Vector{Module}

        memory::Dict{Symbol, Bool}
    end

    struct Undefined <: Module
        name::Symbol
    end
    struct SandMover <: Module
        name::Symbol
        b_received_low::Ref{Bool}
        SandMover(name::Symbol) = new(name, false);
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
    end

    reset_state!(m::Module) = return;
    function reset_state!(f::FlipFlop)
        f.state[] = false;
    end
    function reset_state!(c::Conjunction)
        for k in keys(c.memory)
            c.memory[k] = false;
        end
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
        
        for ms in module_symbols
            mod = modules[ms[1]]
            for sym in ms[2]
                if !haskey(modules, sym)
                    modules[sym] = sym == :rx ? SandMover(sym) : Undefined(sym);
                elseif isa(modules[sym], Conjunction)
                    modules[sym].memory[ms[1]] = false
                end
                
                push!(mod.outputs, modules[sym])
            end
        end

        modules[:button] = Button(modules[:broadcaster]);
        return modules;
    end

    process_signal!(q::Queue{Tuple{Module, Bool}}, m::Module, state::Bool) = error("Not implemented for $(typeof(m))")

    function process_signal!(q::Queue{Signal}, counter::Vector{Int}, m::Signal)

    end

    function send_signal!(q::Queue{Signal}, from::Module, to_all::Vector{Module}, signal::Bool)
        for to in to_all
            enqueue!(q, Signal(signal, from, to))
        end
    end

    send_signal!(q::Queue{Signal}, b::Button) = send_signal!(q, b, b.outputs, false);
    process_signal!(q::Queue{Signal}, u::Undefined, s::Signal) = return;
    process_signal!(q::Queue{Signal}, b::Broadcaster, s::Signal) = send_signal!(q, b, b.outputs, s.state);
    function process_signal!(q::Queue{Signal}, sm::SandMover, s::Signal) 
        s.state && return;
        sm.b_received_low[] = true;
    end
    function process_signal!(q::Queue{Signal}, f::FlipFlop, s::Signal) 
        s.state && return;
        f.state[] = !f.state[]
        send_signal!(q, f, f.outputs, f.state[]);
    end
    function process_signal!(q::Queue{Signal}, c::Conjunction, s::Signal)
        c.memory[s.from.name] = s.state;
        b_all_high = all(values(c.memory));
        send_signal!(q, c, c.outputs, !b_all_high);
    end

    function process_signal!(q::Queue{Signal}, counter::Vector{Int}, s::Signal)
        # println("$(s.from.name) -$(s.state ? "high" : "low")-> $(s.to.name)")
        if s.state
            counter[2] += 1
        else
            counter[1] += 1
        end
        process_signal!(q, s.to, s);
    end

    function press(b::Button, counter::Vector{Int})
        q = Queue{Signal}();
        send_signal!(q, b);

        while !isempty(q)
            s = dequeue!(q);
            process_signal!(q, counter, s)
        end
        return counter;
    end
    
    function solve_part_1(modules)
        button = modules[:button];
        counter = [0, 0]
        [press(button, counter) for _ in 1 : 1000]
        return prod(counter);
    end

    function solve_part_2(modules)
        return nothing;

        button = modules[:button];
        sand_mover = modules[:rx];
        counter = 0;
        while !sand_mover.b_received_low[]
            press(button, [0, 0])
            counter += 1
        end

        return counter;
    end

    function solve(btest::Bool = false)::Tuple{Any, Any};
        lines       = @getinputs(btest);
        # lines      = @getinputs(btest, "_2"); # Use if 2nd problem test case inputs are different
        modules      = parse_inputs(lines);
        
        part1       = solve_part_1(modules);
        reset_state!.(values(modules))
        part2       = solve_part_2(modules);

        return (part1, part2);
    end

    # @time (part1, part2) = solve(true); # Test
    @time (part1, part2) = solve();
    println("\nPart 1 answer: $(part1)");
    println("\nPart 2 answer: $(part2)\n");
end