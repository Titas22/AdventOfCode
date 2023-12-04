
@export macro getInputs(bTestCase::Union{Symbol, Expr, Bool} = false, extra::AbstractString = "")
    callingFile = String(__source__.file);
    @assert(!startswith(callingFile, "REPL"), "Cannot use @getInputs macro from REPL. Use getInputs(day, year, bTestCase).")
    ex = quote
        getInputs($(callingFile), $(esc(bTestCase)))
    end
    # @show ex
end

_timeToPuzzleUnlock(day::Integer, year::Integer=DEFAULT_YEAR)::Dates.Millisecond = (Dates.DateTime(year, 12, day) - (Dates.now(Dates.UTC) - TIMEZONE_OFFSET));
_isPuzzleUnlocked(day::Integer, year::Integer=DEFAULT_YEAR)::Bool = _timeToPuzzleUnlock(day, year) <= Dates.Millisecond(0);

_yearDayInputsFileName(day::Integer, year::Integer, bTestCase::Bool, extra::AbstractString = "")    = "in_$(year)--$(lpad(day,2,"0"))$(bTestCase ? "_test" : "")$(extra).txt";
_yearDayInputsPath(day::Integer, year::Integer, bTestCase::Bool, extra::AbstractString = "")        = joinpath(".", "inputs", string(year), _yearDayInputsFileName(day, year, bTestCase, extra));

@export createEmptyInputFile(day::Integer, year::Integer = DEFAULT_YEAR, bTestCase::Bool = false) = touch(_yearDayInputsPath(day, year, bTestCase));

@export function getDayYear(filename::String)::Tuple{Int, Int}
    yydd = match(r"AoC_(\d\d\d\d)_(\d\d)", splitext(basename(filename))[1]);
    @assert(!=(yydd, nothing), "Wrong script file name format. Expected to be 'AoC_YY_DD.jl'")

    return (parse(Int, yydd[2]), parse(Int, yydd[1])); # (day, year)
end

@export getInputs(solutionFile::String, bTestCase::Bool = false, extra::AbstractString = "") = getInputs(getDayYear(solutionFile)..., bTestCase, extra);

@export function getInputs(day::Integer, year::Integer = DEFAULT_YEAR, bTestCase::Bool = false, extra::AbstractString = "")::Vector{String}
    filepath = _yearDayInputsPath(day, year, bTestCase, extra);
    
    isfile(filepath) || _downloadInputs(day, year, bTestCase);
    
    return readlines(filepath);
end

function _downloadInputs(day::Integer, year::Integer, bTestCase::Bool)
    _isPuzzleUnlocked(day, year) || Base.error("$(year) day $(day) has not been released yet - $(_timeToPuzzleUnlock(day, year)) left...")
    
    filepath = _yearDayInputsPath(day, year, bTestCase);
    if bTestCase
        createEmptyInputFile(day, year, bTestCase);
        Base.error("Cannot automatically download test inputs, paste manually to $(filepath)")
    end
    
    @warn(filepath)
    Base.error("Downloading inputs is not implemented yet.")
end
    

    