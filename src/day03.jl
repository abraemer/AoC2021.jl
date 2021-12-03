module Day03
export day03

const TESTINPUT = """
00100
11110
10110
10111
10101
01111
00111
11100
10000
11001
00010
01010
"""

function parseLine(line)
    # work around string being a scalar for broadcasting
    return parse.(Bool, Iterators.take(line, length(line)))
end

function readInput(inputfile="inputs/input03.txt")
    return vcat((parseLine(line)' for line in eachline(inputfile))...)
end

function day03(inputfile="inputs/input03.txt")
    values = readInput(inputfile)
    return (day03Part1(values), day03Part2(values))
end

function day03Part1(values)
    resultbits = sum(values; dims = 1) .> div(size(values, 1), 2)
    γvalue = bits_to_int(resultbits)
    ϵvalue = bits_to_int(.!(resultbits))
    return γvalue*ϵvalue
end

function day03Part2(values)
    oxygen_rating = compute_diagnostic(values, >=)
    c02scrub_rating = compute_diagnostic(values, <)
    return oxygen_rating*c02scrub_rating
end

function compute_diagnostic(values, cmp)
    mask = fill!(BitArray(undef, size(values, 1)), true)
    col = 1
    while col <= size(values, 2) && sum(mask) > 1
        updatemask!(mask, values[:, col], cmp)
        col += 1
    end
    @assert sum(mask) == 1
    row = argmax(mask)
    return bits_to_int(values[row,:])
end

function updatemask!(mask, colvalues, cmp)
    colsum = sum(colvalues[mask])
    selectVal = cmp(2*colsum, sum(mask)) ? 1 : 0
    mask .&= (colvalues .== selectVal)
end

bits_to_int(something) = bits_to_int(convert(BitArray, something))
bits_to_int(bitarr::BitArray) = reinterpret(Int64, reverse(bitarr).chunks[1]) # only works for very small bitarrays

end #module
