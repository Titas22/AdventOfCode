module AoC_2024_09
    using AdventOfCode;

    function parse_inputs(lines::Vector{String})
        diskmap = collect(lines[1]) .- '0'

        disk = zeros(Int, sum(diskmap)) .- 1

        idx = diskmap[1]
        disk[1:idx] .= 0

        spaces = Tuple{Int, Int}[] # (index, size)
        blocks = Tuple{Int, Int, Int}[(1, diskmap[1], 0)] # (index, size, ID)
        for ii = 2 : 2 : length(diskmap)
            diskmap[ii] != 0 && push!(spaces, (idx+1, diskmap[ii]))
            idx += diskmap[ii]
            disk[idx+1 : idx+diskmap[ii+1]] .= ii ÷ 2

            push!(blocks, (idx+1, diskmap[ii+1], ii ÷ 2))
            idx += diskmap[ii+1]
        end
        return (disk, blocks, spaces, sum(diskmap));
    end

    function solve_part_1(disk, disk_size)
        ii, jj = (findfirst(x -> x == -1, disk)-1, disk_size)

        while ii < jj
            if disk[ii] != -1 
                ii += 1
                continue
            end
        
            if disk[jj] == -1
                jj -= 1
                continue
            end
            
            disk[ii] = disk[jj]
            ii += 1
            jj -= 1
        end
        
        if ii == jj && disk[ii] == -1
            p1_disk = @view disk[1:ii-1]
        else
            p1_disk = @view disk[1:jj]
        end
        
        tot = 0
        for ii in eachindex(p1_disk)
            tot += (ii-1) * p1_disk[ii]
        end

        return tot;
    end

    insert_and_dedup!(v::Vector, x) = (splice!(v, searchsorted(v,x), [x]); v)

    block_lt(x::Tuple{Int, Int, Int}, y::Tuple{Int, Int, Int})::Bool = x[1] < y[1]

    function solve_part_2(blocks::Vector{Tuple{Int64, Int64, Int64}}, spaces::Vector{Tuple{Int64, Int64}})
        ii = jj = blocks[1][2]
        jj += 1
        
        newblocks = Tuple{Int, Int, Int}[] # (index, size, ID)
        while !isempty(blocks)
            (idx, sz, id) = pop!(blocks)
            
            for ii in eachindex(spaces)
                spaces[ii][2] < sz && continue;
                spaces[ii][1] < idx || break;
        
                idx = spaces[ii][1]
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
        
        sort!(newblocks; lt=block_lt)
        
        tot = 0
        for block in newblocks
            tot += sum(block[3] .* ((1 : block[2]) .+ (block[1] - 2)))
        end
        return tot;
    end

    function solve(btest::Bool = false)::Tuple{Any, Any}
        lines       = @getinputs(btest);
        (disk, blocks, spaces, disk_size) = parse_inputs(lines);

        part1       = solve_part_1(disk, disk_size);
        part2       = solve_part_2(blocks, spaces);

        return (part1, part2);
    end

    # @time (part1, part2) = solve(true); # Test
    @time (part1, part2) = solve();
    println("\nPart 1 answer: $(part1)");
    println("\nPart 2 answer: $(part2)\n");
end