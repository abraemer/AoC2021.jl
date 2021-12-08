module Day07

using Statistics: median, mean

export day07

function readInput(inputfile="inputs/input07.txt")
    return parse.(Int64, split(readline(inputfile), ","))
end

function day07(inputdata = readInput("inputs/input07.txt"))
    return (day07Part1(inputdata), day07Part2(inputdata))
end

function day07Part1(values)
    mid = convert(Int64, median(values))
    return sum(abs.(values .- mid))
end

function day07Part2(values)
    mid = mean(values)
    return min( _total_fuel(values, round(Int64, mid, RoundDown)),
                _total_fuel(values, round(Int64, mid, RoundUp)))
end

function _total_fuel(values, point)
    Δs = abs.(values .- point)
    return sum(div.(Δs .* ( Δs .+ 1),  2))
end

end #module
