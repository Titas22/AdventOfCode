module AoC_2023_13
    using AdventOfCode;
    const AoC = AdventOfCode;

    function strvec2bitmat(a::Vector{<:AbstractString})::BitMatrix
        bm = trues(size(a, 1), length(a[1]))
        for ii in axes(bm, 1)
            l = a[ii]
            for jj in axes(bm, 2)
                l[jj] == '.' || continue
                bm[ii, jj] = false
            end
        end
        return bm
    end
    
    struct Block
        matrix::BitMatrix
    end
    Block(lines::Vector{<:AbstractString})::Block = Block(strvec2bitmat(lines));
    
    function create_blocks(lines::Vector{<:AbstractString})::Vector{Block}
        idxSplit = [0; findall(isempty.(lines)); size(lines, 1)+1]
        
        blocks = Block[]
        sizehint!(blocks, size(idxSplit, 1)-1)
        for idx in eachindex(idxSplit[1:end-1])
            push!(blocks, Block(lines[idxSplit[idx]+1 : idxSplit[idx+1]-1]))
        end
        return blocks
    end

    function check_symmetry(bm::BitMatrix, n::Int, nflip::Int)::Bool
        n % 2 == 0 || return false;
        nhalf = div(n,2);

        maxcount = nflip + 1;
        flipcount = 0;
        for (i1, i2) in zip(1:nhalf, n:-1:nhalf+1)
            for jj in axes(bm, 1)
                bm[jj, i1] == bm[jj, i2] && continue;
                flipcount += 1;
                flipcount < maxcount || return false;
            end
        end
        return flipcount == nflip;
    end
    
    function get_symmetry_column(bm::BitMatrix, nflip::Int)::Int
        maxcount = nflip + 1;
        for ii in size(bm, 2) : -1 : 2      
            n = 0;
            for jj in axes(bm, 1)
                bm[jj, 1] == bm[jj, ii] && continue;
                n += 1;
                n < maxcount || break;
            end
            n < maxcount || continue;
            check_symmetry(bm, ii, nflip) || continue
            return div(ii, 2)
        end
        return 0;
    end
    
    function find_symmetry_line(bm::BitMatrix, nflip::Int)::Int
        n = get_symmetry_column(bm, nflip);
        n == 0 || return n;

        reverse!(bm, dims=2)
        n = get_symmetry_column(bm, nflip);
        reverse!(bm, dims=2)
        return n != 0 ? size(bm, 2) - n : 0;
    end
    
    function find_symmetry_score(b::Block, nflip::Int = 0)::Int
        n = find_symmetry_line(b.matrix, nflip);
        n == 0 || return n;
    
        bm = permutedims(b.matrix)
        return find_symmetry_line(bm, nflip)*100;
    end

    function solve(btest::Bool = false)::Tuple{Any, Any};
        lines       = @getinputs(btest);
        blocks      = create_blocks(lines);

        part1       = sum(find_symmetry_score.(blocks));
        part2       = sum(find_symmetry_score.(blocks, 1));

        return (part1, part2);
    end

    # @time (part1, part2) = solve(true); # Test
    @time (part1, part2) = solve();
    println("\nPart 1 answer: $(part1)");
    println("\nPart 2 answer: $(part2)\n");
end
