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

# spaces = [Int[] for ii = 1 : 9]
# blocks = [Int[] for ii = 1 : 9]
spaces = Tuple{Int, Int}[] # (index, size)
blocks = Tuple{Int, Int, Int}[(1, diskmap[1], 0)] # (index, size, ID)
for ii = 2 : 2 : length(diskmap)
    global idx
    global disk
    # diskmap[ii] != 0 && push!(spaces, (idx+1, diskmap[ii]))
    if diskmap[ii] != 0 
        @printf("Adding space: idx=%d, sz=%d\n", idx+1, diskmap[ii])
        push!(spaces, (idx+1, diskmap[ii]))
    end
    idx += diskmap[ii]
    disk[idx+1 : idx+diskmap[ii+1]] .= ii ÷ 2

    push!(blocks, (idx+1, diskmap[ii+1], ii ÷ 2))
    # push!(blocks[diskmap[ii+1]], idx+1)
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

function checksum(final)
    tot = 0
    for ii in eachindex(final)
        tot += (ii-1) * final[ii]
    end
    return tot
end

if ii == jj && disk[ii] == -1
    p1_disk = @view disk[1:ii-1]
else
    p1_disk = @view disk[1:jj]
end
part1 = checksum(p1_disk)
display(part1) #6435922584968


ii = jj = diskmap[1]
jj += 1

insert_and_dedup!(v::Vector, x) = (splice!(v, searchsorted(v,x), [x]); v)

newblocks = Tuple{Int, Int, Int}[] # (index, size, ID)
println("Blocks:")
display(blocks)
println("Spaces:")
display(spaces)


while !isempty(blocks)
    (idx, sz, id) = pop!(blocks)
    # @printf("Processing: block #%d (idx=%d, sz=%d)\n", id, idx, sz)
    # println("Blocks:")
    # display(blocks)
    # println("Spaces:")
    # display(spaces)
    for ii in eachindex(spaces)
        spaces[ii][2] < sz && continue;


        spaces[ii][1] < idx || break;

        idx = spaces[ii][1]
        # @printf("Moving to space %d (idx=%d). Org sz=%d, new=%d\n", ii, idx, s)
        remspace = spaces[ii][2] - sz
        if remspace == 0
            deleteat!(spaces, ii)
        else
            spaces[ii] = (idx+sz, remspace)
        end
        break;
    end

    push!(newblocks, (idx, sz, id))
end

block_lt(x::Tuple{Int, Int, Int}, y::Tuple{Int, Int, Int})::Bool = x[1] < y[1]
sort!(newblocks; lt=block_lt)

display(newblocks)

tot = 0
for block in newblocks
    global tot
    tot += sum(block[3] .* ((1 : block[2]) .+ (block[1] - 2)))
end
println(tot)