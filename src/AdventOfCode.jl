module AdventOfCode
    using Revise
    using Profile
    using BenchmarkTools
    using InlineExports
    
    import Dates

    include("Inputs.jl")

    export @getInputs;

    macro getInputs(bTestCase::Union{Symbol, Expr, Bool} = false)
        callingFile = String(__source__.file);
        @assert(!startswith(callingFile, "REPL"), "Cannot use @getInputs macro from REPL. Use getInputs(day, year, bTestCase).")
        ex = quote
            getInputs($(callingFile), $(esc(bTestCase)))
        end
        # @show ex
    end
end # module AdventOfCode
