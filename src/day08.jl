module Day08

using LinearAlgebra: dot

export day08

const TESTINPUT = """be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe
edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc
fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef | cg cg fdcagb cbg
fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega | efabcd cedba gadfec cb
aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga | gecf egdcabf bgf bfgea
fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf | gebdcfa ecba ca fadegcb
dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf | cefg dcbef fcge gbcadfe
bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd | ed bcgafe cdgba cbgef
egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg | gbdfcae bgc cg cgb
gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc | fgae cfgab fg bagce"""

function parseLine(line)
    combinations, output = split.(split(line, "|"))
    keys = _solve(Set.(combinations))
    return getindex.(Ref(keys),Set.(output))
end

function _solve(combinations)
    find(pred, list) = list[findfirst(pred, list)]
    haslength(L) = x -> length(x) == L
    subsetof(s1) = s2 -> issubset(s2, s1)
    contains(s1) = s2 -> issubset(s1, s2)
    unequalto(s1) = s2 -> s1 !== s2 # can check identity in this case
    and(preds...) = x -> all(pred(x) for pred in preds)

    one = find(haslength(2), combinations)
    seven = find(haslength(3), combinations)
    four = find(haslength(4), combinations)
    eight = find(haslength(7), combinations)
    three = find(and(haslength(5), contains(one)), combinations)
    nine = find(and(haslength(6), contains(three)), combinations)
    five = find(and(haslength(5), subsetof(nine), unequalto(three)), combinations)
    two = find(and(haslength(5), unequalto(five), unequalto(three)), combinations)
    six = find(and(haslength(6), contains(five), unequalto(nine)), combinations)
    zero = find(and(haslength(6), unequalto(six), unequalto(nine)), combinations)
    return Dict([zero=>0, one=>1, two=>2, three=>3, four=>4, five=>5, six=>6, seven=>7, eight=>8, nine=>9])
end

function readInput(inputfile="inputs/input08.txt")
    linedata = [parseLine(line) for line in eachline(inputfile)]
    return linedata # transpose
end

function day08(inputdata = readInput("inputs/input08.txt"))
    return (day08Part1(inputdata), day08Part2(inputdata))
end

function day08Part1(outputs)
    # count 1,4,7,8
    count = 0
    for line in outputs
        for out in line
            if out==1 || out==4 || out==7 || out==8
                count += 1
            end
        end
    end
    return count
end

function day08Part2(outputs)
    magnitudes = collect(10 .^ (3:-1:0))
    count = 0
    for line in outputs
        count += dot(line, magnitudes)
    end
    return count
end

end #module
