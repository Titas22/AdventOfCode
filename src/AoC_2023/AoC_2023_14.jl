module AoC_2023_14
    using AdventOfCode;
    const AoC = AdventOfCode;

    rock_isless(x::Tuple{Int, Int}, y::Tuple{Int, Int})::Bool = (x[2] < y[2] || (x[2] == y[2] && x[1] < y[1]))
    
    hash_bits(v::Matrix{Bool}) = hash_bits(BitMatrix(v));
    function hash_bits(v::BitArray) 
        GC.@preserve v begin
            num = BigInt(; nbits = Int(8 * ceil(length(v) / 8)))
            limbs = num.alloc
            ptr = Base.GMP.MPZ.limbs_write!(num, limbs)
            unsafe_copyto!(ptr, pointer(v.chunks), length(v.chunks))
            Base.GMP.MPZ.limbs_finish!(num, -limbs)
            return num
        end
    end

    function rotr90!(dst::AbstractMatrix, src::AbstractMatrix)
        ind1, ind2 = axes(src)
        m = first(ind1)+last(ind1)
        for i = ind1, j = ind2
            dst[j,m-i] = src[i,j]
        end
    end

    function parse_inputs(lines::Vector{String})
        nrows = size(lines, 1);
        ncols = length(lines[1]);
        statemat = collect(falses(nrows, ncols));
        fixed_rocks = Tuple([Tuple{Int, Int}[] for _ in 1 : 4])

        for irow in axes(statemat, 1)
            line = lines[irow];
            for icol in axes(statemat, 2)
                ch = line[icol];
                ch == '.' && continue
                if ch == 'O'
                    statemat[irow, icol] = true;
                    continue;
                end
                push!(fixed_rocks[1], (irow, icol));
                push!(fixed_rocks[2], (icol, nrows+1-irow));
                push!(fixed_rocks[3], (nrows+1-irow, ncols+1-icol));
                push!(fixed_rocks[4], (ncols+1-icol, irow));
            end
        end
        
        sort!.(fixed_rocks, lt = rock_isless)
        return (statemat, fixed_rocks);
    end
    
    function get_next_stop(rocks::Vector{Tuple{Int, Int}}, nrows::Int, idx::Int, icol::Int)::Tuple{Int, Int, Bool}
        idx > size(rocks, 1) && return (nrows+1, idx, true);
        @inbounds (next, nextcol) = rocks[idx]
        nextcol > icol && return (nrows+1, idx, true);
        next > nrows && return (next, idx, true);
        return (next, idx+1, false);
    end

    function tilt_north!(statemat, cube_rocks_v)
        rock_counter = 1;
        nrows = size(statemat, 1);
        (next, rock_counter) = get_next_stop(cube_rocks_v, nrows, rock_counter, 0);

        for icol in axes(statemat, 2)
            current = 0;
            (next, rock_counter, bend) = get_next_stop(cube_rocks_v, nrows, rock_counter, icol);

            while true
                if current+1 < next-1
                    ntoflip = 0
                    @inbounds for ii in current+1 : next-1
                        statemat[ii, icol] || continue;
                        ntoflip+=1;
                    end    
                    @inbounds statemat[current+1 : current+ntoflip, icol] .= true;
                    @inbounds statemat[current+ntoflip+1 : next-1, icol] .= false;
                end
                bend && break;
                current = next;
                (next, rock_counter, bend) = get_next_stop(cube_rocks_v, nrows, rock_counter, icol);
            end
        end
    
        return statemat;
    end

    function cycle!(statemat::Matrix{Bool}, statematT::Matrix{Bool}, fixed_rocks::Tuple)
        tilt_north!(statemat, fixed_rocks[1])
        rotr90!(statematT, statemat);
        
        tilt_north!(statematT, fixed_rocks[2])
        rotr90!(statemat, statematT);
        
        tilt_north!(statemat, fixed_rocks[3])
        rotr90!(statematT, statemat);
        
        tilt_north!(statematT, fixed_rocks[4])
        rotr90!(statemat, statematT);
    end

    function get_score(statemat::Matrix{Bool})::Int
        round_locations = findall(statemat);
        loads = (x->size(statemat, 1)+1-x[1]).(round_locations)
        return sum(loads)
    end

    function solve_part_1(statemat::Matrix{Bool}, fixed_rocks::Vector{Tuple{Int, Int}})::Int
        tilt_north!(statemat, fixed_rocks);
        return get_score(statemat);
    end

    function solve_part_2(statemat::Matrix{Bool}, fixed_rocks::Tuple)
        cache           = Dict{BigInt, Int}(hash_bits(statemat) => 0);
        statematT       = permutedims(statemat);
        nextra, ncycles = 0, Int(1e9);
        for ii in 1 : ncycles
            cycle!(statemat, statematT, fixed_rocks)
            h = hash_bits(statemat);
            if haskey(cache, h)
                period = ii - cache[h];
                nextra = (ncycles - ii) % period
                break
            end
            cache[h] = ii;
        end
    
        [cycle!(statemat, statematT, fixed_rocks) for _ in 1 : nextra]
    
        return get_score(statemat);
    end

    function solve(btest::Bool = false)::Tuple{Any, Any};
        lines       = @getinputs(btest);
        (statemat, fixed_rocks) = parse_inputs(lines);

        part1       = solve_part_1(copy(statemat), fixed_rocks[1]);
        part2       = solve_part_2(copy(statemat), fixed_rocks);

        return (part1, part2);
    end

    # @time (part1, part2) = solve(true); # Test
    @time (part1, part2) = solve();
    println("\nPart 1 answer: $(part1)");
    println("\nPart 2 answer: $(part2)\n");
end
