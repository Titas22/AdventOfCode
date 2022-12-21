const DEFAULT_YEAR = Dates.year(Dates.today());


const TIMEZONE_OFFSET = Dates.Hour(5); # Advent of Code problem is available @ midnight EST (UTC-5)
_timeToPuzzleUnlock(day::Integer, year::Integer=DEFAULT_YEAR)::Dates.Millisecond = (Dates.DateTime(year, 12, day) - (Dates.now(Dates.UTC) - TIMEZONE_OFFSET));
_isPuzzleUnlocked(day::Integer, year::Integer=DEFAULT_YEAR)::Bool = _timeToPuzzleUnlock(day, year) <= Dates.Millisecond(0);

_yearDayInputsFileName(day::Integer, year::Integer, bTestCase::Bool)    = "in_$(year)--$(lpad(day,2,"0"))$(bTestCase ? "_test" : "").txt";
_yearDayInputsPath(day::Integer, year::Integer, bTestCase::Bool)        = joinpath(".", "inputs", string(year), _yearDayInputsFileName(day, year, bTestCase));

@export createEmptyInputFile(day::Integer, year::Integer = DEFAULT_YEAR, bTestCase::Bool = false) = touch(_yearDayInputsPath(day, year, bTestCase));

@export function getDayYear(filename::String)::Tuple{Int, Int}
    yydd = match(r"AoC_(\d\d)_(\d\d)", splitext(basename(filename))[1]);
    @assert(!=(yydd, nothing), "Wrong script file name format. Expected to be 'AoC_YY_DD.jl'")

    return (parse(Int, yydd[2]), 2000 + parse(Int, yydd[1])); # (day, year)
end

@export getInputs(solutionFile::String, bTestCase::Bool = false) = getInputs(getDayYear(solutionFile)..., bTestCase);

@export function getInputs(day::Integer, year::Integer = DEFAULT_YEAR, bTestCase::Bool = false)::Vector{String}
    filepath = _yearDayInputsPath(day, year, bTestCase);
    
    isfile(filepath) || _downloadInputs(day, year, bTestCase);
    
    return readlines(filepath);a
end

function _downloadInputs(day::Integer, year::Integer, bTestCase::Bool)
    _isPuzzleUnlocked(day, year) || Base.error("$(year) day $(day) has not been released yet - $(_timeToPuzzleUnlock(day, year)) left...")
    
    if bTestCase
        createEmptyInputFile(day, year, bTestCase);
        Base.error("Cannot automatically download test inputs, paste manually to $(filepath)")
    end
    filepath = _yearDayInputsPath(day, year, bTestCase);
    @warn(filepath)
    Base.error("Downloading inputs is not implemented yet.")
end
    

    