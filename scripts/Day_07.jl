# include("./scripts/Day_07.jl")
using DataStructures 

struct _file3
    name        ::String
    size        ::Integer
end

struct _dir4
    parent      ::Union{Nothing, _dir4}
    name        ::String
    children    ::Dict{String, Union{_dir4, _file3}}

    function _dir4(_parent::Union{Nothing, _dir4}, _name::String)
        new(_parent, _name, Dict{String, Union{_dir4, _file3}}());
    end
end

addDirIfMissing(cdir::_dir4, sdname::String) = haskey(cdir.children, sdname) || push!(cdir.children, sdname => _dir4(cdir, sdname));

function toDirTree(lines)::_dir4
    root::_dir4 = _dir4(nothing, "/");
    cdir::_dir4 = root;

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
                cdir.children[fname] = _file3(fname, szfile);
            end
        end
    end

    return root;
end

function printDirTree(cdir::_dir4, offset::Integer = 0)
    println("$(lpad("", offset, " "))-$(cdir.name) (dir, size=$(getSize(cdir))):")
    offset += 4;

    for (name, child) in cdir.children
        if typeof(child) == _dir4
            printDirTree(child, offset);
            continue;
        end
        println("$(lpad("", offset, " "))-$(name) (file, size=$(child.size))")
    end
end

getSize(f::_file3)::Integer = f.size;
function getSize(cdir::_dir4)::Integer
    sz = 0;
    for (name, child) in cdir.children
        sz += getSize(child);
    end
    return sz;
end

function sumDirSizeUnderX(cdir::_dir4, limit::Integer)::Integer
    szcdir = getSize(cdir);
    sum = szcdir > limit ? 0 : szcdir;

    for (name, child) in cdir.children
        if typeof(child) == _file3
            continue;
        end
        
        sum += sumDirSizeUnderX(child, limit);
    end
    return sum;
end

function findSmallestDirToDelete(cdir::_dir4, minimum::Integer, smallestSoFar::Integer)::Integer
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
        if typeof(child) == _file3
            continue;
        end
        smallestSoFar = findSmallestDirToDelete(child, minimum, smallestSoFar);
    end

    return smallestSoFar;
end

function part2(root::_dir4, diskSize::Integer = 70000000, needed::Integer = 30000000)::Integer
    szroot      = getSize(root);
    return findSmallestDirToDelete(root, needed - (diskSize - szroot), szroot);
end

# lines = open("./inputs/2022/in_2022--07_test.txt") do file
lines = open("./inputs/2022/in_2022--07.txt") do file
    lines = readlines(file);
end

root = toDirTree(lines); 

printDirTree(root);

@time println("Part 1 answer: $(sumDirSizeUnderX(root, 100000))");
@time println("Part 2 answer: $(part2(root))");