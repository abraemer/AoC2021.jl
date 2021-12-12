module Day12

using DataStructures: counter

export day12

TESTINPUT = """start-A
start-b
A-c
A-b
b-d
A-end
b-end"""

TESTINPUT2 = """dc-end
HN-start
start-kj
dc-start
dc-HN
LN-dc
HN-end
kj-sa
kj-HN
kj-dc"""

TESTINPUT3 = """fs-end
he-DX
fs-he
start-DX
pj-DX
end-zg
zg-sl
zg-pj
pj-he
RW-he
fs-DX
pj-RW
zg-RW
start-pj
he-WI
zg-he
pj-fs
start-RW"""

function readInput(inputfile="inputs/input12.txt")
    edges = Dict{String,Set{String}}()
    for line in eachline(inputfile)
        a,b = split(line,"-")
        b != "start" && (edges[a] = push!(get(edges, a, Set{String}()), b))
        a != "start" && (edges[b] = push!(get(edges, b, Set{String}()), a))
    end
    #delete!(edges, "end")
    smallcavemap = _replace_big_caves(edges)
    return Dict([a=>counter(b) for (a,b) in smallcavemap]) # reduce edges by counting
end

isbigcave(cavename) = all(isuppercase, cavename)

function _replace_big_caves(cavegraph)
    newgraph = Dict{String,Vector{String}}()
    addedge(a,b) = b != "start" && (newgraph[a] = push!(get(newgraph, a, Vector{String}()), b))
    for cave in keys(cavegraph)
        if !isbigcave(cave)
            # small cave
            for b in cavegraph[cave]
                if isbigcave(b)
                    for c in cavegraph[b]
                        addedge(cave, c)
                    end
                else
                    addedge(cave, b)
                end
            end
        end
    end
    return newgraph
end

function day12(cavegraph = readInput("inputs/input12.txt"))
    return (day12Part1(cavegraph), day12Part2(cavegraph))
end

function day12Part1(cavegraph)
    _walk(cavegraph, "start", true)
end

## mutating version 2: edges have multiplicities ~ 30x faster
function _walk(cavegraph, at, visited_twice=false, seen=Vector{String}())
    at == "end" && return 1
    addToSeen = !in(at, seen)
    addToSeen && push!(seen, at) # only remember lowercase nodes
    adjacent = cavegraph[at]

    paths = 0
    for (adj, count) in adjacent
        if adj in seen
            visited_twice && continue
            paths += count * _walk(cavegraph, adj, true, seen)
        else
            paths += count * _walk(cavegraph, adj, visited_twice, seen)
        end
    end
    # addToSeen && delete!(seen, at)
    addToSeen && pop!(seen)
    return paths
end

######## prior versions ########

## mutating version ~ 4x faster then non-mutating but a bit more complex
## also switch to Vector from Set - for these small problem sizes the overhead of the set is not worth it
function _walk2(cavegraph, at, visited_twice=false, seen=Vector{String}())
    at == "end" && return 1
    addToSeen = !(in(at, seen) || isbigcave(at))
    addToSeen && push!(seen, at) # only remember lowercase nodes
    adjacent = cavegraph[at]

    paths = 0
    for adj in adjacent
        if adj in seen
            visited_twice && continue
            paths += _walk(cavegraph, adj, true, seen)
        else
            paths += _walk(cavegraph, adj, visited_twice, seen)
        end
    end
    # addToSeen && delete!(seen, at)
    addToSeen && pop!(seen)
    return paths
end

## non mutating version
function _walk1(cavegraph, at, visited_twice=false, seen=Set{String}())
    at == "end" && return 1
    isbigcave(at) || (seen = union(seen, Ref(at))) # only remember lowercase nodes
    adjacent = cavegraph[at]

    paths = 0
    for adj in adjacent
        if adj in seen
            visited_twice && continue
            paths += _walk(cavegraph, adj, true, seen)
        else
            paths += _walk(cavegraph, adj, visited_twice, seen)
        end
    end
    return paths
end

function day12Part2(cavegraph)
    _walk(cavegraph, "start", false)
end

end #module
