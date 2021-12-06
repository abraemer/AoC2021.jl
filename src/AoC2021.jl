module AoC2021

using Reexport
# Write your package code here.

include("day01.jl")
include("day02.jl")
include("day03.jl")
include("day04.jl")
include("day05.jl")
include("day06.jl")

@reexport using .Day01
@reexport using .Day02
@reexport using .Day03
@reexport using .Day04
@reexport using .Day05
@reexport using .Day06

end
