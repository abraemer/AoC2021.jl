module Day13
export day13

TESTINPUT = """6,10
0,14
9,10
0,3
10,4
4,11
6,0
6,12
4,1
0,13
10,12
3,4
3,0
8,4
1,10
2,14
8,10
9,0

fold along y=7
fold along x=5"""

function readInput(inputfile="inputs/input13.txt")
    lines = Iterators.Stateful(eachline(inputfile))

    # parse dots
    inds = Vector{Int64}[]
    for line in lines
        length(line) == 0 && break # empty line separates coordinates from folds
        push!(inds, parse.(Int64, split(line, ",")))
    end

    # parse folds
    folds = []
    for line in lines
        axis = line[12] == 'x' ? 1 : 2
        values = parse(Int64, line[14:end])
        push!(folds, (axis, values)) # +1 to account for Julia arrays
    end
    return inds, folds
end

function day13((indices, folds) = readInput("inputs/input13.txt"); output="inputs/output13.txt")
    part1 = length(_fold!(indices, folds[1]))
    [_fold!(indices, fold) for fold in folds[2:end]]

    # visualize
    maxX = maximum(x->x[1], indices)
    maxY = maximum(x->x[2], indices)
    arr = fill('.', maxX+1, maxY+1)

    arr[[CartesianIndex(ind...) + CartesianIndex(1,1) for ind in indices]] .= '#'
    open(output, "w") do out
        println.(Ref(out), String.(eachcol(arr)))
    end

    return (part1, "See $output")
end

function _fold!(inds, (axis, coordinate))
    for ind in inds
        if ind[axis] > coordinate
            ind[axis] = 2*coordinate - ind[axis]
        end
    end
    unique!(inds)
end

end #module
