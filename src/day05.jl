module Day05
export day05

function parseLine(line)
    raw = split.(split(line, " -> "), ",")
    return complex(parse.(Int64, raw[1])...), complex(parse.(Int64, raw[2])...)
end

function readInput(inputfile="inputs/input05.txt")
    return [parseLine(line) for line in eachline(inputfile)]
end

function day05(ventdata = readInput("inputs/input05.txt"))
    grid = Dict{Complex{Int64}, Int64}()

    mask = ishorizontal.(ventdata)
    mapvents!(grid, ventdata[mask])
    part1 = count_crossings(grid)

    mapvents!(grid, ventdata[.!(mask)])
    part2 = count_crossings(grid)
    return part1, part2
end

function mapvents!(grid, data)
    for (start, stop) in data
        Δ = stop-start
        dist = distance(Δ)
        δ = intdiv(Δ, dist)
        for l in 0:dist
            pos = start+δ*l
            grid[start+δ*l] = 1 + get(grid, pos, 0)
        end
    end
    return grid
end

ishorizontal((from, to)) = real(from) == real(to) || imag(from) == imag(to)
distance(x::Complex) = let r = abs(real(x)); r == 0 ? abs(imag(x)) : r end
intdiv(x::Complex, by::Int) = complex(div(real(x), by), div(imag(x), by))

count_crossings(grid) = count(>=(2), values(grid))

end #module
