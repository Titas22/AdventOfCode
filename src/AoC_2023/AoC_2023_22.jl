module AoC_2023_22
    using AdventOfCode;
    const AoC = AdventOfCode;

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

    function solve(btest::Bool = false)::Tuple{Any, Any};
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

struct Block
    from::CartesianIndex{3}
    to::CartesianIndex{3}
    supported_by::Set{Int}
    supports::Set{Int}
end
Block(from::CartesianIndex{3}, to::CartesianIndex{3})::Block = Block(from, to, Set{Int}(), Set{Int}())

function convert(::Type{T}, str::AbstractString)::T where T<:CartesianIndex{3}
    strnum = split.(str, ',')
    num::Tuple{Int, Int, Int} = Tuple(parse.(Int, strnum))
    idx = CartesianIndex(num[1]+1, num[2]+1, num[3])
    return idx
end
function Block(strfrom::AbstractString, strto::AbstractString)::Block
    a = convert(CartesianIndex{3}, strfrom)
    b = convert(CartesianIndex{3}, strto)

    from = min(a, b)
    to = max(a, b)
    return Block(from, to)
end

function parse_inputs(lines::Vector{String})::Vector{Block}
    strblocks = split.(lines, '~')
    return (x->Block(x[1], x[2])).(strblocks)
end

blocks = parse_inputs(lines)

import Base.isless, Base.max, Base.min;

Base.min(b::Block)::CartesianIndex{3} = min(b.from, b.to);
Base.max(b::Block)::CartesianIndex{3} = max(b.from, b.to);


function Base.isless(a::Block, b::Block)::Bool
    a_min = min(a)
    b_min = min(b)
    a_min[3] == b_min[3] || return isless(a_min[3], b_min[3])
    a_min[2] == b_min[2] || return isless(a_min[2], b_min[2])
    return isless(a_min[1], b_min[1])
end

function fall!(blocks::Vector{Block})::Array{Int, 3}
    issorted(blocks) || sort!(blocks)

    sz = Tuple(maximum((x->x.to).(blocks)))
    blockmat = zeros(Int, sz);
    for (ii, block) in enumerate(blocks)
        z = block.from[3]
        dz = block.to[3] - z

        indices = CartesianIndices((block.from[1]:block.to[1], block.from[2]:block.to[2]));

        while z > 1
            for idx in indices
                idx_support = blockmat[idx[1], idx[2], z-1];
                idx_support > 0 || continue
                push!(block.supported_by, idx_support)
            end
            isempty(block.supported_by) || break;
            z -= 1;
        end
        
        indices = CartesianIndices((block.from[1]:block.to[1], block.from[2]:block.to[2]));
        new_from = CartesianIndex(block.from[1], block.from[2], z);
        new_to = CartesianIndex(block.to[1], block.to[2], z+dz);
        blocks[ii] = Block(new_from, new_to, block.supported_by, Set{Int}());

        blockmat[new_from:new_to] .= ii;
    end

    for (ii, block) in enumerate(blocks)
        for jj in block.supported_by
            push!(blocks[jj].supports, ii)
        end
    end

    return blockmat
end

bmat = fall!(blocks)

blocks

function can_be_disintegrated(block::Block, blocks::Vector{Block})::Bool
    for ii in block.supports
        length(blocks[ii].supported_by) <= 1 && return false
    end
    return true
end

function count_safe_to_disintegrate(blocks::Vector{Block})::Int 
    n = 0;
    for block in blocks
        can_be_disintegrated(block, blocks) || continue;
        n += 1
    end
    return n;
end

count_safe_to_disintegrate(blocks)
