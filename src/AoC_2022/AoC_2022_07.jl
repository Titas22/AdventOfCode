module AoC_2022_07
    using AdventOfCode;
    using DataStructures 
    
    struct _file
        name        ::String
        size        ::Integer
    end
    
    struct _dir
        parent      ::Union{Nothing, _dir}
        name        ::String
        children    ::Dict{String, Union{_dir, _file}}
    
        function _dir(_parent::Union{Nothing, _dir}, _name::String)
            new(_parent, _name, Dict{String, Union{_dir, _file}}());
        end
    end
    
    addDirIfMissing(cdir::_dir, sdname::String) = haskey(cdir.children, sdname) || push!(cdir.children, sdname => _dir(cdir, sdname));
    
    function toDirTree(lines)::_dir
        root::_dir = _dir(nothing, "/");
        cdir::_dir = root;
    
        while ~isempty(lines)
            ln = popfirst!(lines);
            if startswith(ln, "\$ cd")
                if startswith(ln, "\$ cd /")
                    cdir = root;
                elseif startswith(ln, "\$ cd ..")
                    cdir = cdir.parent;
                else
                    sdname = ln[6:end];
                    addDirIfMissing(cdir, sdname);
                    cdir = cdir.children[sdname];
                end
                continue;
            end
            
            while ~isempty(lines)
                ln = popfirst!(lines)
                if startswith(ln, '$')
                    pushfirst!(lines, ln);
                    break;
                elseif startswith(ln, "dir")
                    addDirIfMissing(cdir, ln[5:end]);
                else
                    (szfile, fname) = (x->(parse(Int, x.captures[1]), x.captures[2]))(match(r"(\d+)\s(.*)", ln));
                    cdir.children[fname] = _file(fname, szfile);
                end
            end
        end
    
        return root;
    end

    function printDirTree(cdir::_dir, offset::Integer = 0)
        println("$(lpad("", offset, " "))-$(cdir.name) (dir, size=$(getSize(cdir))):")
        offset += 4;
    
        for (name, child) in cdir.children
            if typeof(child) == _dir
                printDirTree(child, offset);
                continue;
            end
            println("$(lpad("", offset, " "))-$(name) (file, size=$(child.size))")
        end
    end
    getSize(f::_file)::Integer = f.size;
    function getSize(cdir::_dir)::Integer
        sz = 0;
        for (name, child) in cdir.children
            sz += getSize(child);
        end
        return sz;
    end
    
    function sumDirSizeUnderX(cdir::_dir, limit::Integer)::Integer
        szcdir = getSize(cdir);
        sum = szcdir > limit ? 0 : szcdir;
    
        for (name, child) in cdir.children
            if typeof(child) == _file
                continue;
            end
            
            sum += sumDirSizeUnderX(child, limit);
        end
        return sum;
    end
    
    function findSmallestDirToDelete(cdir::_dir, minimum::Integer, smallestSoFar::Integer)::Integer
        szcdir = getSize(cdir);
        if szcdir < minimum
            return smallestSoFar;
        elseif szcdir == minimum;
            return minimum;
        end
    
        if szcdir < smallestSoFar
            smallestSoFar = szcdir;
        end 
    
        for (name, child) in cdir.children
            if typeof(child) == _file
                continue;
            end
            smallestSoFar = findSmallestDirToDelete(child, minimum, smallestSoFar);
        end
    
        return smallestSoFar;
    end
    
    function solvePart2(root::_dir, diskSize::Integer = 70000000, needed::Integer = 30000000)::Integer
        szroot      = getSize(root);
        return findSmallestDirToDelete(root, needed - (diskSize - szroot), szroot);
    end

    function solve(bTestCase::Bool = false)::Tuple{Any, Any};
        lines       = AdventOfCode.@getinputs(bTestCase);
        root        = toDirTree(lines); 

        part1       = sumDirSizeUnderX(root, 100000);
        part2       = solvePart2(root);

        return (part1, part2);
    end

    # @time (part1, part2) = solve(true); # Test
    # @time (part1, part2) = solve();
    # println("\nPart 1 answer: $(part1)");
    # println("Part 2 answer: $(part2)");
end