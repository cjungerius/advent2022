module Day16

using DataStructures
using Memoize

function f(i="data/16.txt")
    nummatch = r"(\d+)"
    valvematch = r"([A-Z]{2})"

    valves = String[]
    flows = Int[]
    connections = Array[]
    for line in eachline(i)
        push!(flows,parse(Int,match(nummatch,line)[1]))
        v = [x[1] for x in eachmatch(valvematch,line)]
        push!(valves,v[1])
        push!(connections, v[2:end])
    end

    flowdict = Dict(valves .=> flows)
    connectiondict = Dict(valves .=> connections)

    flowdict, connectiondict
end


function partone(flowdict, connectiondict)


    mem = Dict{Tuple{Int,String},Int}()

    function g(state)

        time, loc, score, opened = state

        if time == 0
            return score
        end

        score += sum(x->get(flowdict,x,0),opened,init=0)
        get(mem,(time,loc),-1) > score && return -1
        mem[(time,loc)] = score

        nextstates = Int[]

        if flowdict[loc] > 0 && !(loc in opened)
            push!(nextstates,g((time-1,loc,score,[opened...,loc])))
            else
        
            for n in connectiondict[loc]
                push!(nextstates,g((time-1,n,score,opened)))
            end 
        end 

        return maximum(nextstates)
    end

    g((30,"AA",0,[]))
end

function partone_i(flowdict, connectiondict)

    nextstates = Tuple[] #Stack{Tuple}()
    maxscore = 0
    mem = Dict{Tuple{Int,String},Int}()
    push!(nextstates,(30,"AA",0,[]))

    while !isempty(nextstates)
        
        (time, loc, score, opened) = pop!(nextstates)

        if time == 0
            maxscore = max(maxscore, score)
            continue
        end

        get(mem,(time,loc),-1) > score && continue
        mem[(time,loc)] = score

        score += sum(x->get(flowdict,x,0),opened,init=0)

        if flowdict[loc] > 0 && !(loc in opened)
            push!(nextstates,(time-1,loc,score,[opened...,loc]))
        end
    
        for n in connectiondict[loc]
            push!(nextstates,(time-1,n,score,opened))
        end  
    end

    return maxscore
end

function parttwo(flowdict, connectiondict)


    mem = Dict{Tuple{Int,String,String},Int}()

    function g(state)

        time, locA, locB, score, opened = state

        if time == 0
            return score
        end

        get(mem,(time,locA, locB),-1) > score && return -1
        mem[(time,locA,locB)] = score

        score += sum(x->get(flowdict,x,0),opened,init=0)
        nextstates = Int[]

        canopenA = flowdict[locA] > 0 && !(locA in opened)
        canopenB = flowdict[locB] > 0 && !(locB in opened) && locA != locB
        
            if canopenA && canopenB
                push!(nextstates,g((time-1,locA,locB,score,[opened...,locA,locB])))            
            elseif canopenA
                for m in connectiondict[locB]
                    push!(nextstates,g((time-1,locA,m,score,[opened...,locA])))
                end
            elseif canopenB
                for n in connectiondict[locA]
                    push!(nextstates,g((time-1,n,locB,score,[opened...,locB])))
                end
            else
                for n in connectiondict[locA], m in connectiondict[locB]
                    push!(nextstates,g((time-1,n,m,score,opened)))
                end 
            end

        return maximum(nextstates)
        end 

    g((26,"AA","AA",0,[]))
end

function recursive(flowdict, connectiondict)

    #shoutout to Rose for the code lmao
    m = Dict()

    function g(state)
        
        time, location, score, opened = state
        opened = copy(opened)

        if get(m,(time, location),-1) >= score
            return -1
        end

        m[(time,location)] = score

        if time == 30
            return score
        end

        scores = Int[]
        
        if flowdict[location] > 0 && !(location in opened)
            push!(opened,location)
            flow = sum(flowdict[o] for o in opened)
            push!(scores,g((time+1,location,score+flow,opened)))
        else
            flow = sum([flowdict[o] for o in opened],init=0)
            for n in connectiondict[location]
                push!(scores, g((time+1,n,score+flow,opened)))
            end
        end
        return maximum(scores)
    end
    
    g((1,"AA",0,Set()))
