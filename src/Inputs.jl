@export macro getinputs(btest::Union{Symbol, Expr, Bool} = false, extra::AbstractString = "")
    calling_file = String(__source__.file);
    @assert(!startswith(calling_file, "REPL"), "Cannot use @getinputs macro from REPL. Use getinputs(day, year, btest).")
    ex = quote
        getinputs($(calling_file), $(esc(btest)), $(esc(extra)))
    end
    # @show ex
end

_time_to_puzzle_unlock(day::Integer, year::Integer=DEFAULT_YEAR)::Dates.Millisecond = (Dates.DateTime(year, 12, day) - (Dates.now(Dates.UTC) - TIMEZONE_OFFSET));
_is_puzzle_unlocked(day::Integer, year::Integer=DEFAULT_YEAR)::Bool = _time_to_puzzle_unlock(day, year) <= Dates.Millisecond(0);

_year_day_inputs_file(day::Integer, year::Integer, btest::Bool, extra::AbstractString = "")    = "in_$(year)--$(lpad(day,2,"0"))$(btest ? "_test" : "")$(extra).txt";
_year_day_inputs_path(day::Integer, year::Integer, btest::Bool, extra::AbstractString = "")        = joinpath(".", "inputs", string(year), _year_day_inputs_file(day, year, btest, extra));

@export create_empty_input_file(day::Integer, year::Integer = DEFAULT_YEAR, btest::Bool = false) = touch(_year_day_inputs_path(day, year, btest));

@export function get_day_year(filename::String)::Tuple{Int, Int}
    yydd = match(r"AoC_(\d\d\d\d)_(\d\d)", splitext(basename(filename))[1]);
    @assert(!=(yydd, nothing), "Wrong script file name format. Expected to be 'AoC_YY_DD.jl'")

    return (parse(Int, yydd[2]), parse(Int, yydd[1])); # (day, year)
end

@export getinputs(solution_file::String, btest::Bool = false, extra::AbstractString = "") = getinputs(get_day_year(solution_file)..., btest, extra);

@export function fast_readlines(filepath::String)::Vector{String}
    io = open(filepath, "r")
    lines = String[]  # Preallocate storage for lines
    while !eof(io)
        push!(lines, readline(io))  # Read lines directly
    end
    close(io)
    return lines
end

@export function getinputs(day::Integer, year::Integer = DEFAULT_YEAR, btest::Bool = false, extra::AbstractString = "")::Vector{String}
    filepath = _year_day_inputs_path(day, year, btest, extra);
    
    isfile(filepath) || _download_inputs(day, year, btest);
    
    return fast_readlines(filepath);
    # return readlines(filepath);
end

function _download_inputs(day::Integer, year::Integer, btest::Bool)
    _is_puzzle_unlocked(day, year) || Base.error("$(year) day $(day) has not been released yet - $(_time_to_puzzle_unlock(day, year)) left...")
    
    filepath = _year_day_inputs_path(day, year, btest);
    if btest
        create_empty_input_file(day, year, btest);
        Base.error("Cannot automatically download test inputs, paste manually to $(filepath)")
    end
    
    @warn(filepath)
    create_empty_input_file(day, year, btest);
    Base.error("Downloading inputs is not implemented yet.")
end
