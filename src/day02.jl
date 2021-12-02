module Day02
export day02

function parseLine(line)
    cmd, distance = split(line, " ")
    return (Symbol(cmd), parse(Int, distance))
end

function readInput(inputfile="inputs/input02.txt")
    return parseLine.(eachline(inputfile))
end

function day02(inputfile="inputs/input02.txt")
    values = readInput(inputfile)
    return (day02Part1(values), day02Part2(values))
end

function day02Part1(cmdlist)
    pos = 0+0im
    factors = (; forward=1, down=im, up=-im)
    for (cmd, dist) in cmdlist
        pos += factors[cmd]*dist
    end
    return real(pos)*imag(pos)
end

function day02Part2(cmdlist)
    pos = 0+0im
    aim = 0im
    ## simple "if" statements are probably cleaner...
    moves = (; forward = x -> (x*(1+aim), 0),
               down = x -> (0, im*x),
               up = x -> (0, -im*x))
    for (cmd, dist) in cmdlist
        Δpos, Δaim = moves[cmd](dist)
        pos += Δpos
        aim += Δaim
    end
    return real(pos)*imag(pos)
end

end #module
