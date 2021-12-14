module Day14
export day14

using SparseArrays

TESTINPUT = """NNCB

CH -> B
HH -> N
CB -> H
NH -> C
HB -> C
HC -> B
HN -> C
NN -> C
BH -> H
NC -> B
NB -> B
BN -> B
BB -> N
BC -> B
CC -> N
CN -> C"""

_elem_to_int(elem) = 1 + (elem - 'A')
_int_to_elem(int) = (int - 1) + 'A'
_group_index(ind1, ind2) = 26*(ind1 - 1) + ind2

function parseRules(lines)
    L = length(lines)
    I,J = zeros(Int64, 2L), zeros(Int64, 2L)
    V = ones(Int64, 2L)
    at = 1
    for line in lines
        in1 = _elem_to_int(line[1])
        in2 = _elem_to_int(line[2])
        out = _elem_to_int(line[7])

        J[at] = _group_index(in1, in2)
        I[at] = _group_index(in1, out)

        J[at+1] = _group_index(in1, in2)
        I[at+1 ]= _group_index(out, in2)
        at += 2
    end
    return sparse(I,J,V, 26*26, 26*26)
end

function parseGroups(line)
    elements = _elem_to_int.(collect(line))
    L = length(line)
    I,V = zeros(Int64, L-1), ones(Int64, L-1)
    for i in 1:L-1
        I[i] = _group_index(elements[i], elements[i+1])
    end
    return sparsevec(I,V, 26*26)
end

function readInput(inputfile="inputs/input14.txt")
    lines = readlines(inputfile)
    polymer = parseGroups(lines[1])
    rules = parseRules(lines[3:end])
    return polymer, rules
end

polymerization_step(rule_matrix, group_vec) = rule_matrix * group_vec

function polymerize(polymer, rules, steps=10)
    for _ in 1:steps
        polymer = polymerization_step(rules, polymer)
    end
    return polymer
end

function score(polymer)
    counter = zeros(Int64, 26)
    for (groupindex, count) in zip(findnz(polymer)...)
        elem1, elem2 = divrem(groupindex-1, 26)
        counter[elem1+1] += count
        counter[elem2+1] += count
    end
    # This doesn't work for all inputs!
    # every element is part of exactly 2 groups EXCEPT for the ones on the edges
    # => all counts will be even numbers, except for the counts for edge elements which appear once
    # making their count 1 too small
    # => to get the correct counts we need to half the numbers and round UP
    # If both edge elements are identical then we are one off...
    # One could account for that when parsing the input...
    counter .= div.(counter, 2, RoundUp)
    min, max = extrema(filter!(!=(0), counter))
    return max-min
    # return - -(extrema(counter)...) # looks funnier :)
end

## Further optimization:
## Use a dense vector -> slightly faster multiplication and can optimize allocation
function day14((polymer, rules) = readInput("inputs/input14.txt"))
    polymer1 = polymerize(polymer, rules, 10)
    polymer2 = polymerize(polymer1, rules, 30)
    return score(polymer1), score(polymer2)
end

end #module
