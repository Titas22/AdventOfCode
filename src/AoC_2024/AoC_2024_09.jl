module AoC_2024_09
    using AdventOfCode;

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
lines = @getinputs(false)
diskmap = collect(lines[1]) .- '0'

# n 
function count_taken(diskmap)
    ntaken = 0;
    for ii = 1 : 2 : length(diskmap)
        ntaken += diskmap[ii]
    end
    return ntaken;
end

ntaken = count_taken(diskmap)

ntotal = sum(diskmap)

disk = zeros(Int, ntotal) .- 1

idx = diskmap[1]
disk[1:idx] .= 0

for ii = 2 : 2 : length(diskmap)
    global idx
    global disk
    idx += diskmap[ii]
    disk[idx+1 : idx+diskmap[ii+1]] .= ii ÷ 2
    idx += diskmap[ii+1]
end

ii, jj = (diskmap[1], ntotal)

# display(disk)

while ii < jj
    global disk, ii, jj
    # @printf("[%d] = %d     [%d] = %d\n", ii, disk[ii], jj, disk[jj])
    if disk[ii] != -1 
        ii += 1
        continue
    end

    if disk[jj] == -1
        jj -= 1
        continue
    end
    
    # @printf("Setting [%d] to %d\n", ii, disk[jj])
    disk[ii] = disk[jj]
    ii += 1
    jj -= 1

end
if ii == jj && disk[ii] == -1
    final = @view disk[1:ii-1]
else
    final = @view disk[1:jj]
end
# display(final)

tot = 0
for ii in eachindex(final)
    global tot
    tot += (ii-1) * final[ii]
end
println(tot)



# ii, jj = disk[1]+1, ntaken

# while ii < jj





# end


# compacted = zeros(Int, n)

# idx = diskmap[1]

# ii, jj = (0, n)
# while ii < jj


# for ii = 1 : diskmap[1]

