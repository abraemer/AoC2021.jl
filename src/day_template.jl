module DayNNN
export dayNNN

function parseLine(line)
    line
end

function readInput(inputfile="inputs/inputNNN.txt")
    lines = readlines(inputfile)
    lines
    # [parseLine(line) for line in eachline(inputfile)]
end

function dayNNN(inputfile="inputs/inputNNN.txt")
    values = readInput(inputfile)
    (dayNNNPart1(values), dayNNNPart2(values))
end

function dayNNNPart1(values)
    
end

function dayNNNPart2(values)
    
end

end #module