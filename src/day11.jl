module Day11
export day11

_string_iterator(str) = Iterators.take(str, length(str))

parseLine(line) = parse.(Int64, _string_iterator(line))

function readInput(inputfile="inputs/input11.txt")
    return hcat([parseLine(line) for line in eachline(inputfile)]...)
end

const ADJACENT = let temp = vec(CartesianIndex.(-1:1, (-1:1)'))
    deleteat!(temp, 5)
    temp
end # delete (0,0)

function step!(grid)
    grid .+= 1

    flashed = 0
    for I in CartesianIndices(grid)
        if grid[I] > 9
            flashed += _octopus_flash!(grid, I)
        end
    end
    return flashed
end

function _octopus_flash!(grid, loc)
    grid[loc] = 0
    flashed = 1
    for adj in ADJACENT
        neighbour = loc + adj
        checkbounds(Bool, grid, neighbour) || continue
        if grid[neighbour] > 0 # exclude already flashed
            grid[neighbour] += 1
        end
        if grid[neighbour] > 9
            flashed += _octopus_flash!(grid, neighbour)
        end
    end
    return flashed
end

function day11Part1!(grid, steps=100)
    flashes = [step!(grid) for _ in 1:steps]
    @assert !any(flashes .== length(grid))
    return sum(flashes)
end

function day11Part2!(grid)
    flashed = 0
    round = 0 # from part 1
    while flashed != length(grid)
        flashed = step!(grid)
        round += 1
    end
    return round
end

function day11(inputdata = readInput("inputs/input11.txt"))
    return (day11Part1!(inputdata, 100), 100+day11Part2!(inputdata))
end

end #module
