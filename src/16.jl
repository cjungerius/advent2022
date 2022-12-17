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

        score += sum(x->get(flowdict,x,0),opened,init=0)
        if time == 0
            return score
        end

        get(mem,(time,loc),-1) >= score && return -1
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

    g((29,"AA",0,[]))
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
        score += sum([flowdict[x] for x in opened],init=0)

        if time == 26
            return score
        end

        get(mem,(time,locA, locB),-1) >= score && return -1
        mem[(time,locA,locB)] = score

        scores = Int[]

        canopenA = flowdict[locA] > 0 && !(locA in opened)
        canopenB = flowdict[locB] > 0 && !(locB in opened) && locA != locB

            
            for n in connectiondict[locA], m in connectiondict[locB]
                push!(scores,g((time+1,n,m,score,opened)))
            end 

            if canopenB
                for n in connectiondict[locA]
                    push!(scores,g((time+1,n,locB,score,[opened...,locB])))
                end
            elseif canopenA
                for m in connectiondict[locB]
                    push!(scores,g((time+1,locA,m,score,[opened...,locA])))
                end
            end

            if canopenA && canopenB
                push!(scores,g((time+1,locA,locB,score,[opened...,locA,locB])))
            end            
            
           return maximum(scores)
        end 

    g((1,"AA","AA",0,[]))
end

function recursive(flowdict, connectiondict)

    #shoutout to Rose for the code lmao
    m = Dict()

    function g(state)
        
        time, location, score, opened = state
        opened = copy(opened)

        score += sum([flowdict[o] for o in opened],init=0)

        if get(m,(time, location),-1) >= score
            return -1
        end

        m[(time,location)] = score

        if time == 30
            return score
        end

        scores = Int[]

        for n in connectiondict[location]
            push!(scores, g((time+1,n,score,opened)))
        end
        
        if flowdict[location] > 0 && !(location in opened)
            push!(opened,location)
            push!(scores,g((time+1,location,score,opened)))
        end

        return maximum(scores)
    end
    
    g((1,"AA",0,Set()))
end


function elephantdfs(flowdict, connectiondict, memory = Dict())

    function g(state,best)

        time, me, elephant, score, opened = state
        op = copy(opened)

        score += sum([flowdict[loc] for loc in op],init=0)

        if time == 26
            if score > best
                return score
            else
                return -1
            end
        end

        if get(memory,(time,me,elephant), -1) >= score || get(memory,(time,elephant,me),-1) >= score # Had better score here before
            return -1
        end

        memory[(time,me,elephant)] = score # Save score for this time & location
        memory[(time,elephant,me)] = score # Save score for this time & location


        scores = Int[]
               
        mecanopen = flowdict[me] > 0 && !(me in op)
        elephantcanopen = flowdict[elephant] > 0 && !(elephant in op) && elephant != me

        for neigh_me in connectiondict[me], neigh_eleph in connectiondict[elephant]
                push!(scores,g((time+1, neigh_me, neigh_eleph, score, op),best))
        end

        if elephantcanopen # (2) Only elephant opens valve
            push!(op,elephant)

            for neigh_me in connectiondict[me]
                push!(scores,g((time+1, neigh_me, elephant, score, op),best))
            end

            delete!(op,elephant)
        end

        if mecanopen # (3) Only I open valve
            push!(op,me)
            for neigh_elephant in connectiondict[elephant]
                push!(scores,g((time+1, me, neigh_elephant, score, op),best))
            end

            if elephantcanopen # (4) Both open valve
                push!(op,elephant)
                push!(scores,g((time+1, me, elephant, score, op),best))
            end
        end
        
        return maximum(scores)
    end

    best = g((1, "AA", "AA", 0, Set()),0)
    return best
end

function elephantdfs_i(flowdict, connectiondict, memory = Dict())

    best = 0
    stack = [(1, "AA", "AA", 0, [])]

    while !(isempty(stack))

        time, me, elephant, score, opened = pop!(stack)

        score += sum([flowdict[loc] for loc in opened],init=0)
        
        if time == 26
            if score > best
                best = score
            end
            continue # Times up, so try next one
        end   

        if get(memory,(time,me,elephant), -1) >= score || get(memory,(time,elephant,me),-1) >= score # Had better score here before
            continue
        end


        memory[(time,me,elephant)] = score # Save score for this time & location
        memory[(time,elephant,me)] = score # Save score for this time & location        

               
        mecanopen = flowdict[me] > 0 && !(me in opened)
        elephantcanopen = flowdict[elephant] > 0 && !(elephant in opened) && elephant != me

        for neigh_me in connectiondict[me], neigh_eleph in connectiondict[elephant]
                push!(stack,(time+1, neigh_me, neigh_eleph, score, opened))
        end

        if elephantcanopen # (2) Only elephant opens valve

            for neigh_me in connectiondict[me]
                push!(stack,(time+1, neigh_me, elephant, score, [opened...,elephant]))
            end


        elseif mecanopen # (3) Only I open valve

            for neigh_elephant in connectiondict[elephant]
                push!(stack,(time+1, me, neigh_elephant, score, [opened...,me]))
            end
        end

        if elephantcanopen && mecanopen # (4) Both open valve
            push!(stack,(time+1, me, elephant, score, [opened...,elephant,me]))
         end
    end


    return best
end

end

