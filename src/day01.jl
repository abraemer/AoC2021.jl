module Day01
export day01

function readInput(inputfile="inputs/input01.txt")
    lines = parse.(Int, eachline(inputfile))
    return lines
end

function day01(inputdata = readInput("inputs/input01.txt"))
    return (day01Part1(inputdata), day01Part2(inputdata))
end

function day01Part1(values)
    #count(isless.(values[1:end-1], values[2:end]))
    #@views mapreduce(isless, +, values[1:end-1], values[2:end])
    return lagged_compare(values, 1)
end

function day01Part2(values)
    #count(isless.(values[1:end-3], values[4:end]))
    #@views mapreduce(isless, +, values[1:end-3], values[4:end])
    return lagged_compare(values, 3)
end

function lagged_compare(values, lag=1)
    count = 0
    for i in 1:length(values)-lag
        if values[i+lag] > values[i]
            count += 1
        end
    end
    return count
end

end #module
