module Day06

using DataStructures: counter

export day06

#
# Use relations for L(x,t)
# - L(x, t) = L(0, t-x)
# - L(0, k) = 1 (for k ≤ 0)
# - L(0, t) = L(0, t-7) + L(0, t-9)
struct LaternfishPopulationPrediction
    precomputed::Vector{Int64}
    upto::Int64
    function LaternfishPopulationPrediction(upto)
        new(_precompute_lanternfish_popuplation(upto), upto)
    end
end

function _precompute_lanternfish_popuplation(upto)
    populations = Vector{Int64}(undef, upto+9)
    populations[1:9] .= 1
    for index in 1+9:upto+9
        populations[index] = populations[index-7] + populations[index-9]
    end
    return populations
end

function Base.getindex(pop::LaternfishPopulationPrediction, time)
    time <= pop.upto || error("time larger than simulated! ($time > $(pop.upto))")
    return pop.precomputed[time+9]
end


function population(initial, time, precomputed=nothing)
    precomputed === nothing && (precomputed = LaternfishPopulationPrediction(time))
    counts = counter(initial)
    total = 0
    for (ini, count) in counts
        total += precomputed[time-ini]*count
    end
    return total
end

function readInput(inputfile="inputs/input06.txt")
    return parse.(UInt8, split(readline(inputfile), ","))
end

function day06(inputdata = readInput("inputs/input06.txt"))
    pop = LaternfishPopulationPrediction(256)
    return population(inputdata, 80, pop), population(inputdata, 256, pop)
end

end #module
