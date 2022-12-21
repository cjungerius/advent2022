module Day19

using DataStructures
using Memoize

struct State
        time::Int
        ore::Int
        clay::Int
        obsidian::Int
        geodes::Int
        d_ore::Int
        d_clay::Int
        d_obsidian::Int
        d_geodes::Int
end

function makeblueprints(io="data/19.txt")
        blueprints = Array[]
        for line in eachline(io)
                ms = eachmatch(r"(\d+)", line)
                push!(blueprints, [parse(Int, m[1]) for m in ms][2:end])
        end

        blueprints
end

function testblueprint(bp)

        orecost = bp[1]
        claycost = bp[2]
        obscost = bp[3:4]
        geocost = bp[5:6]

        start = State(0, 0, 0, 0, 0, 1, 0, 0, 0)

        mem = Dict()
        
        function dfs(state::State)

                if get(mem,state,-1) ≥ 0
                        return mem[state]
                end

                time = state.time + 1
                ore = state.ore + state.d_ore
                clay = state.clay + state.d_clay
                obsidian = state.obsidian + state.d_obsidian
                geodes = state.geodes + state.d_geodes
                d_ore = state.d_ore
                d_clay = state.d_clay
                d_obsidian = state.d_obsidian
                d_geodes = state.d_geodes           

                if time == 24
                        return geodes
                end

                outcomes = Int[]

                if state.ore ≥ geocost[1] && state.obsidian ≥ geocost[2] #always build a geo bot if we can
                        push!(outcomes, dfs(State(time, ore - geocost[1], clay, obsidian - geocost[2], geodes, d_ore, d_clay, d_obsidian, d_geodes + 1)))
                elseif state.ore ≥ obscost[1] && state.clay ≥ obscost[2] && d_obsidian < geocost[2] #only increase obsidian production if it makes sense
                        push!(outcomes, dfs(State(time, ore - obscost[1], clay - obscost[2], obsidian, geodes, d_ore, d_clay, d_obsidian + 1, d_geodes)))

                        if state.ore ≥ claycost && d_clay < obscost[2]
                                push!(outcomes, dfs(State(time, ore - claycost, clay, obsidian, geodes, d_ore, d_clay + 1, d_obsidian, d_geodes)))
                        end

                        if state.ore ≥ orecost && d_ore < max(orecost,claycost,obscost[1],geocost[1])
                                push!(outcomes, dfs(State(time, ore - orecost, clay, obsidian, geodes, d_ore + 1, d_clay, d_obsidian, d_geodes)))
                        end

                        push!(outcomes, dfs(State(time, ore, clay, obsidian, geodes, d_ore, d_clay, d_obsidian, d_geodes)))

                elseif state.ore ≥ claycost && d_clay < obscost[2] #same for clay
                        push!(outcomes, dfs(State(time, ore - claycost, clay, obsidian, geodes, d_ore, d_clay + 1, d_obsidian, d_geodes)))

                        if state.ore ≥ orecost && d_ore < max(orecost,claycost,obscost[1],geocost[1])
                                push!(outcomes, dfs(State(time, ore - orecost, clay, obsidian, geodes, d_ore + 1, d_clay, d_obsidian, d_geodes)))
                        end

                        push!(outcomes, dfs(State(time, ore, clay, obsidian, geodes, d_ore, d_clay, d_obsidian, d_geodes)))

                elseif state.ore ≥ orecost && d_ore < max(orecost,claycost,obscost[1],geocost[1]) #and same for ore
                        push!(outcomes, dfs(State(time, ore - orecost, clay, obsidian, geodes, d_ore + 1, d_clay, d_obsidian, d_geodes)))
                        push!(outcomes, dfs(State(time, ore, clay, obsidian, geodes, d_ore, d_clay, d_obsidian, d_geodes)))
                else
                        push!(outcomes, dfs(State(time, ore, clay, obsidian, geodes, d_ore, d_clay, d_obsidian, d_geodes)))
                end

                
                outcome = maximum(outcomes)

                mem[state] = outcome

                return outcome
        end

        
        maxscore = dfs(start)
end

function testblueprint_mc(bp,n=200000; c=24)

        orecost = bp[1]
        claycost = bp[2]
        obscost = bp[3:4]
        geocost = bp[5:6]

        maxscore = 0

        
        for i in 1:n
                
                ore = 0
                clay = 0
                obsidian = 0
                geodes = 0
                d_ore = 1
                d_clay = 0
                d_obsidian = 0
                d_geodes = 0

                for t in 1:c

                        canbuildgeo = ore ≥ geocost[1] && obsidian ≥ geocost[2]

                        canbuildore = ore ≥ orecost && d_ore < max(claycost,obscost[1],geocost[1])
                        canbuildclay = ore ≥ claycost && d_clay < obscost[2]
                        canbuildobsidian = ore ≥ obscost[1] && clay ≥ obscost[2] && d_obsidian < geocost[2]

                        ore += d_ore
                        clay += d_clay
                        obsidian += d_obsidian
                        geodes += d_geodes

                        t==c && continue

                        if canbuildgeo
                                d_geodes += 1
                                ore -= geocost[1]
                                obsidian -= geocost[2]
                        elseif canbuildobsidian && rand() < .75
                                d_obsidian += 1
                                ore -= obscost[1]
                                clay -= obscost[2]                                
                        elseif canbuildclay && rand() < .5
                                d_clay += 1
                                ore -= claycost                        
                        elseif canbuildore && rand() < .5                                
                                d_ore += 1
                                ore -= orecost
                        end

                end
                maxscore = max(maxscore,geodes)
        end


        maxscore
end


function solutions(io::String=joinpath(@__DIR__,"..","data","19.txt"),deterministic=false)
        ispath(io) || (io=IOBuffer(io))
        blueprints = makeblueprints(io)
        partonearr = deterministic ? testblueprint.(blueprints) : testblueprint_mc.(blueprints)
        
        partone = sum([i*partonearr[i] for i in eachindex(partonearr)])
        parttwo = reduce(*,testblueprint_mc.(blueprints[1:3],c=32))

        partone, parttwo
end

end