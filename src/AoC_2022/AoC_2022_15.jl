module AoC_2022_15
    using AdventOfCode;
    const AoC = AdventOfCode;

    # using Parameters
    
    abstract type CoordObj end

    struct Beacon <: CoordObj
        x::Int
        y::Int
    end
    struct Sensor <: CoordObj
        x::Int
        y::Int
        beacon::Ref{Beacon}
    end

    extractCoords(line::String)::Vector{Int}    = parse.(Int, match(r"Sensor at x=([-+]?\d+), y=([-+]?\d+): closest beacon is at x=([-+]?\d+), y=([-+]?\d+)", line).captures)
    
    parseInputs(lines::Vector{String})::Tuple{Vector{Sensor}, Vector{Beacon}} = (x->(first.(inputs), last.(inputs)))(parseInput.(lines));
    
    function parseInput(line::String)::Tuple{Sensor, Beacon}
        coords = extractCoords(line);
        beacon = Beacon(coords[3:4]...);
        
        return (Sensor(coords[1:2]..., Ref(beacon)), beacon);
    end

    parseInputs(lines::Vector{String})::Tuple{Vector{Sensor}, Vector{Beacon}} = (inputs->(first.(inputs), last.(inputs)))(parseInput.(lines));
    

    distance(x1::Int, y1::Int, x2::Int, y2::Int)::Int   = abs(x2-x1) + abs(y2-y1);
    distanceToBeacon(s::Sensor)::Int                    = distance(s.x, s.y, s.beacon[].x, s.beacon[].y);

    function solveCommon(inputs)

        return inputs;
    end

    function solvePart1(sensors::Vector{Sensor}, beacons::Vector{Beacon}, yRow::Int)::Int
        cantBe = UnitRange{Int64}[];
        sizehint!(cantBe, length(sensors))
        for s in sensors
            d = distanceToBeacon(s) - abs(s.y - yRow);
            d >= 0 || continue;
            
            push!(cantBe, (s.x-d) : (s.x+d))
        end
        println("here: ")
        @time cantBe = vcat(cantBe...);
        @time unique!(cantBe);
        @time setdiff!(cantBe, (b->b.x).(beacons[(b->b.y == yRow).(beacons)]));

        return length(cantBe);
    end

    function solvePart2(inputs)

        return nothing;
    end

    function solve(bTestCase::Bool = false)::Tuple{Any, Any};
        lines               = @getInputs(bTestCase);
        (sensors, beacons)  = parseInputs(lines);
        # solution    = solveCommon(inputs);

        part1       = solvePart1(sensors, beacons, bTestCase ? 10 : 200000);
        part2       = solvePart2(sensors);

        return (part1, part2);
    end

    @time (part1, part2) = solve(true); # Test
    @time (part1, part2) = solve();
    println("\nPart 1 answer: $(part1)");
    println("\nPart 2 answer: $(part2)");
end

lines = @getInputs false
yRow = 2000000

(sensors, beacons)  = parseInputs(lines);
println("")
# 5298716 - too low