module DayNNN
export dayNNN

function parseLine(line)
    line
end

function readInput(inputfile="inputs/inputNNN.txt")
    lines = readlines(inputfile)
    return lines
    # return [parseLine(line) for line in eachline(inputfile)]
end

function dayNNN(inputdata = readInput("inputs/inputNNN.txt"))
    return (dayNNNPart1(inputdata), dayNNNPart2(inputdata))
end

function dayNNNPart1(values)

end

function dayNNNPart2(values)

end

end #module
