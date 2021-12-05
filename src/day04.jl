module Day04
export day04

const BOARDSIZE = 5

function read_boards(lines)
    boards = Matrix{UInt8}[]
    for i in 1:BOARDSIZE+1:length(lines)
        cols = [parse.(UInt8, split(l, " "; keepempty=false)) for l in lines[i:i+BOARDSIZE-1]]
        push!(boards, hcat(cols...))
    end
    boards
end

function readInput(inputfile="inputs/input04.txt")
    lines = readlines(inputfile)
    numbers_drawn = parse.(UInt8, split(lines[1], ","; keepempty=false))
    boards = read_boards(lines[3:end])
    return numbers_drawn, boards
end

function day04(inputfile="inputs/input04.txt")
    numbers_drawn, boards = readInput(inputfile)
    scores = play_board.(Ref(numbers_drawn), boards)

    part1 = argmin(first, scores)
    part2 = argmax(first, scores)

    return (part1[2], part2[2])
end

function play_board(numbers_drawn, board)
    mask = falses(size(board)...)
    for (turn,number) in enumerate(numbers_drawn)
        index = findfirst(==(number), board)
        if !isnothing(index)
            mask[index] = true
            if board_won(mask)
                return turn, sum(board[.!(mask)]; init=0)*number
            end
        end
    end
    return nothing, nothing
end

function board_won(mask)
    cols = any(all.(eachcol(mask)))
    rows = any(all.(eachcol(mask')))
    return cols || rows
end

end #module