end

function recursive_part2(flowdict, connectiondict)

    s = [(1,"AA","AA",0,Set())]
    maxscore = 0
    m = Dict()

    while !isempty(s)
        
        time, locationA, locationB, score, opened = pop!(s)
        opened = deepcopy(opened)

        if get(m,(time, locationA, locationB),-1) >= score
            continue
        end

        m[(time,locationA, locationB)] = score

        if time == 26
            maxscore = max(maxscore,score)
            continue
        end

        canopenA = flowdict[locationA] > 0 && !(locationA in opened)
        canopenB = locationA != locationB && flowdict[locationB] > 0 && !(locationB in opened)
        flow = sum([flowdict[o] for o in opened])        
        
        for newA in connectiondict[locationA], newB in connectiondict[locationB]
            push!(s, (time+1,newA,newB,score+flow,opened))
        end      

        if canopenA             #open A, walk at B
            push!(opened,locationA)
            flow = sum([flowdict[o] for o in opened])

            for newB in connectiondict[locationB]
                push!(s,(time+1,locationA,newB,score+flow,opened))
            end

            pop!(opened,locationA)
        end
        
        if canopenB         #open B, walk at A
            push!(opened,locationB)
            flow = sum([flowdict[o] for o in opened])

            for newA in connectiondict[locationA]
                push!(s,(time+1,newA,locationB,score+flow,opened))
            end
        end

        if canopenA && canopenB     #open both
            push!(opened,locationA, locationB)
            flow = sum(flowdict[o] for o in opened)
            push!(s,(time+1,locationA,locationB,score+flow,opened))
        end

    end

    maxscore
end

function elephantdfs(flowdict, connectiondict, memory = Dict())

    function g(state)

        time, me, elephant, score, opened = state
        opened = copy(opened)

        scores = []

        if get(memory,(time,me,elephant), -1) >= score # Had better score here before
            return -1 # Skip to the next iteration
        end

        memory[(time,me,elephant)] = score # Save score for this time & location

        if time == 26
            return score # Times up, so try next one
        end

        flow = sum([flowdict[loc] for loc in opened],init=0)
        
        mecanopen = flowdict[me] > 0 && !(me in opened)
        elephantcanopen = flowdict[elephant] > 0 && !(elephant in opened)

        for neigh_me in connectiondict[me] # (1) Both go to neighbour
            for neigh_eleph in connectiondict[elephant]
                newscore = g((time+1, neigh_me, neigh_eleph, score+flow, opened))
                push!(scores,newscore)
            end
        end

        if elephantcanopen # (2) Only elephant opens valve
            push!(opened,elephant)
            flow = sum(flowdict[loc] for loc in opened)

            for neigh_me in connectiondict[me]
                newscore = g((time+1, neigh_me, elephant, score+flow, opened))
                push!(scores,newscore)
            end

            pop!(opened,elephant)
        end

        if mecanopen # (3) Only I open valve
            push!(opened,me)
            flow = sum(flowdict[loc] for loc in opened)

            for neigh_elephant in connectiondict[elephant]
                newscore = g((time+1, me, neigh_elephant, score+flow, opened))
                push!(scores,newscore)
            end

            if elephantcanopen # (4) Both open valve
                push!(opened,elephant)
                flow = sum(flowdict[loc] for loc in opened)

                newscore = g((time+1, me, elephant, score+flow, opened))
                push!(scores,newscore)
            end
        end

        return maximum(scores)
    end

    best = g((1, "AA", "AA", 0, Set()))
    return best
end

end

