module AoC_2024_25
    using AdventOfCode
    using StaticArrays

    struct Key
        heights::SVector{5, Int}
    end
    Key(charmat::SubArray{Char})::Key = Key(parse_heights(charmat))

    struct Lock
        heights::SVector{5, Int}
    end
    Lock(charmat::SubArray{Char})::Lock = Lock(parse_heights(charmat))

    function parse_heights(charmat::SubArray{Char})::SVector{5, Int}
        heights = MVector(0,0,0,0,0)
        for iCol in 1 : 5
            for iRow in 1 : 6
                charmat[iRow, iCol] == '#' && continue
                heights[iCol] = iRow - 1
                break
            end
        end

        return SVector{5, Int64}(heights)
    end

    function parse_inputs(lines::Vector{String})::Tuple{Vector{Key}, Vector{Lock}}
        blocks = split_at_empty_lines(lines)

        keys = Key[]
        sizehint!(keys, length(blocks))
        locks = Lock[]
        sizehint!(locks, length(blocks))
        
        idx_key = 6 : -1 : 1
        idx_lock = 2 : 7

        for block in blocks
            charmat = lines2charmat(block)
            if charmat[1, 1] == '.'
                x = @view charmat[idx_key,:]
                push!(keys, Key(x))
            else
                y = @view charmat[idx_lock,:]
                push!(locks, Lock(y))
            end
        end

        sort!(keys, by=x->x.heights)
        sort!(locks, by=x->x.heights)
        
        return (keys, locks)
    end

    function solve_part_1(keys::Vector{Key}, locks::Vector{Lock})
        nfits = 0
        for lock in locks
            for key in keys
                bfits = true
                hsum = key.heights[1] + lock.heights[1]
                hsum > 5 && break
                for ii in 2 : 5
                    hsum = key.heights[ii] + lock.heights[ii] 
                    hsum <= 5 && continue
                    bfits = false
                    break
                end
                bfits || continue
                nfits += 1
            end
        end

        return nfits;
    end

    function solve(btest::Bool = false)::Tuple{Any, Any}
        lines       = @getinputs(btest)
        (keys, locks) = parse_inputs(lines)

        part1       = solve_part_1(keys, locks)
        part2       = nothing

        return (part1, part2)
    end

    # @time (part1, part2) = solve(true); # Test
    @time (part1, part2) = solve()
    println("\nPart 1 answer: $(part1)")
    println("\nPart 2 answer: $(part2)\n")

    # @assert(part1 == 3146, "Part 1 is wrong")
end