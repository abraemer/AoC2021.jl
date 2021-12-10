module Day10

using Statistics: median

export day10

TESTINPUT = split("""[({(<(())[]>[[{[]{<()<>>
[(()[<>])]({[<{<<[]>>(
{([(<{}[<>[]}>{[]{[(<()>
(((({<>}<{<{<>}{[]{[]{}
[[<[([]))<([[{}[[()]]]
[{[{({}]{}}([{[{{{}}([]
{<[[]]>}<{[{[{[]{()[[[]
[<(<(<(<{}))><([]([]()
<{([([[(<>()){}]>(<<{{
<{([{{}}[<[[[<>{}]]]>[]]""", "\n")


POINTS = Dict([')'=>3, ']'=>57, '}'=>1197, '>'=>25137])
PAIRS = Dict(['('=>')', '['=>']', '{'=>'}', '<'=>'>'])

_string_iterator(str) = Iterators.take(str, length(str))
_isopening(ch) = ch == '(' || ch == '[' || ch == '{' || ch == '<'
_toclosing(ch) = PAIRS[ch]
_corrupted_score(ch) = POINTS[ch]

function day10(lines = readlines("inputs/input10.txt"))
    autocomplete_scores = Int64[]
    corrupted_score = 0
    for line in lines
        stack = Char[]
        corrupt = false
        for ch in _string_iterator(line)
            if _isopening(ch)
                push!(stack, _toclosing(ch))
            else
                if pop!(stack) != ch
                    corrupted_score += _corrupted_score(ch)
                    corrupt = true
                    break
                end
            end
        end
        # if not corrupt and stack contains something -> line is incomplete
        !corrupt && length(stack) > 0 && push!(autocomplete_scores, _autocomplete_score(stack))
    end
    @assert mod(length(autocomplete_scores), 2) == 1
    return corrupted_score, sort!(autocomplete_scores)[div(length(autocomplete_scores), 2, RoundUp)]
end

AUTOCOMPLETE_POINTS = Dict([')'=>1, ']'=>2, '}'=>3, '>'=>4])

function _autocomplete_score(stack)
    score = 0
    for ch in Iterators.reverse(stack)
        score *= 5
        score += AUTOCOMPLETE_POINTS[ch]
    end
    return score
end

end #module
