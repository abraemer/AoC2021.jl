module Day09
export day09

const ADJACENT = [CartesianIndex(1,0),CartesianIndex(-1,0),CartesianIndex(0,1),CartesianIndex(0,-1)]

parseLine(line) = parse.(Int, Iterators.take(line, length(line)))

function readInput(inputfile="inputs/input09.txt")
    return hcat([parseLine(line) for line in eachline(inputfile)]...)
end

function day09(heightmap = readInput("inputs/input09.txt"))
    low_points = _find_low_points(heightmap)
    return (day09Part1(heightmap, low_points), day09Part2(heightmap, low_points))
end

function day09Part1(heightmap, low_points)
    return sum(getindex.(Ref(heightmap), low_points)) + length(low_points)
end

function _find_low_points(heightmap)
    low_points = CartesianIndex{2}[]
    for I in CartesianIndices(heightmap)
        h = heightmap[I]
        adj_I = filter!(x->checkbounds(Bool, heightmap, x), Ref(I) .+ ADJACENT)
        if all(getindex.(Ref(heightmap), adj_I) .> h)
            push!(low_points, I)
        end
    end
    return low_points
end

function day09Part2(heightmap, low_points)
    # floodfill starting from each low point
    basins = Int[]
    for low_point in low_points
        todo = [low_point]
        seen = Set{CartesianIndex{2}}()
        while length(todo) > 0
            at = pop!(todo)
            for adj in ADJACENT
                new = at + adj
                if !in(new, seen) && checkbounds(Bool, heightmap, new) && heightmap[new] < 9
                    push!(todo, new)
                end
            end
            push!(seen, at) # mark as seen
        end
        push!(basins, length(seen))
    end
    return reduce(*, sort!(basins)[end-2:end])
end

end #module
