module Day06

using DataStructures: counter

export day06

const TIME_TO_REPRODUCE = 7
const TIME_TO_MATURITY = 9


function readInput(inputfile="inputs/input06.txt")
    return parse.(UInt8, split(readline(inputfile), ","))
end

# Let L(x,t) be the population resulting starting with a SINGLE lanternfish with counter x
# after t days
# Use relations for L(x,t)
# - L(x, t) = L(0, t-x)
# - L(0, k) = 1 (for k ≤ 0)
# - L(0, t) = L(0, t-TIME_TO_REPRODUCE) + L(0, t-TIME_TO_MATURITY)


################################## more Julian solution ##################################
## a bit slower than the lower one
## but that's just due to the use of DataStructures.counter
## without that the 2 solution run in pretty much identical time

struct LaternfishPopulationPrediction
    precomputed::Vector{Int64}
    upto::Int64
    function LaternfishPopulationPrediction(upto)
        new(_precompute_lanternfish_popuplation(upto), upto)
    end
end

function _precompute_lanternfish_popuplation(upto)
    populations = Vector{Int64}(undef, upto+TIME_TO_MATURITY)
    populations[1:TIME_TO_MATURITY] .= 1
    for index in TIME_TO_MATURITY .+ (1:upto)
        populations[index] = populations[index-TIME_TO_REPRODUCE] + populations[index-TIME_TO_MATURITY]
    end
    return populations
end

function Base.getindex(pop::LaternfishPopulationPrediction, time)
    time <= pop.upto || error("time larger than simulated! ($time > $(pop.upto))")
    return pop.precomputed[time+9]
end


function population(counts, time, precomputed=nothing)
    precomputed === nothing && (precomputed = LaternfishPopulationPrediction(time))
    total = 0
    for (ini, count) in counts
        total += precomputed[time-ini]*count
    end
    return total
end


function day06(inputdata = readInput("inputs/input06.txt"))
    pop = LaternfishPopulationPrediction(256)
    counts = counter(inputdata)
    return population(counts, 80, pop), population(counts, 256, pop)
end


######################## using Memoize.jl and optimizing counter ########################

using Memoize

L(x,t) = _L(t-x)
@memoize function _L(t)
    if t <= 0
        return 1
    else
        return _L(t-TIME_TO_REPRODUCE) + _L(t-TIME_TO_MATURITY)
    end
end

_L(256) # warm cache

function population_alt(counts, time)
    total = 0
    for (ini, count) in counts
        total += L(ini-1, time)*count
    end
    return total
end

function day06_alt(inputdata = readInput("inputs/input06.txt"))
    counts = enumerate(_mycount(inputdata)) # ~4x faster than counter
    return population_alt(counts, 80), population_alt(counts, 256)
end

function _mycount(inputdata)
    ret = zeros(Int64, maximum(inputdata)+1)
    for i in inputdata
        ret[i+1] += 1
    end
    return ret
end

end #module
